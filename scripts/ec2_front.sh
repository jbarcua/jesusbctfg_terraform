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
# Copiar en el equipo el fichero de variables de entorno
aws s3 cp s3://db-services-bucket-tf/env_vars.env env_vars.env

# 3)
# Docker image del Front
docker pull jesusbc/tfm-front-end:latest
# Ejecutar el contenedor
docker run --name tfm-front-end -d -p 4200:4200 --env-file env_vars.env jesusbc/tfm-front-end:latest