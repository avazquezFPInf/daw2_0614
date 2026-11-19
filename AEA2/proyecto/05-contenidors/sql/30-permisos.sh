#!/bin/bash
# La imagen oficial lo carga como source (permiso 644) y proporciona docker_process_sql.
case "$JAVA_DB_PASSWORD" in
  ''|*[!a-zA-Z0-9]*) echo "JAVA_DB_PASSWORD debe tener solo letras y números." >&2; exit 1 ;;
esac
if [ "${#JAVA_DB_PASSWORD}" -lt 16 ]; then
  echo "JAVA_DB_PASSWORD debe tener al menos 16 caracteres." >&2; exit 1
fi
docker_process_sql --database=puntdejoc <<SQL
REVOKE ALL PRIVILEGES ON puntdejoc.* FROM 'portal_lectura'@'%';
GRANT SELECT ON puntdejoc.* TO 'portal_lectura'@'%';
CREATE USER 'portal_java'@'%' IDENTIFIED BY '$JAVA_DB_PASSWORD';
GRANT SELECT ON puntdejoc.* TO 'portal_java'@'%';
GRANT UPDATE (resultat) ON puntdejoc.partides TO 'portal_java'@'%';
SQL
