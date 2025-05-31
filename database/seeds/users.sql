CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Usuario de prueba
INSERT INTO usuario (usu_id, usu_nombre, usu_hash, usu_rol)
VALUES (
  gen_random_uuid(), 
  'admin', 
  crypt('12345', gen_salt('bf', 10)), 
  4
);
