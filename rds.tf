################################
# Grupo de subredes para las RDS
################################

resource "aws_db_subnet_group" "databases-grupo-subnet-tf" {
  name = "databases-grupo-subnet-tf"
  # Agrupacion de las subnets privadas, una en us-east-1a y otra en us-east-1b
  subnet_ids  = [aws_subnet.subred-databases-1a-tf.id, aws_subnet.subred-databases-1b-tf.id]
  description = "Grupo de subredes para las RDS, AZs us-east-1a y us-east-1b "
  tags = {
    Name = "databases-grupo-subnet-tf"
  }
}

##################################
# Base de datos RDS con PostgreSQL
##################################

resource "aws_db_instance" "rds-sensor-postgres-tf" {
  identifier             = "sensor-postgres-tf"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "14"
  instance_class         = "db.t3.micro"
  db_name                = "sensors"
  username               = "postgres"
  password               = "password"
  availability_zone      = "us-east-1a"
  # Se creara en la VPC a la que pertenecen las subredes del grupo
  db_subnet_group_name   = aws_db_subnet_group.databases-grupo-subnet-tf.name
  vpc_security_group_ids = [aws_security_group.databases-sg-tf.id]
  multi_az               = false
  skip_final_snapshot    = true
}

#############################
# Base de datos RDS con MySQL
#############################

resource "aws_db_instance" "rds-authentication-mysql-tf" {
  identifier           = "rds-authentication-mysql-tf"
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "users"
  username             = "root"
  password             = "password"
  availability_zone    = "us-east-1a"
  # Se creara en la VPC a la que pertenecen las subredes del grupo
  db_subnet_group_name   = aws_db_subnet_group.databases-grupo-subnet-tf.name
  vpc_security_group_ids = [aws_security_group.databases-sg-tf.id]
  multi_az               = false
  skip_final_snapshot    = true
}