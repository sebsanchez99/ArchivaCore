-- ===========================================
-- ========== FUNCIONES DE AUDITORÍA =========
-- ===========================================

-- Función para insertar en LogActividad (auditoría global)CREATE OR REPLACE FUNCTION fn_log_actividad()
CREATE OR REPLACE FUNCTION fn_log_actividad()
RETURNS TRIGGER AS $$
DECLARE
    v_usuario UUID := NULL;
    v_registro UUID := NULL;
    v_nombre_usuario VARCHAR(150) := NULL;
BEGIN
    IF TG_TABLE_NAME = 'usuario' THEN
        v_registro := COALESCE(NEW.usu_id, OLD.usu_id);
        IF TG_OP <> 'DELETE' THEN
            v_usuario := COALESCE(NEW.usu_id, OLD.usu_id);
            v_nombre_usuario := COALESCE(NEW.usu_nombrecompleto, OLD.usu_nombrecompleto);
        ELSE
            v_usuario := NULL;
            v_nombre_usuario := COALESCE(OLD.usu_nombrecompleto, NEW.usu_nombrecompleto);
        END IF;
    ELSIF TG_TABLE_NAME = 'empresa' THEN
        v_registro := COALESCE(NEW.emp_id, OLD.emp_id);
        v_usuario := NULL;
        v_nombre_usuario := NULL;
    ELSIF TG_TABLE_NAME = 'documento' THEN
        v_registro := COALESCE(NEW.doc_id, OLD.doc_id);
        IF TG_OP <> 'DELETE' THEN
            v_usuario := COALESCE(NEW.doc_subidopor, OLD.doc_subidopor);
            SELECT usu_nombrecompleto INTO v_nombre_usuario
            FROM Usuario WHERE usu_id = v_usuario;
        ELSE
            v_usuario := NULL;
            v_nombre_usuario := NULL;
        END IF;
    ELSIF TG_TABLE_NAME = 'notificacion' THEN
        v_registro := COALESCE(NEW.not_id, OLD.not_id);
        v_usuario := NULL;
        v_nombre_usuario := NULL;
    END IF;

    INSERT INTO LogActividad (
        Log_Tabla,
        Log_Registro,
        Log_Tipo,
        Log_Descripcion,
        Log_Usuario,
        Log_NombreUsuario,
        Log_DatosAnteriores,
        Log_DatosNuevos
    )
    VALUES (
        TG_TABLE_NAME,
        v_registro,
        TG_OP,
        TG_OP || ' en ' || TG_TABLE_NAME,
        v_usuario,
        v_nombre_usuario,
        to_jsonb(OLD),
        to_jsonb(NEW)
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Función para insertar en LogEmpresa (auditoría por empresa)
CREATE OR REPLACE FUNCTION fn_log_empresa()
RETURNS TRIGGER AS $$
DECLARE
    v_empresa UUID := NULL;
    v_usuario UUID := NULL;
    v_registro UUID := NULL;
    v_desc TEXT;
    v_nombre_empresa VARCHAR(150) := NULL;
    v_nombre_usuario VARCHAR(150) := NULL;
BEGIN
    IF TG_TABLE_NAME = 'usuario' THEN
        v_empresa := COALESCE(NEW.usu_empresa, OLD.usu_empresa);
        v_registro := COALESCE(NEW.usu_id, OLD.usu_id);
        IF TG_OP <> 'DELETE' THEN
            v_usuario := COALESCE(NEW.usu_id, OLD.usu_id);
            v_nombre_usuario := COALESCE(NEW.usu_nombrecompleto, OLD.usu_nombrecompleto);
        ELSE
            v_usuario := NULL;
            v_nombre_usuario := COALESCE(OLD.usu_nombrecompleto, NEW.usu_nombrecompleto);
        END IF;
        v_desc := TG_OP || ' usuario: ' || COALESCE(NEW.usu_nombre, OLD.usu_nombre);
    ELSIF TG_TABLE_NAME = 'empresa' THEN
        v_registro := COALESCE(NEW.emp_id, OLD.emp_id);
        v_usuario := NULL;
        v_nombre_usuario := NULL;
        v_desc := TG_OP || ' empresa: ' || COALESCE(NEW.emp_nombre, OLD.emp_nombre);
        IF TG_OP = 'DELETE' THEN
            v_empresa := NULL;
            v_nombre_empresa := COALESCE(OLD.emp_nombre, NEW.emp_nombre);
        ELSE
            v_empresa := COALESCE(NEW.emp_id, OLD.emp_id);
            v_nombre_empresa := COALESCE(NEW.emp_nombre, OLD.emp_nombre);
        END IF;
    ELSIF TG_TABLE_NAME = 'documento' THEN
        v_empresa := COALESCE(NEW.doc_empresa, OLD.doc_empresa);
        v_registro := COALESCE(NEW.doc_id, OLD.doc_id);
        IF TG_OP <> 'DELETE' THEN
            v_usuario := COALESCE(NEW.doc_subidopor, OLD.doc_subidopor);
            v_nombre_usuario := NULL; -- Puedes hacer un JOIN si quieres traer el nombre aquí también
        ELSE
            v_usuario := NULL;
            v_nombre_usuario := NULL;
        END IF;
        v_desc := TG_OP || ' documento: ' || COALESCE(NEW.doc_nombre, OLD.doc_nombre);
    ELSIF TG_TABLE_NAME = 'notificacion' THEN
        v_empresa := NULL;
        v_registro := COALESCE(NEW.not_id, OLD.not_id);
        v_usuario := NULL;
        v_nombre_usuario := NULL;
        v_desc := TG_OP || ' notificación: ' || COALESCE(NEW.not_titulo, OLD.not_titulo);
    END IF;

    IF TG_TABLE_NAME = 'empresa' OR v_empresa IS NOT NULL OR TG_TABLE_NAME = 'notificacion' THEN
        INSERT INTO LogEmpresa (
            LogEmp_Empresa,
            LogEmp_Tabla,
            LogEmp_Registro,
            LogEmp_Tipo,
            LogEmp_Descripcion,
            LogEmp_Usuario,
            LogEmp_NombreEmpresa,
            LogEmp_NombreUsuario
        )
        VALUES (
            v_empresa,
            TG_TABLE_NAME,
            v_registro,
            TG_OP,
            v_desc,
            v_usuario,
            v_nombre_empresa,
            v_nombre_usuario
        );
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- ========== TRIGGER AVANZADO: DESACTIVAR Y RESTAURAR USUARIOS ==========
-- ===========================================
CREATE OR REPLACE FUNCTION fn_empresa_backup_usuarios()
RETURNS TRIGGER AS $$
BEGIN
    -- Si se desactiva la empresa, guarda el estado actual de los usuarios y desactívalos
    IF OLD.Emp_Activo = TRUE AND NEW.Emp_Activo = FALSE THEN
        DELETE FROM UsuarioBackup WHERE Empresa = NEW.Emp_ID;
        INSERT INTO UsuarioBackup (Empresa, Usuario, Estado)
        SELECT Usu_Empresa, Usu_ID, Usu_Activo
        FROM Usuario
        WHERE Usu_Empresa = NEW.Emp_ID;
        UPDATE Usuario
        SET Usu_Activo = FALSE
        WHERE Usu_Empresa = NEW.Emp_ID;
    -- Si se reactiva la empresa, restaura el estado anterior de los usuarios y limpia el backup
    ELSIF OLD.Emp_Activo = FALSE AND NEW.Emp_Activo = TRUE THEN
        UPDATE Usuario u
        SET Usu_Activo = b.Estado
        FROM UsuarioBackup b
        WHERE u.Usu_ID = b.Usuario AND b.Empresa = NEW.Emp_ID;
        DELETE FROM UsuarioBackup WHERE Empresa = NEW.Emp_ID;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- ========== TRIGGER: FECHA MODIFICACIÓN ====
-- ===========================================

-- Actualiza Emp_Actualizado al modificar Empresa
CREATE OR REPLACE FUNCTION fn_empresa_set_actualizado()
RETURNS TRIGGER AS $$
BEGIN
    NEW.Emp_Actualizado := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_empresa_set_actualizado
BEFORE UPDATE ON Empresa
FOR EACH ROW
EXECUTE FUNCTION fn_empresa_set_actualizado();

-- ===========================================
-- ========== TRIGGER: DESACTIVAR USUARIOS ===
-- ===========================================

-- Desactiva usuarios al desactivar la empresa
CREATE OR REPLACE FUNCTION fn_empresa_desactiva_usuarios()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.Emp_Activo = TRUE AND NEW.Emp_Activo = FALSE THEN
        UPDATE Usuario
        SET Usu_Activo = FALSE
        WHERE Usu_Empresa = NEW.Emp_ID;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- ========== TRIGGER: ELIMINAR EN CASCADA ===
-- ===========================================

-- Elimina documentos y notificaciones de usuario antes de eliminar el usuario
CREATE OR REPLACE FUNCTION fn_usuario_delete_cascade()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM Documento WHERE Doc_SubidoPor = OLD.Usu_ID;
    DELETE FROM NotificacionUsuario WHERE NotUsu_Usuario = OLD.Usu_ID;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_usuario_delete_cascade
BEFORE DELETE ON Usuario
FOR EACH ROW
EXECUTE FUNCTION fn_usuario_delete_cascade();

-- ===========================================
-- ========== TRIGGERS USUARIO ===============
-- ===========================================

CREATE TRIGGER trg_usuario_log_actividad
AFTER INSERT OR UPDATE OR DELETE ON Usuario
FOR EACH ROW EXECUTE FUNCTION fn_log_actividad();

CREATE TRIGGER trg_usuario_log_empresa
AFTER INSERT OR UPDATE OR DELETE ON Usuario
FOR EACH ROW EXECUTE FUNCTION fn_log_empresa();

-- ===========================================
-- ========== TRIGGERS EMPRESA ===============
-- ===========================================

CREATE TRIGGER trg_empresa_log_actividad
AFTER INSERT OR UPDATE OR DELETE ON Empresa
FOR EACH ROW EXECUTE FUNCTION fn_log_actividad();

CREATE TRIGGER trg_empresa_log_empresa
AFTER INSERT OR UPDATE OR DELETE ON Empresa
FOR EACH ROW EXECUTE FUNCTION fn_log_empresa();

CREATE TRIGGER trg_empresa_desactiva_usuarios
AFTER UPDATE ON Empresa
FOR EACH ROW
EXECUTE FUNCTION fn_empresa_backup_usuarios();

-- ===========================================
-- ========== TRIGGERS NOTIFICACIÓN ==========
-- ===========================================

CREATE TRIGGER trg_notificacion_log_actividad
AFTER INSERT OR UPDATE OR DELETE ON Notificacion
FOR EACH ROW EXECUTE FUNCTION fn_log_actividad();

CREATE TRIGGER trg_notificacion_log_empresa
AFTER INSERT OR UPDATE OR DELETE ON Notificacion
FOR EACH ROW EXECUTE FUNCTION fn_log_empresa();