-- ===========================================
-- ========== FUNCIONES DE USUARIO ===========
-- ===========================================

CREATE OR REPLACE FUNCTION obtener_usuario(p_nombre VARCHAR)
RETURNS TABLE (
    _usu_id UUID,
    _usu_nombre VARCHAR(100),
    _usu_nombre_completo VARCHAR(150),
    _usu_hash TEXT,
    _usu_activo BOOLEAN,
    _rol_nombre VARCHAR(100),
    _rol_id INT,
    _emp_id UUID,
    _emp_nombre VARCHAR(150),
    _emp_nombre_completo VARCHAR(150),
    _emp_activo BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.usu_id, u.usu_nombre, u.usu_nombrecompleto, u.usu_hash, u.usu_activo, r.rol_nombre, r.rol_id, e.emp_id, e.emp_nombre, e.emp_nombrecompleto, e.emp_activo
    FROM usuario u
    JOIN rol r ON u.usu_rol = r.rol_id
    LEFT JOIN empresa e ON u.usu_empresa = e.emp_id
    WHERE u.usu_nombre = p_nombre;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listar_usuarios()
RETURNS TABLE(
    _usu_id UUID,
    _usu_nombre VARCHAR(100),
    _usu_nombre_completo VARCHAR(150),
    _usu_activo BOOLEAN,
    _rol_nombre VARCHAR(100),
    _emp_nombre VARCHAR(150),
    _emp_nombre_completo VARCHAR(150)
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.usu_id, u.usu_nombre, u.usu_nombrecompleto, u.usu_activo, r.rol_nombre, e.emp_nombre, e.emp_nombrecompleto
    FROM usuario u
    JOIN rol r ON u.usu_rol = r.rol_id
    LEFT JOIN empresa e ON u.usu_empresa = e.emp_id;
END;
$$ LANGUAGE plpgsql;

-- Listar usuarios con rol Superusuario o Asesor
CREATE OR REPLACE FUNCTION listar_usuarios_superusuario_asesor()
RETURNS TABLE (
    usu_id UUID,
    usu_nombre VARCHAR(100),
    usu_nombre_completo VARCHAR(150),
    rol_nombre VARCHAR(100),
    usu_activo BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.Usu_ID,
        u.Usu_Nombre,
        u.Usu_NombreCompleto,
        r.Rol_Nombre,
        u.Usu_Activo
    FROM Usuario u
    JOIN Rol r ON u.Usu_Rol = r.Rol_ID
    WHERE r.Rol_Nombre IN ('Superusuario', 'Asesor');
END;
$$ LANGUAGE plpgsql;

-- Crear usuario Superusuario
CREATE OR REPLACE FUNCTION crear_usuario_superusuario(
    p_nombre VARCHAR(100),
    p_nombre_completo VARCHAR(150),
    p_hash TEXT
) RETURNS UUID AS $$
DECLARE
    v_id UUID;
    v_rol_id INT;
BEGIN
    SELECT Rol_ID INTO v_rol_id FROM Rol WHERE Rol_Nombre = 'Superusuario' LIMIT 1;
    IF v_rol_id IS NULL THEN
        RAISE EXCEPTION 'No existe el rol Superusuario';
    END IF;

    INSERT INTO Usuario (Usu_ID, Usu_Nombre, Usu_NombreCompleto, Usu_Hash, Usu_Rol, Usu_Activo)
    VALUES (uuid_generate_v4(), p_nombre, p_nombre_completo, p_hash, v_rol_id, TRUE)
    RETURNING Usu_ID INTO v_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- Crear usuario Asesor
CREATE OR REPLACE FUNCTION crear_usuario_asesor(
    p_nombre VARCHAR(100),
    p_nombre_completo VARCHAR(150),
    p_hash TEXT
) RETURNS UUID AS $$
DECLARE
    v_id UUID;
    v_rol_id INT;
BEGIN
    SELECT Rol_ID INTO v_rol_id FROM Rol WHERE Rol_Nombre = 'Asesor' LIMIT 1;
    IF v_rol_id IS NULL THEN
        RAISE EXCEPTION 'No existe el rol Asesor';
    END IF;

    INSERT INTO Usuario (Usu_ID, Usu_Nombre, Usu_NombreCompleto, Usu_Hash, Usu_Rol, Usu_Activo)
    VALUES (uuid_generate_v4(), p_nombre, p_nombre_completo, p_hash, v_rol_id, TRUE)
    RETURNING Usu_ID INTO v_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION agregar_usuario(
    p_nombre VARCHAR(100),
    p_nombre_completo VARCHAR(150),
    p_hash TEXT,
    p_rol INT,
    p_empresa UUID DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
    v_id UUID;
BEGIN
    INSERT INTO usuario (usu_nombre, usu_nombrecompleto, usu_hash, usu_rol, usu_empresa)
    VALUES (p_nombre, p_nombre_completo, p_hash, p_rol, p_empresa)
    RETURNING usu_id INTO v_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION eliminar_usuario(p_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM usuario WHERE usu_id = p_id;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION actualizar_usuario(
    p_id UUID,
    p_nombre VARCHAR(100) DEFAULT NULL,
    p_nombre_completo VARCHAR(150) DEFAULT NULL,
    p_hash TEXT DEFAULT NULL,
    p_rol INT DEFAULT NULL,
    p_empresa UUID DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
    UPDATE Usuario
    SET
        Usu_Nombre = COALESCE(p_nombre, Usu_Nombre),
        Usu_NombreCompleto = COALESCE(p_nombre_completo, Usu_NombreCompleto),
        Usu_Hash = COALESCE(p_hash, Usu_Hash),
        Usu_Rol = COALESCE(p_rol, Usu_Rol),
        Usu_Empresa = COALESCE(p_empresa, Usu_Empresa)
    WHERE Usu_ID = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_usuario_por_id(p_id UUID)
RETURNS TABLE(
    _usu_id UUID,
    _usu_nombre VARCHAR(100),
    _usu_nombre_completo VARCHAR(150),
    _usu_hash TEXT,
    _usu_activo BOOLEAN,
    _rol_nombre VARCHAR(100),
    _emp_nombre VARCHAR(150),
    _emp_nombre_completo VARCHAR(150),
    _emp_activo BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.usu_id, u.usu_nombre, u.usu_nombrecompleto, u.usu_hash, u.usu_activo, r.rol_nombre, e.emp_nombre, e.emp_nombrecompleto, e.emp_activo
    FROM usuario u
    JOIN rol r ON u.usu_rol = r.rol_id
    LEFT JOIN empresa e ON u.usu_empresa = e.emp_id
    WHERE u.usu_id = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cambiar_estado_usuario(
    p_usu_id UUID,
    p_activo BOOLEAN
) RETURNS VOID AS $$
BEGIN
    UPDATE Usuario
    SET Usu_Activo = p_activo
    WHERE Usu_ID = p_usu_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listar_usuarios_por_empresa(p_emp_id UUID)
RETURNS TABLE (
    _usu_id UUID,
    _usu_nombre VARCHAR(100),
    _usu_nombre_completo VARCHAR(150),
    _rol_id INT,
    _rol_nombre VARCHAR(100),
    _usu_activo BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.usu_id, u.usu_nombre, u.usu_nombrecompleto, r.rol_id, r.rol_nombre, u.usu_activo
    FROM usuario u
    JOIN rol r ON u.usu_rol = r.rol_id
    WHERE u.usu_empresa = p_emp_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_dias_restantes_por_usuario(p_usu_id UUID)
RETURNS INT AS $$
DECLARE
    v_fecha_inicio DATE;
    v_duracion INT;
    v_dias_restantes INT;
BEGIN
    SELECT e.Emp_FechaInicioPlan, p.Plan_Duracion
    INTO v_fecha_inicio, v_duracion
    FROM Usuario u
    JOIN Empresa e ON u.Usu_Empresa = e.Emp_ID
    JOIN Plan p ON e.Emp_Plan = p.Plan_ID
    WHERE u.Usu_ID = p_usu_id;

    v_dias_restantes := v_duracion - (CURRENT_DATE - v_fecha_inicio);
    RETURN GREATEST(v_dias_restantes, 0);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cambiar_contrasena_usuario(
    p_usu_id UUID,
    p_nueva_hash TEXT
) RETURNS VOID AS $$
BEGIN
    UPDATE Usuario
    SET Usu_Hash = p_nueva_hash
    WHERE Usu_ID = p_usu_id;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- ========== FUNCIONES DE ROLES =============
-- ===========================================

CREATE OR REPLACE FUNCTION obtener_id_rol(p_nombre VARCHAR(100))
RETURNS INT AS $$
DECLARE
    v_id INT;
BEGIN
    SELECT rol_id INTO v_id FROM rol WHERE rol_nombre = p_nombre;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_roles()
RETURNS TABLE(
    _rol_id INT,
    _rol_nombre VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    SELECT rol_id, rol_nombre FROM rol WHERE rol_nombre NOT IN ('Superusuario', 'Asesor', 'Empresa');
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- ========== FUNCIONES DE EMPRESA ===========
-- ===========================================

CREATE OR REPLACE FUNCTION agregar_empresa(
    p_nombre VARCHAR(150),
    p_nombre_completo VARCHAR(150),
    p_correo VARCHAR(150),
    p_hash TEXT
) RETURNS UUID AS $$
DECLARE
    v_emp_id UUID;
    v_rol_empresa_id INT;
BEGIN
    -- Insertar empresa
    INSERT INTO Empresa (Emp_Nombre, Emp_NombreCompleto, Emp_Correo, Emp_Hash, Emp_Plan, Emp_Activo)
    VALUES (p_nombre, p_nombre_completo, p_correo, p_hash, 2, TRUE)
    RETURNING Emp_ID INTO v_emp_id;

    -- Obtener ID del rol "empresa"
    SELECT obtener_id_rol('Empresa') INTO v_rol_empresa_id;

    -- Crear usuario principal con rol empresa
    INSERT INTO Usuario (Usu_Nombre, Usu_NombreCompleto, Usu_Hash, Usu_Rol, Usu_Empresa)
    VALUES (p_nombre, p_nombre_completo, p_hash, v_rol_empresa_id, v_emp_id);

    RETURN v_emp_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION eliminar_empresa(p_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM Empresa WHERE Emp_ID = p_id;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION actualizar_empresa(
    p_id UUID,
    p_nombre VARCHAR(150) DEFAULT NULL,
    p_nombre_completo VARCHAR(150) DEFAULT NULL,
    p_correo VARCHAR(150) DEFAULT NULL,
    p_hash TEXT DEFAULT NULL,
    p_plan INT DEFAULT NULL,
    p_activo BOOLEAN DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
    UPDATE Empresa
    SET
        Emp_Nombre = COALESCE(p_nombre, Emp_Nombre),
        Emp_NombreCompleto = COALESCE(p_nombre_completo, Emp_NombreCompleto),
        Emp_Correo = COALESCE(p_correo, Emp_Correo),
        Emp_Hash = COALESCE(p_hash, Emp_Hash),
        Emp_Plan = COALESCE(p_plan, Emp_Plan),
        Emp_Activo = COALESCE(p_activo, Emp_Activo),
        Emp_Actualizado = CURRENT_TIMESTAMP
    WHERE Emp_ID = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listar_empresas()
RETURNS TABLE(
    _Emp_ID UUID,
    _Emp_Nombre VARCHAR(150),
    _Emp_NombreCompleto VARCHAR(150),
    _Emp_Correo VARCHAR(150),
    _Emp_FechaRegistro TIMESTAMP,
    _Emp_Activo BOOLEAN,
    _Emp_FechaInicio DATE,
    _Plan_Nombre VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    SELECT e.Emp_ID, e.Emp_Nombre, e.Emp_NombreCompleto, e.Emp_Correo, e.Emp_Creado, e.Emp_Activo, e.Emp_FechaInicioPlan, p.Plan_Nombre
    FROM Empresa e
    JOIN Plan p ON e.Emp_Plan = p.Plan_ID;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_empresa_por_correo(p_correo VARCHAR(150))
RETURNS TABLE (
    _Emp_ID UUID,
    _Emp_Nombre VARCHAR(150),
    _Emp_NombreCompleto VARCHAR(150),
    _Emp_Correo VARCHAR(150),
    _Emp_Hash TEXT,
    _Emp_Activo BOOLEAN,
    _Emp_FechaInicioPlan DATE,
    _Plan_Nombre VARCHAR(100),
    _Plan_Duracion INT,
    _Plan_Almacenamiento BIGINT,
    _Plan_MaxUsuarios INT,
    _Plan_Precio DECIMAL(10, 2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.Emp_ID,
        e.Emp_Nombre,
        e.Emp_NombreCompleto,
        e.Emp_Correo,
        e.Emp_Hash,
        e.Emp_Activo,
        e.Emp_FechaInicioPlan,
        p.Plan_Nombre,
        p.Plan_Duracion,
        p.Plan_Almacenamiento,
        p.Plan_MaxUsuarios,
        p.Plan_Precio
    FROM Empresa e
    JOIN Plan p ON e.Emp_Plan = p.Plan_ID
    WHERE e.Emp_Correo = p_correo;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_empresa_por_nombre(p_nombre VARCHAR(150))
RETURNS TABLE (
    _Emp_ID UUID,
    _Emp_Nombre VARCHAR(150),
    _Emp_NombreCompleto VARCHAR(150),
    _Emp_Correo VARCHAR(150),
    _Emp_Hash TEXT,
    _Emp_Activo BOOLEAN,
    _Plan_Nombre VARCHAR(100),
    _Plan_Duracion INT,
    _Plan_Almacenamiento BIGINT,
    _Plan_MaxUsuarios INT,
    _Plan_Precio DECIMAL(10, 2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.Emp_ID,
        e.Emp_Nombre,
        e.Emp_NombreCompleto,
        e.Emp_Correo,
        e.Emp_Hash,
        e.Emp_Activo,
        p.Plan_Nombre,
        p.Plan_Duracion,
        p.Plan_Almacenamiento,
        p.Plan_MaxUsuarios,
        p.Plan_Precio
    FROM Empresa e
    JOIN Plan p ON e.Emp_Plan = p.Plan_ID
    WHERE e.Emp_Nombre = p_nombre;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cambiar_estado_empresa(
    p_id UUID,
    p_activo BOOLEAN
) RETURNS VOID AS $$
BEGIN
    UPDATE Empresa
    SET Emp_Activo = p_activo
    WHERE Emp_ID = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION empresa_puede_registrar_usuario(p_emp_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_max_usuarios INT;
    v_usuarios_actuales INT;
BEGIN
    -- Obtener el máximo de usuarios permitidos por el plan de la empresa
    SELECT p.Plan_MaxUsuarios
    INTO v_max_usuarios
    FROM Empresa e
    JOIN Plan p ON e.Emp_Plan = p.Plan_ID
    WHERE e.Emp_ID = p_emp_id;

    -- Contar usuarios activos de la empresa
    SELECT COUNT(*) INTO v_usuarios_actuales
    FROM Usuario
    WHERE Usu_Empresa = p_emp_id AND Usu_Activo = TRUE;

    -- Retornar TRUE si puede registrar más usuarios, FALSE si llegó al límite
    RETURN v_usuarios_actuales < v_max_usuarios;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_dias_restantes_por_empresa(p_id UUID)
RETURNS INT AS $$
DECLARE
    v_fecha_inicio DATE;
    v_duracion INT;
    v_dias_restantes INT;
BEGIN
    SELECT e.Emp_FechaInicioPlan, p.Plan_Duracion
    INTO v_fecha_inicio, v_duracion
    FROM Empresa e
    JOIN Plan p ON e.Emp_Plan = p.Plan_ID
    WHERE e.Emp_ID = p_id;

    v_dias_restantes := v_duracion - (CURRENT_DATE - v_fecha_inicio);
    RETURN GREATEST(v_dias_restantes, 0);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cambiar_contrasena_empresa(
    p_emp_id UUID,
    p_nueva_hash TEXT
) RETURNS VOID AS $$
BEGIN
    UPDATE Empresa
    SET Emp_Hash = p_nueva_hash
    WHERE Emp_ID = p_emp_id;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- ========== FUNCIONES DE DOCUMENTOS ========
-- ===========================================

-- ...otras funciones...

CREATE OR REPLACE FUNCTION insertar_documento(
    p_nombre VARCHAR(255),
    p_url TEXT,
    p_tipo VARCHAR(50),
    p_tamanio BIGINT,
    p_subido_por UUID,
    p_empresa UUID
) RETURNS UUID AS $$
DECLARE
    v_doc_id UUID;
BEGIN
    INSERT INTO Documento (
        Doc_Nombre, Doc_Url, Doc_Tipo, Doc_Tamanio, Doc_SubidoPor, Doc_Empresa
    ) VALUES (
        p_nombre, p_url, p_tipo, p_tamanio, p_subido_por, p_empresa
    )
    RETURNING Doc_ID INTO v_doc_id;

    RETURN v_doc_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION actualizar_documento(
    p_doc_id UUID,
    p_nombre VARCHAR(255) DEFAULT NULL,
    p_url TEXT DEFAULT NULL,
    p_tipo VARCHAR(50) DEFAULT NULL,
    p_tamanio BIGINT DEFAULT NULL,
    p_subido_por UUID DEFAULT NULL,
    p_empresa UUID DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
    UPDATE Documento
    SET
        Doc_Nombre = COALESCE(p_nombre, Doc_Nombre),
        Doc_Url = COALESCE(p_url, Doc_Url),
        Doc_Tipo = COALESCE(p_tipo, Doc_Tipo),
        Doc_Tamanio = COALESCE(p_tamanio, Doc_Tamanio),
        Doc_SubidoPor = COALESCE(p_subido_por, Doc_SubidoPor),
        Doc_Empresa = COALESCE(p_empresa, Doc_Empresa)
    WHERE Doc_ID = p_doc_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listar_documentos_por_empresa(p_empresa UUID)
RETURNS TABLE (
    _doc_id UUID,
    _doc_nombre VARCHAR(255),
    _doc_url TEXT,
    _doc_tipo VARCHAR(50),
    _doc_tamanio BIGINT,
    _doc_subido_por UUID,
    _usuario_nombre_completo VARCHAR(150),
    _doc_fecha TIMESTAMP,
    _emp_nombre VARCHAR(150),
    _emp_nombre_completo VARCHAR(150)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d.Doc_ID,
        d.Doc_Nombre,
        d.Doc_Url,
        d.Doc_Tipo,
        d.Doc_Tamanio,
        d.Doc_SubidoPor,
        u.Usu_NombreCompleto,
        d.Doc_Fecha,
        e.Emp_Nombre,
        e.Emp_NombreCompleto
    FROM Documento d
    JOIN Empresa e ON d.Doc_Empresa = e.Emp_ID
    LEFT JOIN Usuario u ON d.Doc_SubidoPor = u.Usu_ID
    WHERE d.Doc_Empresa = p_empresa;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION eliminar_documento(p_doc_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM Documento WHERE Doc_ID = p_doc_id;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_documento_por_id(p_doc_id UUID)
RETURNS TABLE (
    _doc_id UUID,
    _doc_nombre VARCHAR(255),
    _doc_url TEXT,
    _doc_tipo VARCHAR(50),
    _doc_tamanio BIGINT,
    _doc_subido_por UUID,
    _usuario_nombre_completo VARCHAR(150),
    _doc_fecha TIMESTAMP,
    _emp_nombre VARCHAR(150),
    _emp_nombre_completo VARCHAR(150)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d.Doc_ID,
        d.Doc_Nombre,
        d.Doc_Url,
        d.Doc_Tipo,
        d.Doc_Tamanio,
        d.Doc_SubidoPor,
        u.Usu_NombreCompleto,
        d.Doc_Fecha,
        e.Emp_Nombre,
        e.Emp_NombreCompleto
    FROM Documento d
    JOIN Empresa e ON d.Doc_Empresa = e.Emp_ID
    LEFT JOIN Usuario u ON d.Doc_SubidoPor = u.Usu_ID
    WHERE d.Doc_ID = p_doc_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION buscar_documento_por_ruta_y_empresa(
    p_ruta TEXT,
    p_empresa UUID
)
RETURNS TABLE (
    doc_id UUID,
    doc_nombre VARCHAR(255),
    doc_url TEXT,
    doc_tipo VARCHAR(50),
    doc_tamanio BIGINT,
    doc_subido_por UUID,
    doc_fecha TIMESTAMP,
    emp_nombre VARCHAR(150),
    emp_nombre_completo VARCHAR(150)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d.Doc_ID,
        d.Doc_Nombre,
        d.Doc_Url,
        d.Doc_Tipo,
        d.Doc_Tamanio,
        d.Doc_SubidoPor,
        d.Doc_Fecha,
        e.Emp_Nombre,
        e.Emp_NombreCompleto
    FROM Documento d
    JOIN Empresa e ON d.Doc_Empresa = e.Emp_ID
    WHERE d.Doc_Url = p_ruta
      AND d.Doc_Empresa = p_empresa;
END;
$$ LANGUAGE plpgsql;

-- ===============================================
-- ========== FUNCIONES DE NOTIFICACIONES ========
-- ===============================================

CREATE OR REPLACE FUNCTION insertar_notificacion(
    p_titulo VARCHAR(255),
    p_mensaje TEXT,
    p_usuarios UUID[]
) RETURNS UUID AS $$
DECLARE
    v_id UUID;
    v_usuario UUID;
BEGIN
    INSERT INTO Notificacion (Not_ID, Not_Titulo, Not_Mensaje, Not_Fecha)
    VALUES (uuid_generate_v4(), p_titulo, p_mensaje, CURRENT_TIMESTAMP)
    RETURNING Not_ID INTO v_id;

    FOREACH v_usuario IN ARRAY p_usuarios LOOP
        INSERT INTO NotificacionUsuario (NotUsu_Notificacion, NotUsu_Usuario)
        VALUES (v_id, v_usuario);
    END LOOP;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listar_notificaciones_usuario(
    p_usuario UUID
) RETURNS TABLE (
    not_id UUID,
    titulo VARCHAR,
    mensaje TEXT,
    fecha TIMESTAMP,
    recibida BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        n.Not_ID,
        n.Not_Titulo,
        n.Not_Mensaje,
        n.Not_Fecha,
        nu.NotUsu_Recibida
    FROM Notificacion n
    INNER JOIN NotificacionUsuario nu ON nu.NotUsu_Notificacion = n.Not_ID
    WHERE nu.NotUsu_Usuario = p_usuario;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION marcar_notificacion_recibida(
    p_notificacion UUID,
    p_usuario UUID
) RETURNS VOID AS $$
BEGIN
    UPDATE NotificacionUsuario
    SET NotUsu_Recibida = TRUE
    WHERE NotUsu_Notificacion = p_notificacion AND NotUsu_Usuario = p_usuario;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION eliminar_notificacion_usuario(
    p_notificacion UUID,
    p_usuario UUID
) RETURNS VOID AS $$
BEGIN
    DELETE FROM NotificacionUsuario
    WHERE NotUsu_Notificacion = p_notificacion AND NotUsu_Usuario = p_usuario;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION enviar_notificacion_a_empresa(
    p_titulo VARCHAR(255),
    p_mensaje TEXT,
    p_empresa UUID
) RETURNS UUID AS $$
DECLARE
    v_id UUID;
    v_usuario UUID;
BEGIN
    -- Crear la notificación
    INSERT INTO Notificacion (Not_ID, Not_Titulo, Not_Mensaje, Not_Fecha)
    VALUES (uuid_generate_v4(), p_titulo, p_mensaje, CURRENT_TIMESTAMP)
    RETURNING Not_ID INTO v_id;

    -- Asignar la notificación a todos los usuarios activos de la empresa
    FOR v_usuario IN
        SELECT Usu_ID FROM Usuario WHERE Usu_Empresa = p_empresa AND Usu_Activo = TRUE
    LOOP
        INSERT INTO NotificacionUsuario (NotUsu_Notificacion, NotUsu_Usuario)
        VALUES (v_id, v_usuario);
    END LOOP;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION eliminar_notificaciones_usuario(
    p_usuario UUID
) RETURNS VOID AS $$
BEGIN
    DELETE FROM NotificacionUsuario
    WHERE NotUsu_Usuario = p_usuario;
END;
$$ LANGUAGE plpgsql;

-- ===============================================
-- ========== FUNCIONES DE AUDITORÍA ========
-- ===============================================

-- ===========================================
-- ========== HISTORIAL DE AUDITORÍA =========
-- ===========================================

-- Historial de auditoría de una empresa (LogEmpresa)
CREATE OR REPLACE FUNCTION obtener_historial_auditoria_empresa(p_empresa UUID)
RETURNS TABLE (
    log_id UUID,
    tabla VARCHAR(50),
    registro UUID,
    tipo VARCHAR(50),
    descripcion TEXT,
    fecha TIMESTAMP,
    usuario UUID,
    usuario_nombre VARCHAR(150),
    empresa_nombre VARCHAR(150)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        LogEmp_ID,
        LogEmp_Tabla,
        LogEmp_Registro,
        LogEmp_Tipo,
        LogEmp_Descripcion,
        LogEmp_Fecha,
        LogEmp_Usuario,
        LogEmp_NombreUsuario,
        LogEmp_NombreEmpresa
    FROM LogEmpresa
    WHERE LogEmp_Empresa = p_empresa
    ORDER BY LogEmp_Fecha DESC;
END;
$$ LANGUAGE plpgsql;

-- Historial de auditoría de un usuario (LogEmpresa)
CREATE OR REPLACE FUNCTION obtener_historial_auditoria_usuario(p_usuario UUID)
RETURNS TABLE (
    log_id UUID,
    empresa UUID,
    tabla VARCHAR(50),
    registro UUID,
    tipo VARCHAR(50),
    descripcion TEXT,
    fecha TIMESTAMP,
    usuario_nombre VARCHAR(150),
    empresa_nombre VARCHAR(150)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        LogEmp_ID,
        LogEmp_Empresa,
        LogEmp_Tabla,
        LogEmp_Registro,
        LogEmp_Tipo,
        LogEmp_Descripcion,
        LogEmp_Fecha,
        LogEmp_NombreUsuario,
        LogEmp_NombreEmpresa
    FROM LogEmpresa
    WHERE LogEmp_Usuario = p_usuario
    ORDER BY LogEmp_Fecha DESC;
END;
$$ LANGUAGE plpgsql;

-- Historial de auditoría general (LogActividad)
CREATE OR REPLACE FUNCTION obtener_historial_actividad()
RETURNS TABLE (
    _log_id UUID,
    _tabla VARCHAR(50),
    _registro UUID,
    _tipo VARCHAR(50),
    _descripcion TEXT,
    _fecha TIMESTAMP,
    _usuario UUID,
    _usuario_nombre VARCHAR(150),
    _datos_anteriores JSONB,
    _datos_nuevos JSONB
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        Log_ID,
        Log_Tabla,
        Log_Registro,
        Log_Tipo,
        Log_Descripcion,
        Log_Fecha,
        Log_Usuario,
        Log_NombreUsuario,
        Log_DatosAnteriores,
        Log_DatosNuevos
    FROM LogActividad
    ORDER BY Log_Fecha DESC;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION eliminar_logs_actividad_antiguos(
    p_fecha_limite TIMESTAMP
) RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    DELETE FROM LogActividad WHERE Log_Fecha < p_fecha_limite;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN COALESCE(v_count, 0);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION eliminar_logs_empresa_antiguos(
    p_fecha_limite TIMESTAMP
) RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    DELETE FROM LogEmpresa WHERE LogEmp_Fecha < p_fecha_limite RETURNING 1 INTO v_count;
    RETURN COALESCE(v_count, 0);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION eliminar_todos_logs_antiguos(
    p_fecha_limite TIMESTAMP
) RETURNS INTEGER AS $$
DECLARE
    v_count_actividad INTEGER := 0;
    v_count_empresa INTEGER := 0;
BEGIN
    DELETE FROM LogActividad WHERE Log_Fecha < p_fecha_limite RETURNING 1 INTO v_count_actividad;
    DELETE FROM LogEmpresa WHERE LogEmp_Fecha < p_fecha_limite RETURNING 1 INTO v_count_empresa;
    RETURN COALESCE(v_count_actividad, 0) + COALESCE(v_count_empresa, 0);
END;
$$ LANGUAGE plpgsql;

-- ===============================================
-- ========== FUNCIONES DE CHAT ========
-- ===============================================

-- Insertar mensaje en chat
CREATE OR REPLACE FUNCTION insertar_chat_mensaje(
    p_remitente UUID,
    p_destinatario UUID,
    p_mensaje TEXT,
    p_empresa UUID,
    p_room VARCHAR
) RETURNS UUID AS $$
DECLARE
    v_id UUID;
BEGIN
    INSERT INTO ChatMensaje (Chat_Remitente, Chat_Destinatario, Chat_Mensaje, Chat_Empresa, Chat_Room)
    VALUES (p_remitente, p_destinatario, p_mensaje, p_empresa, p_room)
    RETURNING Chat_ID INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- Listar mensajes entre dos usuarios (en una empresa)
CREATE OR REPLACE FUNCTION listar_chat_mensajes(
    p_room VARCHAR
) RETURNS TABLE (
    chat_id UUID,
    remitente UUID,
    destinatario UUID,
    mensaje TEXT,
    fecha TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT Chat_ID, Chat_Remitente, Chat_Destinatario, Chat_Mensaje, Chat_Fecha
    FROM ChatMensaje
    WHERE Chat_Room = p_room
    ORDER BY Chat_Fecha ASC;
END;
$$ LANGUAGE plpgsql;

-- Listar últimos mensajes por usuario en una empresa (bandeja de entrada)
CREATE OR REPLACE FUNCTION listar_ultimos_chats_usuario(
    p_usuario UUID,
    p_empresa UUID
) RETURNS TABLE (
    chat_id UUID,
    remitente UUID,
    destinatario UUID,
    mensaje TEXT,
    fecha TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT ON (LEAST(Chat_Remitente, Chat_Destinatario), GREATEST(Chat_Remitente, Chat_Destinatario))
        Chat_ID, Chat_Remitente, Chat_Destinatario, Chat_Mensaje, Chat_Fecha
    FROM ChatMensaje
    WHERE (Chat_Remitente = p_usuario OR Chat_Destinatario = p_usuario)
      AND Chat_Empresa = p_empresa
    ORDER BY LEAST(Chat_Remitente, Chat_Destinatario), GREATEST(Chat_Remitente, Chat_Destinatario), Chat_Fecha DESC;
END;
$$ LANGUAGE plpgsql;

-- Eliminar mensaje por ID
CREATE OR REPLACE FUNCTION eliminar_chat_mensaje(
    p_chat_id UUID
) RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM ChatMensaje WHERE Chat_ID = p_chat_id;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION eliminar_mensajes_por_room(
    p_room VARCHAR
) RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    DELETE FROM ChatMensaje
    WHERE Chat_Room = p_room
    RETURNING 1 INTO v_count;

    RETURN COALESCE(v_count, 0);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION listar_rooms_usuario(
    p_usuario UUID
) RETURNS TABLE (
    room VARCHAR,
    ultimo_mensaje TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT Chat_Room, MAX(Chat_Fecha) as ultimo_mensaje
    FROM ChatMensaje
    WHERE Chat_Remitente = p_usuario OR Chat_Destinatario = p_usuario
    GROUP BY Chat_Room
    ORDER BY ultimo_mensaje DESC;
END;
$$ LANGUAGE plpgsql;