INSERT INTO Empresa (Emp_ID, Emp_Nombre, Emp_Correo, Emp_Hash, Emp_Plan, Emp_Activo)
VALUES (
    uuid_generate_v4(),
    'Empresa Prueba S.A.',
    'contacto@empresaprueba.com',
    crypt('12345', gen_salt('bf', 10)),
    1,
    TRUE
);
