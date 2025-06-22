CREATE EXTENSION IF NOT EXISTS pgcrypto;
-- Usuario de prueba
SELECT agregar_usuario('admin', 'SuperAdministrador', crypt('12345', gen_salt('bf', 10)), 4, NULL);
SELECT agregar_usuario('Usuario_prueba', 'Usuario Prueba', crypt('12345', gen_salt('bf', 10)), 1, 'UUID_DE_LA_EMPRESA'); -- Reemplaza con un UUID válido de una empresa existente