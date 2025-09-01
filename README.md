# 📂 ArchivaCore

![Node.js](https://img.shields.io/badge/Node.js-18+-green?logo=node.js)
![Vue.js](https://img.shields.io/badge/Vue.js-3-brightgreen?logo=vue.js)
![Flutter](https://img.shields.io/badge/Flutter-3.29+-blue?logo=flutter)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13+-blue?logo=postgresql)
![Supabase](https://img.shields.io/badge/Supabase-Storage-success?logo=supabase)
![OpenAI](https://img.shields.io/badge/GPT-API-orange?logo=openai)

**ArchivaCore** es una aplicación para la gestión eficiente de archivos en entornos corporativos. Su propósito es **centralizar, organizar y resguardar información** de manera segura, con acceso ágil y controlado.  

Incluye un módulo de **inteligencia artificial (GPT)** para el análisis automatizado de hojas de vida, optimizando la gestión del talento en **Recursos Humanos**.  

---

## 🛠️ Tecnologías principales

- **Frontend Web:** Vue 3 + TypeScript + Vite + Pinia  
- **Frontend Escritorio:** Flutter + Dart  
- **Backend:** Node.js + Express + WebSocket  
- **Base de datos:** PostgreSQL  
- **Almacenamiento:** Supabase Storage  
- **IA:** API GPT  

---

## 🔎 Arquitectura

```mermaid
flowchart TD
 subgraph 1["Landing Page<br>Vue.js/TypeScript"]
        21["Entrada Principal<br>Vue.js/TypeScript"]
        22["Client Router<br>Vue.js/Vue Router"]
        23["Vistas<br>Vue.js"]
        24["Servicios de API<br>Vue.js/Axios"]
        25["Estados de Stores<br>Vue.js/Pinia"]
  end
 subgraph 2["Aplicación Frontend<br>Flutter/Dart"]
        16["Entrada Principal<br>Flutter/Dart"]
        17["Capa de presentación<br>Flutter/Dart"]
        18["Repositorio de datos<br>Flutter/Dart"]
        19["Servicios de API remotos<br>Flutter/Dio"]
        20["Servicio Socket de chat<br>Flutter/WebSocket"]
  end
 subgraph 3["Backend API<br>Node.js/Express"]
        10["Controladores<br>Node.js"]
        11["Middleware de Autenticación<br>Node.js/Passport.js"]
        12["Cliente PostgreSQL<br>Node.js/pg"]
        13["Cliente Supabase<br>Node.js/Supabase"]
        14["Servidor WebSocket<br>Node.js/ws"]
        15["Manejadores deWebSocket<br>Node.js"]
        8["Aplicación Principal<br>Node.js/Express"]
        9["Rutas de API<br>Node.js/Express"]
  end
    21 -- usa --> 22
    22 -- renderiza --> 23
    23 -- usa --> 24
    24 -- actualiza --> 25
    16 -- Inicializa --> 17
    17 -- usa --> 18
    18 -- llama --> 19
    18 -- usa --> 20
    8 -- usa --> 9
    11 -- reenvia --> 10
    9 -- aplica --> 11
    10 -- usa --> 12 & 13
    10 -- administra --> 14
    14 -- delega a --> 15
    5["Usuario<br>Actor"] -- navega --> 1
    5 -- interactúa con --> 2
    1 -- realiza llamada a API --> 3
    2 -- realiza llamada a API --> 3
    3 -- consultas/almacenamiento de información --> 26["Base de datos PostgreSQL<br>SQL"]
    3 -- usa servicio externo --> 27["Supabase<br>BaaS"]
    3 -- solicita análisis --> n1["GPT API"]
```

📌 *El frontend nunca accede directamente a la base de datos ni a Supabase, siempre lo hace a través del backend.*  

---

## 📂 Estructura del Proyecto

```
database/   -> Tablas, funciones, triggers y seeds
backend/    -> API REST, controladores, modelos, rutas y lógica de negocio
frontend/   -> Aplicación de escritorio (Flutter)
landing/    -> Web app (Vue 3 + TypeScript + Pinia + Vite)
```

---

## ⚙️ Requisitos

- Node.js **18+**  
- PostgreSQL **13+**  
- Flutter **3.29+**  
- Cuenta de Supabase  
- npm o Yarn  

---

## 🔑 Variables de Entorno

Crea un archivo `.env` en `backend/` y `landing/` a partir de los `.env.example`.  
Variables más importantes:  

```ini
PORT=3000
DB_USER=usuario
DB_PASSWORD=contraseña
DB_HOST=localhost
DB_NAME=archivacore
DB_PORT=5432
SECRET_KEY=clave_secreta
EXPIRE_TOKEN=1d
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_API_KEY=xxxx
GPT_API_KEY=xxxx
```

---

## 🚀 Instalación

### Backend
```bash
cd backend
npm install
npm run dev
```

### Frontend Web (Vue 3)
```bash
cd landing
npm install
npm run dev
```

### Frontend Escritorio (Flutter)
```bash
cd frontend
flutter pub get
flutter run -d windows
```
**Opcional:** Si hay clases anotadas con @freezed se debe ejecutar el siguiente comando:
```bash
cd frontend
flutter run build_runner build --delete-conflicting-outputs
```

### Base de datos
Ejecutar en orden:  
1. `ddl.sql`  
2. `functions.sql`  
3. `triggers.sql`  
4. `seeds.sql`  

---

## 🔐 Seguridad

- **Autenticación:** JWT + Passport  
- **Roles y permisos:** gestionados en DB  
- **Contraseñas:** encriptadas con bcrypt  

---

## 👥 Equipo

Desarrollado por:  
- Leonardo Echeverry  
- Iván Casallas  
- Eva Fajardo  
- Sebastián Sánchez  
