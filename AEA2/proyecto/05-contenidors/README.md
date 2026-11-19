# Etapa 5 · Cuatro servicios en contenedores

## Qué despliegas
web = Apache, php = PHP-FPM, db = MariaDB, java = Tomcat y el WAR del encargo 4. La instalación nativa se conserva; los nuevos datos viven en el volumen dades y no son los del MariaDB del anfitrión.

Requisitos: Docker Engine con plugin Compose, conexión para descargar imágenes, puertos locales 8081 y 8082 libres. Todos los comandos se ejecutan desde esta carpeta. Se utiliza sudo docker; no necesitas añadirte al grupo docker.

## Primera experiencia: web estática

```bash
sudo docker run -d --name aea2-apache -p 127.0.0.1:8081:80 --mount type=bind,source="$(pwd)/estatica",target=/usr/local/apache2/htdocs,readonly httpd:2.4
sudo docker ps
sudo docker logs aea2-apache
```

Abre http://127.0.0.1:8081/. El Apache nativo sigue en 80. Cambia un texto de estatica/index.html, recarga, detén y vuelve a arrancar el contenedor. El montaje usa los archivos del anfitrión. Antes de Compose, libera el puerto:

```bash
sudo docker stop aea2-apache
sudo docker rm aea2-apache
```

## Preparar Compose
Copia .env.example a .env. Genera tres contraseñas distintas con `openssl rand -hex 16` y pon cada resultado en DB_ROOT_PASSWORD, PHP_DB_PASSWORD y JAVA_DB_PASSWORD. Este laboratorio exige claves de letras/números y al menos 16 caracteres para Java. No guardes .env en Git.

```bash
cp .env.example .env
chmod 600 .env
sudo docker compose config --quiet
```

Los Dockerfile no copian .env. Compose pasa explícitamente las variables necesarias; son visibles para quien administra Docker, no son un almacén de secretos de producción.

## Arrancar poco a poco

```bash
sudo docker compose up --build -d db
sudo docker compose ps
sudo docker compose logs db
```

Espera a db healthy. En un volumen nuevo se crean base, tablas y datos; después se limitan las cuentas. No montes los archivos del MariaDB nativo. No vuelvas a ejecutar CREATE/INSERT sobre tablas ya cargadas.

```bash
sudo docker compose up --build -d web
sudo docker compose ps
sudo docker compose logs web php
```

También arranca php, su dependencia. Abre http://127.0.0.1:8081/: el portal PHP debe mostrar datos. Apache y FPM tienen copias de public/ en /var/www/html; esa coincidencia permite localizar los scripts remitidos por FastCGI. src/ queda fuera del directorio público.

```bash
sudo docker compose up --build -d java
sudo docker compose logs java
```

Abre http://127.0.0.1:8082/tornejos/. La raíz / puede devolver 404 en la imagen de Tomcat: usa el contexto. La configuración JNDI del contenedor lee JAVA_DB_PASSWORD y se conecta a db:3306. La opción labContainerAccess admite la IP interna de Docker; solo debe utilizarse con el puerto publicado en 127.0.0.1. El prototipo no tiene login.

## Direcciones y persistencia
- Navegador: 127.0.0.1:8081 (PHP) y 127.0.0.1:8082/tornejos/ (Java).
- Apache a FPM: php:9000, sin puerto publicado ni socket compartido.
- PHP/Java a MariaDB: db:3306, sin publicar 3306.
- Datos: volumen dades; `down` conserva este volumen. Persistencia no equivale a backup.
- Cambios copiados con COPY: reconstruye ambos web/php si cambias su public/. Un bind mount de la primera fase sí refleja los cambios sin reconstruir.

## Pruebas
Registrar B para partida 3 desde Java y recargar PHP: Cris 4 puntos, si el punto inicial era el proporcionado. Ejecutar down y up conservando el volumen: se mantiene el resultado. Detener db: revisar el error y los logs; arrancarla y comprobar recuperación. Resultats.php permanece desactivado (403).

```bash
sudo docker compose down
sudo docker compose up -d
```

No uses `down -v`: elimina el volumen y los datos. Cambiar contraseñas o SQL iniciales en archivos no modifica automáticamente una base ya inicializada. Los nombres de servicio resuelven dentro de la red Docker, no en el navegador del anfitrión.

## Traslado a un servidor remoto
La misma carpeta permite reproducir el entorno en un servidor Linux con Docker, adaptando secretos, arquitectura CPU y puertos. Mantén inicialmente la publicación en loopback y accede mediante un túnel SSH autorizado. La práctica local no demuestra por sí sola un despliegue en la nube: registra por separado esa evidencia cuando dispongas del servidor del centro.

Los SQL y el script de cuentas se copian a la imagen db mediante db/Dockerfile para fijar sus permisos. Si cambian, reconstruye db; eso no vuelve a aplicar la inicialización sobre un volumen con datos.
