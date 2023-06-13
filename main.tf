terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA2BKIQFJJIIU72X6P"
  secret_key = "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"
}

# VPC
resource "aws_vpc" "vpc-tf" {
  cidr_block           = "10.1.0.0/16"
  # Habilitar soporte y resolucion de direcciones DNS
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-tf"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw-tf" {
  vpc_id = aws_vpc.vpc-tf.id
  tags = {
    Name = "igw-tf"
  }
}

# IP elastica necesaria para la NAT Gateway
resource "aws_eip" "ip-eslastica-nat-tf" {
  vpc = true
  tags = {
    Name = "ip-eslastica-nat-tf"
  }
}

# NAT Gateway 
resource "aws_nat_gateway" "nat-gateway-tf" {
  allocation_id = aws_eip.ip-eslastica-nat-tf.id
  subnet_id     = aws_subnet.subred-front-1b-tf.id
  tags = {
    Name = "nat-gateway-tf"
  }
}

# Tabla de rutas con IGW para servicios publicos
resource "aws_route_table" "tabla-rutas-internet-tf" {
  vpc_id = aws_vpc.vpc-tf.id
  # Ruta hacia dentro de la VPC se crea por defecto
  # Ruta hacia internet a traves del igw
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-tf.id
  }
  tags = {
    Name = "tabla-rutas-internet-tf"
  }
}

# Tabla de rutas con NAT Gateway para las bases de datos privadas
resource "aws_route_table" "tabla-rutas-databases-tf" {
  vpc_id = aws_vpc.vpc-tf.id
  # Ruta hacia dentro de la VPC se crea por defecto
  # Ruta hacia internet a traves de la NAT Gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-tf.id
  }
  tags = {
    Name = "tabla-rutas-databases-tf"
  }
}

# Punto de enlace de VPC que habilita conexiones con el bucket S3
resource "aws_vpc_endpoint" "s3-endpoint-tf"{
  vpc_id = aws_vpc.vpc-tf.id
  service_name = "com.amazonaws.us-east-1.s3" 
  tags = {
    Name = "s3-endpoint-tf"
  }
}

# Asociacion de la tabla de rutas a Internet a la subnet publica de servicios
resource "aws_route_table_association" "tabla-internet-subred-servicios" {
  subnet_id      = aws_subnet.subred-servicios-1a-tf.id
  route_table_id = aws_route_table.tabla-rutas-internet-tf.id
}
# Asociacion de la tabla de ruta a Internet a la subnet publica con el front
resource "aws_route_table_association" "tabla-internet-subred-front" {
  subnet_id      = aws_subnet.subred-front-1b-tf.id
  route_table_id = aws_route_table.tabla-rutas-internet-tf.id
}

# Asociacion de la tabla de rutas privada a las subnets privadas 1a y 1b
resource "aws_route_table_association" "tabla-databases-subred-databases-1a" {
  subnet_id      = aws_subnet.subred-databases-1a-tf.id
  route_table_id = aws_route_table.tabla-rutas-databases-tf.id
}
resource "aws_route_table_association" "tabla-databases-subred-databases-1b" {
  subnet_id      = aws_subnet.subred-databases-1b-tf.id
  route_table_id = aws_route_table.tabla-rutas-databases-tf.id
}

# Asociación de la ruta hacia el punto de enlace en la tabla de rutas publica y privada
resource "aws_vpc_endpoint_route_table_association" "tabla-internet-s3-endpoint" {
  route_table_id = aws_route_table.tabla-rutas-internet-tf.id
  vpc_endpoint_id = aws_vpc_endpoint.s3-endpoint-tf.id
}
resource "aws_vpc_endpoint_route_table_association" "tabla-databases-s3-endpoint" {
  route_table_id = aws_route_table.tabla-rutas-databases-tf.id
  vpc_endpoint_id = aws_vpc_endpoint.s3-endpoint-tf.id
}