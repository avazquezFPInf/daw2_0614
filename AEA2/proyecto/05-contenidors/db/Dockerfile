FROM mariadb:10.11
COPY sql/ /docker-entrypoint-initdb.d/
RUN chmod 644 /docker-entrypoint-initdb.d/30-permisos.sh
