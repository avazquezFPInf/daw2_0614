# Etapa 5 · Laboratorio con contenedores
1. Copia .env.example a .env y cambia ambas contraseñas.
2. Coloca tus sentencias en sql/01-esquema.sql y sql/02-dades.sql según el modelo.
3. Desde esta carpeta: `docker compose config --quiet` y `docker compose up --build -d`.
4. Abre http://127.0.0.1:8081 y consulta `docker compose logs`.
5. Ejecuta down y después up: los resultados deben conservarse.

`docker compose down -v` BORRA los datos. Úsalo solo para reiniciar expresamente el laboratorio ficticio. Los SQL iniciales no se ejecutan de nuevo sobre un volumen ya inicializado.

La cuenta creada por la imagen tiene permisos sobre la base del laboratorio. En producción hay que separar migraciones y usuario de aplicación. MariaDB no publica un puerto al anfitrión. El puerto web solo es accesible desde el propio equipo. Este Compose es una solución funcional para el ensayo docente; el encargo posterior puede proporcionar una copia incompleta que el alumnado justifique y complete.
