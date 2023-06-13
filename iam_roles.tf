###########################################################
# Rol con politica de acceso a S3 para EC2 + Perfil IAM EC2
###########################################################

# Rol para permitir a las EC2 obtener permisos de acceso S3
resource "aws_iam_role" "AmazonS3FullAccess-tf" {
  name = "AmazonS3FullAccess-tf"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}

# Asignacion de la politica o permiso de acceso a S3 al rol de tipo EC2 creado
resource "aws_iam_role_policy_attachment" "asignacion-politica-AmazonS3FullAccess" {
  role       = aws_iam_role.AmazonS3FullAccess-tf.name
  # Politica de AWS existente para acceso completo al servicio S3
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Perfil de instancia IAM con el rol creado que se asigna a la EC2 durante su creacion
resource "aws_iam_instance_profile" "perfil-AmazonS3FullAccess-tf" {
  name = "perfil-AmazonS3FullAccess-tf"
  role = aws_iam_role.AmazonS3FullAccess-tf.name
}

############################################################
# Rol con politica de permisos ECS para EC2 + Perfil IAM EC2
############################################################

# Rol para dar permiso a las instancias EC2 para operaciones de ECS
resource "aws_iam_role" "ecsInstanceRole-tf" {
  name = "ecsInstanceRole-tf"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}

# Asignacion de la politica o permiso de operaciones ECS sobre las EC2
resource "aws_iam_role_policy_attachment" "asignacion-politica-ecsInstanceRole" {
  role       = aws_iam_role.ecsInstanceRole-tf.name
  # Politica de AWS existente para operaciones ECS
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# Perfil de instancia IAM con el rol creado que se asigna a la EC2 durante su creacion
resource "aws_iam_instance_profile" "perfil-ecsInstanceRole-tf" {
  name = "perfil-ecsInstanceRole-tf"
  role = aws_iam_role.ecsInstanceRole-tf.name
}