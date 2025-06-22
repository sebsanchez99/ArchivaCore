CREATE EXTENSION IF NOT EXISTS pgcrypto;
-- Usuario de prueba
SELECT agregar_usuario('admin', 'SuperAdministrador', '12345', 4, NULL);
SELECT agregar_usuario('Usuario_prueba', 'Usuario Prueba', '12345', 1, 'UUID_DE_LA_EMPRESA'); -- Reemplaza con un UUID válido de una empresa existente