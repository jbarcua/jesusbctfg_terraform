###################
# Bucket S3 privado
###################

resource "aws_s3_bucket" "db-services-bucket-tf" {
  bucket = "db-services-bucket-tf"
  tags = {
    Name    = "db-services-bucket-tf"
  }
}

# Script inicial de la base de datos MongoDB
resource "aws_s3_object" "init-mongodb_fichero" {
  bucket = aws_s3_bucket.db-services-bucket-tf.id
  key    = "init-mongodb.js"
  source = "s3_archivos/init-mongodb.js"
}

# Fichero con las variables de entorno para las instancias EC2
resource "aws_s3_object" "env_vars_fichero" {
  bucket = aws_s3_bucket.db-services-bucket-tf.id
  key    = "env_vars.env"
  content = templatefile("s3_archivos/env_vars.env", {
    front_endpoint   = aws_lb.ALB-tf.dns_name
    postgres_host    = aws_db_instance.rds-sensor-postgres-tf.address
    mysql_host       = aws_db_instance.rds-authentication-mysql-tf.address
    mongo_host       = aws_instance.ec2-plots-mongo-tf.private_ip
    cassandra_host   = aws_instance.ec2-statistics-cassandra-tf.private_ip
  })
}

##########################################################
# Carpeta con los ficheros para la base de datos Cassandra
##########################################################

resource "aws_s3_object" "cassandra_carpeta" {
  bucket = aws_s3_bucket.db-services-bucket-tf.id
  key    = "cassandra/"
  content_type = "application/x-directory"
}
# Fichero de la carpeta "cassandra": "docker-compose-cassandra.yml"
resource "aws_s3_object" "docker-compose-cassandra_fichero" {
  bucket = aws_s3_bucket.db-services-bucket-tf.id
  key    = "cassandra/docker-compose-cassandra.yml"
  content = templatefile("s3_archivos/cassandra/docker-compose-cassandra.yml", {
    efs_ip = aws_efs_mount_target.efs-mt.ip_address
  })
}

######################################################
# Carpetas dentro de la carpeta "cassandra" principal: 
# 1) bash
# 2) cql
######################################################

# 1) Carpeta "cassandra/bash"
resource "aws_s3_object" "bash_carpeta" {
  bucket = aws_s3_bucket.db-services-bucket-tf.id
  key    = "cassandra/bash/"
  content_type = "application/x-directory"
}
# Fichero de la carpeta "cassandra/bash": "cassandra_init.sh"
resource "aws_s3_object" "cassandra_init_fichero" {
  bucket = aws_s3_bucket.db-services-bucket-tf.id
  key    = "cassandra/bash/cassandra_init.sh"
  source = "s3_archivos/cassandra/bash/cassandra_init.sh"
}

# 2) Carpeta "cassandra/cql"
resource "aws_s3_object" "cql_carpeta" {
  bucket = aws_s3_bucket.db-services-bucket-tf.id
  key    = "cassandra/cql/"
  content_type = "application/x-directory"
}
# Fichero de la carpeta "cassandra/cql": "init_keyspace.cql"
resource "aws_s3_object" "init_keyspace_fichero" {
  bucket = aws_s3_bucket.db-services-bucket-tf.id
  key    = "cassandra/cql/init_keyspace.cql"
  source = "s3_archivos/cassandra/cql/init_keyspace.cql"
}

