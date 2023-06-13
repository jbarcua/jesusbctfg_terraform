#!/bin/bash

# 1)
# Instalacion herramientas necesarias
yum install nfs-utils -y
# Directorio de montaje /efs en la carpeta raiz
mkdir /efs
# Montaje EFS en el path indicado /efs
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_ip}:/ efs
# Montaje del EFS automatico al reiniciar la instancia
echo "${efs_ip}:/ /efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab

# 2)
# Instalar Docker
yum install docker -y
usermod -a -G docker ec2-user
id ec2-user
newgrp docker
sudo systemctl enable docker.service
sudo systemctl start docker.service

# 3)
# Volumen mongodb-volume creado
docker volume create \
  --driver local \
  --opt type=nfs \
  --opt o=addr=${efs_ip},nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport \
  --opt device=:/mongo-efs \
  mongodb-volume

# 4)
# Copiar en el equipo el script guardado en el S3
aws s3 cp s3://db-services-bucket-tf/init-mongodb.js /init_mongo/init-mongodb.js
# Docker image MongoDB version 5.0.7
docker pull mongo:5.0.7
# Ejecutar contenedor con el volumen y el comando "mongod" para inciar el server
docker run --name mongodb -d -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME='admin' -e MONGO_INITDB_ROOT_PASSWORD='example' -v mongodb-volume:/data/db -v /init_mongo/init-mongodb.js:/docker-entrypoint-initdb.d/init-mongodb.js:ro mongo:5.0.7 mongod