#########################
# Sistema de ficheros EFS
#########################

resource "aws_efs_file_system" "efs-tf" {
  creation_token   = "efs-tf"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "efs-tf"
  }
}

############################
# Destino de montaje del EFS
############################

resource "aws_efs_mount_target" "efs-mt" {
  file_system_id  = aws_efs_file_system.efs-tf.id
  subnet_id       = aws_subnet.subred-databases-1a-tf.id
  security_groups = [aws_security_group.efs-sg-tf.id]
  depends_on = [aws_efs_file_system.efs-tf]
}
