CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Función para agregar una empresa
SELECT agregar_empresa('Empresa Prueba S.A.', 'Empresa Prueba Sociedad Anónima', 'contacto@empresaprueba.com', crypt('12345', gen_salt('bf', 10)));