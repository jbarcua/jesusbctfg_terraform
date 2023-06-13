##############################################################
# Instancia EC2 Bastion para configuracion de otras instancias
##############################################################

resource "aws_instance" "ec2-bastion-tf" {
  ami                         = "ami-0715c1897453cabd1"
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1a"
  key_name                    = "clave_maquinas_TFG"
  vpc_security_group_ids      = [aws_security_group.bastion-sg-tf.id]
  subnet_id                   = aws_subnet.subred-servicios-1a-tf.id
  # Instancia publica
  associate_public_ip_address = true
  # Rol de acceso a servicios S3
  iam_instance_profile = aws_iam_instance_profile.perfil-AmazonS3FullAccess-tf.id
  tags = {
    "Name" = "ec2-bastion-tf"
  }
  # Esperar a la creacion de: Punto de montaje EFS
  depends_on = [aws_efs_mount_target.efs-mt]
  # Funcion templatefile ejecuta el script pasandole la variable efs_ip con la IP del EFS
  user_data = templatefile("scripts/ec2_bastion.sh", {
    efs_ip= aws_efs_mount_target.efs-mt.ip_address
  })
}

######################################
# Instancia EC2 con servicio del Front
######################################

resource "aws_instance" "ec2-front-tf" {
  ami                         = "ami-0715c1897453cabd1"
  instance_type               = "t2.small"
  availability_zone           = "us-east-1b"
  key_name                    = "clave_maquinas_TFG"
  vpc_security_group_ids      = [aws_security_group.front-sg-tf.id]
  subnet_id                   = aws_subnet.subred-front-1b-tf.id
  # Instancia publica
  associate_public_ip_address = true
  # Rol de acceso a servicios S3
  iam_instance_profile = aws_iam_instance_profile.perfil-AmazonS3FullAccess-tf.id
  tags = {
    "Name" = "ec2-front-tf"
  }
  # Esperar a la creacion de: S3 Bucket
  depends_on = [aws_s3_object.env_vars_fichero] 
  # Funcion templatefile ejecuta el script
  user_data = file("scripts/ec2_front.sh")
}

####################################
# Instancia EC2 con servicio MongoDB
####################################

resource "aws_instance" "ec2-plots-mongo-tf" {
  ami                    = "ami-0715c1897453cabd1"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  key_name               = "clave_maquinas_TFG"
  vpc_security_group_ids = [aws_security_group.databases-sg-tf.id]
  subnet_id              = aws_subnet.subred-databases-1a-tf.id
  # Instancia privada
  associate_public_ip_address = false
  # Rol de acceso a servicios S3
  iam_instance_profile = aws_iam_instance_profile.perfil-AmazonS3FullAccess-tf.id
  tags = {
    "Name" = "ec2-plots-mongo-tf"
  }
  # Esperar a la creacion de: Punto de montaje EFS, EC2 Bastion y S3 Bucket
  depends_on = [aws_efs_mount_target.efs-mt, aws_instance.ec2-bastion-tf, aws_s3_bucket.db-services-bucket-tf]
  # Funcion templatefile ejecuta el script pasandole la variable efs_ip con la IP del EFS
  user_data = templatefile("scripts/ec2_mongodb.sh", {
    efs_ip = aws_efs_mount_target.efs-mt.ip_address
  })
}

######################################
# Instancia EC2 con servicio Cassandra
######################################

resource "aws_instance" "ec2-statistics-cassandra-tf" {
  ami                    = "ami-0715c1897453cabd1"
  instance_type          = "t2.medium"
  availability_zone      = "us-east-1a"
  key_name               = "clave_maquinas_TFG"
  vpc_security_group_ids = [aws_security_group.databases-sg-tf.id]
  subnet_id              = aws_subnet.subred-databases-1a-tf.id
  # Instancia privada
  associate_public_ip_address = false
  # Rol de acceso a servicios S3
  iam_instance_profile = aws_iam_instance_profile.perfil-AmazonS3FullAccess-tf.id
  tags = {
    "Name" = "ec2-statistics-cassandra-tf"
  }
 # Esperar a la creacion de: Punto de montaje EFS, EC2 Bastion y S3 Bucket
  depends_on = [aws_efs_mount_target.efs-mt, aws_instance.ec2-bastion-tf, aws_s3_bucket.db-services-bucket-tf]
  # Funcion templatefile ejecuta el script
  user_data = file("scripts/ec2_cassandra.sh")
}
