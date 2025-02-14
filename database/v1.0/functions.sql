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