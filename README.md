--Instalar xpress

--Instalar axios

Para niciar el proyecto se necsita node para el backend

Configurar el Backend

1 Instalar dependencias

cd backend

npm install express cors dotenv oracledb


2 Configurar la conexión a Oracle
Editar los 4 archivos del backend index.js, delitos,detenidos y policias y agrega tus credenciales de Oracle:

module.exports = {
  user: "tu_usuario",
  password: "tu_contraseña",
  connectString: "localhost:1521/freepdb2"
};

3 Iniciar el servidor

npm start 

##Frontend 
En la carpeta raiz
npx create-react-app frontend

2 Instalar dependencias

cd /frontend

npm install axios

3 Iniciar con npm start



npm start

3 En el frontend dentro de public poner el logo
