#!/usr/bin/env bash
# Instala Docker Engine, el plugin Compose y Portainer CE en Ubuntu 24.04 LTS.
# Punto de partida: Docker no está instalado y no hay paquetes incompatibles.
# Ejecución: sudo bash intalacionDockerCompose.sh

# Si un comando falla, detener la instalación en lugar de continuar a medias.
set -euo pipefail

# 1. Actualizar el índice de paquetes e instalar las herramientas necesarias.
# ca-certificates permite validar conexiones HTTPS; curl descarga la clave.
apt-get update
apt-get install -y ca-certificates curl

# 2. Guardar la clave pública del repositorio oficial de Docker.
# APT la utilizará para verificar la firma de los paquetes de ese repositorio.
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# 3. Añadir el repositorio oficial para la versión y arquitectura del equipo.
# En Ubuntu 24.04, el nombre de la versión es noble.
# Signed-By limita el uso de la clave a este repositorio.
. /etc/os-release
tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${UBUNTU_CODENAME:-$VERSION_CODENAME}
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# 4. Leer el nuevo repositorio e instalar los componentes.
# docker-ce: motor que ejecuta los contenedores.
# docker-ce-cli: comando docker de la terminal.
# containerd.io: componentes de ejecución que utiliza el motor.
# docker-buildx-plugin: herramienta para construir imágenes.
# docker-compose-plugin: comando docker compose para gestionar varios servicios.
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 5. Arrancar Docker ahora y habilitar su arranque al encender el ordenador.
# No añadimos usuarios al grupo docker: en la práctica usaremos sudo docker.
systemctl enable --now docker

# 6. Instalar Portainer: interfaz web para el mismo Docker Engine.
# El volumen conserva la configuración y las cuentas de Portainer.
# El socket permite administrar Docker: Portainer tiene control del equipo.
# Publicamos HTTPS solo en este ordenador, sin acceso desde la red del aula.
# lts sigue la versión de soporte prolongado publicada por Portainer.
docker volume create portainer_data
docker run -d \
  --name portainer \
  --restart=always \
  -p 127.0.0.1:9443:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:lts

printf '\nInstalación terminada. Abre https://localhost:9443 y crea tu cuenta de administrador.\n'
printf 'Portainer utiliza inicialmente un certificado autofirmado; consulta el encargo para el primer acceso.\n'
