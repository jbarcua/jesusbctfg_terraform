########################################################
# Grupo de seguridad para la instancias EC2 de servicios
########################################################

resource "aws_security_group" "servicios-sg-tf" {
  name        = "servicios-sg-tf"
  description = "SG para el trafico hacia los servicios"
  vpc_id      = aws_vpc.vpc-tf.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Permitir trafico de las instancias dentro del grupo de seguridad bastion
    security_groups = [aws_security_group.bastion-sg-tf.id]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 8999
    to_port     = 8999
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "servicios-sg-tf"
  }
}

##################################################
# Grupo de seguridad para la instancia EC2 Bastion
##################################################

resource "aws_security_group" "bastion-sg-tf" {
  name        = "bastion-sg-tf"
  description = "SG para el trafico hacia la EC2 Bastion"
  vpc_id      = aws_vpc.vpc-tf.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Direcciones origen que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg-tf"
  }
}

################################################
# Grupo de seguridad para la instancia EC2 front
################################################

resource "aws_security_group" "front-sg-tf" {
  name        = "front-sg-tf"
  description = "SG para el trafico hacia el front"
  vpc_id      = aws_vpc.vpc-tf.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Permitir trafico de las instancias dentro del grupo de seguridad bastion
    security_groups = [aws_security_group.bastion-sg-tf.id]
  }

  ingress {
    description = "HTTP"
    from_port   = 4200
    to_port     = 4200
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "front-sg-tf"
  }
}

############################################
# Grupo de seguridad para las bases de datos
############################################

resource "aws_security_group" "databases-sg-tf" {
  name        = "databases-sg-tf"
  description = "SG para el trafico hacia las bases de datos"
  vpc_id      = aws_vpc.vpc-tf.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Permitir trafico de las instancias dentro del grupo de seguridad bastion
    security_groups = [aws_security_group.bastion-sg-tf.id]
  }

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MongoDB"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Cassandra"
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "databases-sg-tf"
  }
}

################################
# Grupo de seguridad para el EFS
################################

resource "aws_security_group" "efs-sg-tf" {
  name        = "efs-sg-tf"
  description = "SG para el trafico hacia el EFS"
  vpc_id      = aws_vpc.vpc-tf.id

  ingress {

    description = "NFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs-sg-tf"
  }
}

############################################################
# Grupo de seguridad para el Application Load Balancer (ALB)
############################################################

resource "aws_security_group" "alb-sg-tf" {
  name        = "alb-sg-tf"
  description = "SG para el trafico hacia el ALB"
  vpc_id      = aws_vpc.vpc-tf.id

  ingress {
    description = "HTTP"
    from_port   = 4200
    to_port     = 4200
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 8999
    to_port     = 8999
    protocol    = "tcp"
    # Subredes que pueden acceder
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg-tf"
  }
}