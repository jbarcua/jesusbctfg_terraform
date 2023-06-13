#############
# Cluster ECS
#############

resource "aws_ecs_cluster" "cluster-app-tf" {
  name = "cluster-app-tf"
  tags = {
    "Name" = "cluster-app-tf"
  }
}

########################################
# Dos instancias EC2 para el cluster ECS
########################################

resource "aws_instance" "ec2-ecs-tf" {
  # Amazon ECS-optimized Amazon Linux 2 AMI
  ami                         = "ami-04d9730eb75fb5301"
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1a"
  key_name                    = "clave_maquinas_TFG"
  # Desplegar 2 instancias en el mismo resource con "count"
  count                       = 2 
  vpc_security_group_ids      = [aws_security_group.servicios-sg-tf.id]
  subnet_id                   = aws_subnet.subred-servicios-1a-tf.id
  # Instancia publica
  associate_public_ip_address = true
  # Rol ECS
  iam_instance_profile = aws_iam_instance_profile.perfil-ecsInstanceRole-tf.id
  tags = {
    "Name" = "ec2-ecs-${count.index + 1}-tf"
  }
  # Esperar a la creacion de: Cluster ECS
  depends_on = [aws_ecs_cluster.cluster-app-tf]
  # Funcion templatefile ejecuta el script pasandole la variable cluster_name con el nombre del cluster ECS
  user_data = templatefile("scripts/ec2_ecs.sh", {
    cluster_name = aws_ecs_cluster.cluster-app-tf.name
  })
}
