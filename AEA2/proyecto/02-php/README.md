# Etapa 2 · Punto de Juego con PHP, sin base de datos

## Archivos
- public/index.php: lista de actividades y plantilla que genera HTML.
- public/style.css: presentación mínima para personalizar.

## Requisitos
Apache HTTP Server integrado con PHP-FPM y PHP 8.2 o posterior. PHP CLI permite comprobar sintaxis, pero no demuestra la integración con Apache.

## Despliegue del encargo
1. Conserva identificable la entrega estática.
2. Configura Apache para ejecutar PHP mediante PHP-FPM según tu distribución.
3. Publica el contenido de public/ en una ubicación servida por Apache. No publiques este README.
4. Solicita primero index.php por HTTP; comprueba después el acceso a la URL del directorio.
5. Verifica actividades, CSS, hora generada y código fuente recibido. El navegador debe recibir HTML, no PHP.

No es suficiente abrir el archivo como file:// ni usar el servidor de desarrollo de PHP para acreditar el encargo. No se necesita MariaDB.

## Leer el código
- `$activitats`: lista de datos con claves `titol` y `tipus`.
- `foreach`: genera un bloque HTML para cada actividad.
- `<?= ... ?>`: imprime el resultado de una expresión.
- `h(...)`: escapa texto al insertarlo en HTML.
- `date(...)`: calcula la hora en el servidor.

Añade al menos una actividad y adapta la identidad visual de Punto de Juego. Los datos siguen en el código: no hay formularios ni almacenamiento gestionado por el usuario.

## Comprobación de sintaxis
Desde esta carpeta, con PHP CLI instalado: `php -l public/index.php`. Después verifica el resultado en Apache, porque son comprobaciones diferentes.
