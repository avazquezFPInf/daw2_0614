# Inicialización del laboratorio
La imagen MariaDB crea puntdejoc y portal_lectura mediante las variables. Después ejecuta 10-esquema.sql, 20-datos.sql y 30-permisos.sh, solo cuando el volumen está vacío. El último script reduce los permisos PHP a SELECT y crea la cuenta Java con UPDATE solo de resultat.

El usuario con origen % acepta conexiones de la red Docker; db no publica 3306 al anfitrión. Son cuentas y datos del nuevo laboratorio, independientes del MariaDB instalado en Ubuntu. No copiar /var/lib/mysql del anfitrión al volumen.

No hace falta volver a escribir SQL ni copiar CREATE DATABASE o CREATE USER. La base ya la inicializa la imagen. Si se produjo un error de inicialización, revisar logs y corregir con una cuenta autorizada; no borrar automáticamente el volumen.
