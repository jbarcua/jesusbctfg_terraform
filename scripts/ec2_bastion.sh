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
# Crear directorios dentro del EFS donde se almacenaran los datos
cd /
# Directorio MongoDB
mkdir /efs/mongo-efs
# Directorio Cassandra
mkdir /efs/cassandra-efs

# 3)
# Instalar MySQL 8.0
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
sudo dnf install mysql-community-server -y
# Instalar PostgreSQL 15
sudo yum install postgresql15.x86_64 -y