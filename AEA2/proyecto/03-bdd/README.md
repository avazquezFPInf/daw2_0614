# Etapa 3 · PHP y MariaDB
PHP 8.2+ con pdo_mysql. En Compose se utiliza MariaDB 11.4. Implementad el esquema y los datos siguiendo MODEL-DADES.md; el profesorado tiene una solución separada.

Un administrador crea la base puntdejoc y la cuenta de aplicación con contraseña propia. La cuenta de aplicación solo necesita SELECT y UPDATE. El esquema lo crea una cuenta de prácticas con permisos DDL. PHP no debe conectarse como root.

En Bash, desde esta carpeta:

```sh
export DB_HOST=127.0.0.1
export DB_USER=puntdejoc
read -s DB_PASSWORD
export DB_PASSWORD
export ALLOW_LAB_WRITE=1
php -S 127.0.0.1:8002 -t public
```
Introduce la contraseña tras read. Abre http://127.0.0.1:8002. Las variables del terminal llegan a sus procesos hijos; no configuran automáticamente el PHP ejecutado por Apache. Esa instalación necesita su configuración específica.

index.php consulta y presenta. bootstrap.php conecta y calcula puntos. resultats.php valida y guarda un resultado. El alumnado no tiene que reprogramarlos.

ALLOW_LAB_WRITE habilita un formulario sin autenticación: usar solo en el laboratorio local ligado a 127.0.0.1. El Compose también publica en loopback. No es una versión para Internet.
