#!/bin/bash

# 1)
# Instalar Docker
yum install docker -y
usermod -a -G docker ec2-user
id ec2-user
newgrp docker
sudo systemctl enable docker.service
sudo systemctl start docker.service

# 2)
# Copiar en el equipo la carpeta con los ficheros de Cassandra
aws s3 cp s3://db-services-bucket-tf/cassandra cassandra --recursive

# 3)
# Instalar Docker-Compose
sudo dnf -y install wget
sudo curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url | grep docker-compose-linux-x86_64 | cut -d '"' -f 4 | wget -qi -
sudo chmod +x docker-compose-linux-x86_64
sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose

# 4)
# Lanzar contenedores con el fichero docker-compose
cd /cassandra
docker-compose -f docker-compose-cassandra.yml up -d