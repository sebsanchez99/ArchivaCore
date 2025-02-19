-- Función que retorna la información del usuario
CREATE OR REPLACE FUNCTION obtener_usuario(p_nombre VARCHAR)
RETURNS TABLE (
    _usu_id UUID,
    _usu_nombre VARCHAR(100),
    _usu_hash TEXT,
    _rol_nombre VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.usu_id, u.usu_nombre, u.usu_hash, r.rol_nombre
    FROM usuario u
    JOIN rol r ON u.usu_rol = r.rol_id
    WHERE u.usu_nombre = p_nombre;
END;
$$ LANGUAGE plpgsql;

-- Función que lista todos los usuarios
CREATE OR REPLACE FUNCTION listar_usuarios()
RETURNS TABLE(
    _Usu_ID UUID,
    _Usu_Nombre VARCHAR(100),
    _Rol_Nombre VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY 
    SELECT u.Usu_ID, u.Usu_Nombre, r.Rol_Nombre
    FROM Usuario u
    JOIN Rol r ON u.Usu_Rol = r.Rol_ID;
END;
$$ LANGUAGE plpgsql;


-- Función que se encarga de buscar y retornar ID de rol
CREATE OR REPLACE FUNCTION obtener_id_rol(p_nombre VARCHAR(100))
RETURNS INT AS $$
DECLARE
    v_id INT;
BEGIN
    SELECT Rol_ID INTO v_id FROM Rol WHERE Rol_Nombre = p_nombre;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;


-- Función que se encarga de agregar un usuario y retornar el ID del usuario recién creado
CREATE OR REPLACE FUNCTION agregar_usuario(
    p_nombre VARCHAR(100),
    p_hash TEXT,
    p_rol INT
) RETURNS UUID AS $$
DECLARE
    v_id UUID;
BEGIN
    INSERT INTO Usuario (Usu_ID, Usu_Nombre, Usu_Hash, Usu_Rol)
    VALUES (uuid_generate_v4(), p_nombre, p_hash, p_rol)
    RETURNING Usu_ID INTO v_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- Función que se encarga de eliminar un usuario, retorna TRUE si el fue eliminado correctamente
CREATE OR REPLACE FUNCTION eliminar_usuario(p_id UUID)  
RETURNS BOOLEAN AS $$  
BEGIN  
    DELETE FROM Usuario WHERE Usu_ID = p_id;  
    RETURN TRUE;  
END;  
$$ LANGUAGE plpgsql;

-- Función para actualizar usuario
CREATE OR REPLACE FUNCTION actualizar_usuario(
    p_id UUID,
    p_nombre VARCHAR(100),
    p_hash TEXT,
    p_rol INT
) RETURNS VOID AS $$
BEGIN
    UPDATE Usuario
    SET Usu_Nombre = p_nombre,
        Usu_Hash = p_hash,
        Usu_Rol = p_rol
    WHERE Usu_ID = p_id;
END;
$$ LANGUAGE plpgsql;

-- Función que obtiene datos de usuario mediante el ID
CREATE OR REPLACE FUNCTION obtener_usuario_por_id(p_id UUID)
RETURNS TABLE(
    _Usu_ID UUID,
    _Usu_Nombre VARCHAR(100),
    _Usu_Hash TEXT,
    _Rol_Nombre VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY 
    SELECT u.Usu_ID, u.Usu_Nombre, u.Usu_Hash, r.Rol_Nombre
    FROM Usuario u
    JOIN Rol r ON u.Usu_Rol = r.Rol_ID
    WHERE u.Usu_ID = p_id;
END;
$$ LANGUAGE plpgsql;

