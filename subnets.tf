#######################################
# Subnet publica servicios (us-east-1a)
#######################################

resource "aws_subnet" "subred-servicios-1a-tf" {
  vpc_id                  = aws_vpc.vpc-tf.id
  cidr_block              = "10.1.10.0/24"
  availability_zone       = "us-east-1a"
  # Instancias dentro de la subred tendran una IP publica
  map_public_ip_on_launch = true
  tags = {
    Name = "subred-servicios-1a-tf"
  }
}

#########################################################
# Subnet publica con Front-end y NAT Gateway (us-east-1b)
#########################################################

resource "aws_subnet" "subred-front-1b-tf" {
  vpc_id                  = aws_vpc.vpc-tf.id
  cidr_block              = "10.1.20.0/24"
  availability_zone       = "us-east-1b"
  # Instancias dentro de la subred tendran una IP publica
  map_public_ip_on_launch = true
  tags = {
    Name = "subred-front-1b-tf"
  }
}

###############################################
# Subnet privada de bases de datos (us-east-1a)
###############################################

resource "aws_subnet" "subred-databases-1a-tf" {
  vpc_id            = aws_vpc.vpc-tf.id
  cidr_block        = "10.1.30.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "subred-databases-1a-tf"
  }
}

###############################################
# Subnet privada de bases de datos (us-east-1b)
###############################################

resource "aws_subnet" "subred-databases-1b-tf" {
  vpc_id            = aws_vpc.vpc-tf.id
  cidr_block        = "10.1.40.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "subred-databases-1b-tf"
  }
}