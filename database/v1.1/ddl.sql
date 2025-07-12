-- Extensión para UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabla Plan
CREATE TABLE Plan (
    Plan_ID SERIAL PRIMARY KEY,
    Plan_Nombre VARCHAR(100) NOT NULL UNIQUE,
    Plan_Duracion INT NOT NULL, 
    Plan_Almacenamiento BIGINT NOT NULL,
    Plan_MaxUsuarios INT NOT NULL,
    Plan_Precio DECIMAL(10, 2) NOT NULL
);

-- Tabla Empresa
CREATE TABLE Empresa (
    Emp_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Emp_Nombre VARCHAR(150) NOT NULL,
    Emp_NombreCompleto VARCHAR(150) NOT NULL,
    Emp_Correo VARCHAR(150) NOT NULL UNIQUE,
    Emp_Hash TEXT NOT NULL,
    Emp_Plan INT NOT NULL,
    Emp_Creado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Emp_Actualizado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Emp_FechaInicioPlan DATE DEFAULT CURRENT_DATE,
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
    Usu_NombreCompleto VARCHAR(150) NOT NULL,
    Usu_Hash TEXT NOT NULL,
    Usu_Rol INT NOT NULL,
    Usu_Activo BOOLEAN DEFAULT TRUE,
    Usu_Empresa UUID,
    CONSTRAINT fk_usuario_rol FOREIGN KEY (Usu_Rol) REFERENCES Rol(Rol_ID) ON DELETE CASCADE,
    CONSTRAINT fk_usuario_empresa FOREIGN KEY (Usu_Empresa) REFERENCES Empresa(Emp_ID) ON DELETE CASCADE
);

-- Tabla Notificación
CREATE TABLE Notificacion (
    Not_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Not_Titulo VARCHAR(255) NOT NULL,
    Not_Mensaje TEXT NOT NULL,
    Not_Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla Intermedia de notificaciones
CREATE TABLE NotificacionUsuario (
    NotUsu_ID SERIAL PRIMARY KEY,
    NotUsu_Notificacion UUID NOT NULL,
    NotUsu_Usuario UUID NOT NULL,
    NotUsu_Recibida BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (NotUsu_Notificacion) REFERENCES Notificacion(Not_ID) ON DELETE CASCADE,
    FOREIGN KEY (NotUsu_Usuario) REFERENCES Usuario(Usu_ID) ON DELETE CASCADE
);

-- Tabla Log de actividades
CREATE TABLE LogActividad (
    Log_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Log_Tabla VARCHAR(50) NOT NULL,             
    Log_Registro UUID,                          
    Log_Tipo VARCHAR(50) NOT NULL,              
    Log_Descripcion TEXT NOT NULL,
    Log_Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Log_Usuario UUID,
    Log_NombreUsuario VARCHAR(150),                           
    Log_DatosAnteriores JSONB,                   
    Log_DatosNuevos JSONB,                       
    CONSTRAINT fk_log_usuario FOREIGN KEY (Log_Usuario) REFERENCES Usuario(Usu_ID) ON DELETE SET NULL
);

-- Permitir NULL en LogEmp_Empresa para evitar errores al eliminar empresas
CREATE TABLE LogEmpresa (
    LogEmp_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    LogEmp_Empresa UUID,
    LogEmp_Tabla VARCHAR(50) NOT NULL,
    LogEmp_Registro UUID,
    LogEmp_Tipo VARCHAR(50) NOT NULL,         
    LogEmp_Descripcion TEXT NOT NULL,
    LogEmp_Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    LogEmp_Usuario UUID,
    LogEmp_NombreEmpresa VARCHAR(150),
    LogEmp_NombreUsuario VARCHAR(150),
    CONSTRAINT fk_logempresa_usuario FOREIGN KEY (LogEmp_Usuario) REFERENCES Usuario(Usu_ID) ON DELETE SET NULL
);

CREATE TABLE ChatMensaje(
    Chat_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Chat_Remitente UUID NOT NULL,
    Chat_Destinatario UUID,
    Chat_Mensaje TEXT NOT NULL,
    Chat_Room VARCHAR(100) NOT NULL, 
    Chat_Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Chat_Empresa UUID NOT NULL,
    FOREIGN KEY (Chat_Remitente) REFERENCES Usuario(Usu_ID) ON DELETE CASCADE,
    FOREIGN KEY (Chat_Destinatario) REFERENCES Usuario(Usu_ID) ON DELETE CASCADE,
    FOREIGN KEY (Chat_Empresa) REFERENCES Empresa(Emp_ID) ON DELETE CASCADE
);

CREATE TABLE Documento (
    Doc_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Doc_Nombre VARCHAR(255) NOT NULL,
    Doc_Url TEXT NOT NULL, -- URL de Supabase
    Doc_Tipo VARCHAR(50),      
    Doc_Tamanio BIGINT,        
    Doc_SubidoPor UUID,
    Doc_Empresa UUID NOT NULL,
    Doc_Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Doc_SubidoPor) REFERENCES Usuario(Usu_ID) ON DELETE CASCADE,
    FOREIGN KEY (Doc_Empresa) REFERENCES Empresa(Emp_ID) ON DELETE CASCADE
);

-- Tabla auxiliar para backup de estado de usuarios por empresa (para lógica avanzada de reactivación)
CREATE TABLE UsuarioBackup (
    Backup_ID SERIAL PRIMARY KEY,
    Empresa UUID NOT NULL,
    Usuario UUID NOT NULL,
    Estado BOOLEAN NOT NULL,
    CONSTRAINT fk_backup_empresa FOREIGN KEY (Empresa) REFERENCES Empresa(Emp_ID) ON DELETE CASCADE,
    CONSTRAINT fk_backup_usuario FOREIGN KEY (Usuario) REFERENCES Usuario(Usu_ID) ON DELETE CASCADE
);
