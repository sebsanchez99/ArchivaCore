-- Extensión para generar UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabla Rol
CREATE TABLE Rol (
    Rol_ID SERIAL PRIMARY KEY,
    Rol_Nombre VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla Usuario
CREATE TABLE Usuario (
    Usu_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Usu_Nombre VARCHAR(100) NOT NULL,
    Usu_Hash TEXT NOT NULL, 
    Usu_Rol INT NOT NULL,
    CONSTRAINT fk_usuario_rol FOREIGN KEY (Usu_Rol) REFERENCES Rol(Rol_ID) ON DELETE CASCADE
);

-- Tabla Carpeta
CREATE TABLE Carpeta (
    Car_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Car_Nombre VARCHAR(255) NOT NULL,
    Car_Ubicacion TEXT NOT NULL,
    Car_Usuario UUID NOT NULL,
    CONSTRAINT fk_carpeta_usuario FOREIGN KEY (Car_Usuario) REFERENCES Usuario(Usu_ID) ON DELETE CASCADE
);

-- Tabla Documento
CREATE TABLE Documento (
    Doc_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Doc_Nombre VARCHAR(255) NOT NULL,
    Doc_Ubicacion TEXT NOT NULL,
    Doc_Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Doc_Carpeta UUID NOT NULL,
    CONSTRAINT fk_documento_carpeta FOREIGN KEY (Doc_Carpeta) REFERENCES Carpeta(Car_ID) ON DELETE CASCADE
);

-- Tabla Notificación
CREATE TABLE Notificacion (
    Not_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Not_Titulo VARCHAR(255) NOT NULL,
    Not_Mensaje TEXT NOT NULL,
    Not_Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Not_Usuario UUID NOT NULL,
    CONSTRAINT fk_notificacion_usuario FOREIGN KEY (Not_Usuario) REFERENCES Usuario(Usu_ID) ON DELETE CASCADE
);
