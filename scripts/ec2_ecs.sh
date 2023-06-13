#!/bin/bash

# 1)
# Actualizar paquetes e iniciar servicios ECS y Docker
yum update -y
yum install -y ecs-init
service docker start
start ecs

# Identificar el nombre del cluster en el fichero ecs.config
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
cat /etc/ecs/ecs.config | grep "ECS_CLUSTER"