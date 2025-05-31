-- FUNCIONES DE USUARIO
CREATE OR REPLACE FUNCTION obtener_usuario(p_nombre VARCHAR)
RETURNS TABLE (
    _usu_id UUID,
    _usu_nombre VARCHAR(100),
    _usu_hash TEXT,
    _rol_nombre VARCHAR(100),
    _emp_nombre VARCHAR(150)
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.usu_id, u.usu_nombre, u.usu_hash, r.rol_nombre, e.emp_nombre
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
    _rol_nombre VARCHAR(100),
    _emp_nombre VARCHAR(150)
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.usu_id, u.usu_nombre, r.rol_nombre, e.emp_nombre
    FROM usuario u
    JOIN rol r ON u.usu_rol = r.rol_id
    LEFT JOIN empresa e ON u.usu_empresa = e.emp_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_id_rol(p_nombre VARCHAR(100))
RETURNS INT AS $$
DECLARE
    v_id INT;
BEGIN
    SELECT rol_id INTO v_id FROM rol WHERE rol_nombre = p_nombre;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION agregar_usuario(
    p_nombre VARCHAR(100),
    p_hash TEXT,
    p_rol INT,
    p_empresa UUID DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
    v_id UUID;
BEGIN
    INSERT INTO usuario (usu_id, usu_nombre, usu_hash, usu_rol, usu_empresa)
    VALUES (uuid_generate_v4(), p_nombre, p_hash, p_rol, p_empresa)
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
    p_nombre VARCHAR(100),
    p_hash TEXT,
    p_rol INT,
    p_empresa UUID DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
    UPDATE usuario
    SET usu_nombre = p_nombre,
        usu_hash = p_hash,
        usu_rol = p_rol,
        usu_empresa = p_empresa
    WHERE usu_id = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_usuario_por_id(p_id UUID)
RETURNS TABLE(
    _usu_id UUID,
    _usu_nombre VARCHAR(100),
    _usu_hash TEXT,
    _rol_nombre VARCHAR(100),
    _emp_nombre VARCHAR(150)
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.usu_id, u.usu_nombre, u.usu_hash, r.rol_nombre, e.emp_nombre
    FROM usuario u
    JOIN rol r ON u.usu_rol = r.rol_id
    LEFT JOIN empresa e ON u.usu_empresa = e.emp_id
    WHERE u.usu_id = p_id;
END;
$$ LANGUAGE plpgsql;

-- FUNCIONES DE EMPRESA
CREATE OR REPLACE FUNCTION agregar_empresa(
    p_nombre VARCHAR(150),
    p_correo VARCHAR(150),
    p_hash TEXT
) RETURNS UUID AS $$
DECLARE
    v_id UUID;
BEGIN
    INSERT INTO Empresa (Emp_ID, Emp_Nombre, Emp_Correo, Emp_Hash, Emp_Plan, Emp_Activo)
    VALUES (uuid_generate_v4(), p_nombre, p_correo, p_hash, 2, TRUE)
    RETURNING Emp_ID INTO v_id;

    RETURN v_id;
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
    p_nombre VARCHAR(150),
    p_correo VARCHAR(150),
    p_hash TEXT,
    p_plan INT,
    p_activo BOOLEAN
) RETURNS VOID AS $$
BEGIN
    UPDATE Empresa
    SET Emp_Nombre = p_nombre,
        Emp_Correo = p_correo,
        Emp_Hash = p_hash,
        Emp_Plan = p_plan,
        Emp_Activo = p_activo
    WHERE Emp_ID = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listar_empresas()
RETURNS TABLE(
    _Emp_ID UUID,
    _Emp_Nombre VARCHAR(150),
    _Emp_Correo VARCHAR(150),
    _Emp_Activo BOOLEAN,
    _Plan_Nombre VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    SELECT e.Emp_ID, e.Emp_Nombre, e.Emp_Correo, e.Emp_Activo, p.Plan_Nombre
    FROM Empresa e
    JOIN Plan p ON e.Emp_Plan = p.Plan_ID;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_empresa_por_correo(p_correo VARCHAR(150))
RETURNS TABLE (
    _Emp_ID UUID,
    _Emp_Nombre VARCHAR(150),
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
    WHERE e.Emp_Correo = p_correo;
END;
$$ LANGUAGE plpgsql;

