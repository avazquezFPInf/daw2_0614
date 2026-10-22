# Etapa 2 · PHP sin base de datos
Requisito: PHP 8.2 o posterior. Desde esta carpeta:

```sh
php -S 127.0.0.1:8001 -t public
```
Visita http://127.0.0.1:8001 y recarga: cambia la hora. El código fuente recibido no contiene PHP. Este servidor integrado es solo de desarrollo local; después configuraremos Apache. Abrir index.php como archivo no ejecuta PHP.

## Leerlo sin saber PHP
- `$activitats` es una lista; cada elemento tiene título y tipo.
- `foreach` repite el HTML por cada elemento.
- `<?= ... ?>` escribe el resultado de una expresión.
- `h(...)` impide interpretar los datos como etiquetas HTML.
- `date(...)` calcula la hora en el servidor.
No hay frameworks, paquetes externos ni JavaScript.
