FiestaYa
Aplicación móvil para conectar usuarios que buscan servicios con proveedores, desarrollada con Flutter (frontend), Node.js + Express (backend) y PostgreSQL (base de datos).

Requisitos
Node.js (v18 o superior)
Flutter (v3 o superior) y Dart
PostgreSQL (v15 o superior)
Git

Instalación Inicial

1. Clonar el Repositorio
git clone https://g........

cd FiestaYa

3. Configurar el Backend

Ir a la carpeta del backend:
cd backend


Instalar dependencias:
npm install


Configurar PostgreSQL:

Crea una base de datos en PostgreSQL:CREATE DATABASE events_db;


Crea la tabla de usuarios:CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  
  email VARCHAR(255) NOT NULL UNIQUE,
  
  password VARCHAR(255) NOT NULL,
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);




Configurar variables de entorno:

Crea un archivo .env en la carpeta backend/ y añade:DB_HOST=localhost
DB_USER=postgres

DB_PASSWORD=tu_contraseña

DB_NAME=events_db

DB_PORT=5432

PORT=3000




Iniciar el servidor:
npm run dev

El servidor estará corriendo en http://localhost:3000.


3. Configurar el Frontend

Ir a la carpeta del frontend:
cd ../frontend


Instalar dependencias:
flutter pub get


Ejecutar la app:

Asegúrate de tener un emulador o dispositivo conectado.
Ejecuta:flutter run



La app se abrirá en el emulador/dispositivo, mostrando la pantalla de inicio de sesión.


4. Probar la App

Abre la app en el emulador.
Regístrate con un correo y contraseña (HU1).
Inicia sesión con las mismas credenciales (HU2).

Notas

El backend está configurado para las HUs de autenticación (HU1: Registro, HU2: Inicio de sesión). Próximas HUs (como HU3: Recuperar contraseña) requerirán agregar más rutas y pantallas.
Asegúrate de que el servidor backend esté corriendo antes de usar la app.
Si tienes problemas con Flutter, verifica que el SDK esté bien configurado y que tengas un emulador activo.

Estructura del Proyecto

backend/: Contiene el servidor Node.js + Express.
frontend/: Contiene la app Flutter.
backend/src/: Código del backend (rutas, modelos, configuración).
frontend/lib/: Código de Flutter (pantallas, servicios).

