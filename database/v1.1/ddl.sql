-- Extensión para UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabla Plan
CREATE TABLE Plan (
    Plan_ID SERIAL PRIMARY KEY,
    Plan_Nombre VARCHAR(100) NOT NULL UNIQUE,
    Plan_Duracion INT NOT NULL, -- en días
    Plan_Almacenamiento BIGINT NOT NULL, -- en bytes
    Plan_MaxUsuarios INT NOT NULL,
    Plan_Precio DECIMAL(10, 2) NOT NULL
);

-- Tabla Empresa
CREATE TABLE Empresa (
    Emp_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Emp_Nombre VARCHAR(150) NOT NULL,
    Emp_Correo VARCHAR(150) NOT NULL UNIQUE,
    Emp_Hash TEXT NOT NULL,
    Emp_Plan INT NOT NULL,
    Emp_Activo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_empresa_plan FOREIGN KEY (Emp_Plan) REFERENCES Plan(Plan_ID) ON DELETE CASCADE
);

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
    Usu_Empresa UUID,
    CONSTRAINT unique_username UNIQUE(Usu_Nombre),
    CONSTRAINT fk_usuario_rol FOREIGN KEY (Usu_Rol) REFERENCES Rol(Rol_ID) ON DELETE CASCADE,
    CONSTRAINT fk_usuario_empresa FOREIGN KEY (Usu_Empresa) REFERENCES Empresa(Emp_ID) ON DELETE SET NULL
);

-- Tabla Carpeta
CREATE TABLE Carpeta (
    Car_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Car_Nombre VARCHAR(255) NOT NULL,
    Car_Ruta TEXT NOT NULL, -- Ruta lógica o nombre de directorio
    Car_Usuario UUID NOT NULL,
    CONSTRAINT unique_folder UNIQUE(Car_Nombre, Car_Usuario),
    CONSTRAINT fk_carpeta_usuario FOREIGN KEY (Car_Usuario) REFERENCES Usuario(Usu_ID) ON DELETE CASCADE
);

-- Tabla Documento
CREATE TABLE Documento (
    Doc_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Doc_Nombre VARCHAR(255) NOT NULL,
    Doc_Ubicacion TEXT NOT NULL, -- URL pública/firmada desde Supabase
    Doc_Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Doc_Tipo VARCHAR(100), -- ej: application/pdf
    Doc_Tamano BIGINT,     -- tamaño en bytes
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

-- Tabla Log de actividades
CREATE TABLE LogActividad (
    Log_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Log_Tipo VARCHAR(50) NOT NULL, -- Ej. "Inicio sesión", "Error"
    Log_Descripcion TEXT NOT NULL,
    Log_Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Log_Usuario UUID NOT NULL,
    CONSTRAINT fk_log_usuario FOREIGN KEY (Log_Usuario) REFERENCES Usuario(Usu_ID) ON DELETE CASCADE
);
