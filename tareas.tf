###############
# Tarea - Plots
###############

resource "aws_ecs_task_definition" "tarea-plots-tf" {
  family                   = "tarea-plots-tf"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = "arn:aws:iam::690031176274:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::690031176274:role/ecsTaskExecutionRole"
  container_definitions    = file("tareas_ecs/tarea-plots.json")
}

################
# Tarea - Sensor
################

resource "aws_ecs_task_definition" "tarea-sensor-tf" {
  family                   = "tarea-sensor-tf"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = "arn:aws:iam::690031176274:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::690031176274:role/ecsTaskExecutionRole"
  container_definitions    = file("tareas_ecs/tarea-sensor.json")
}

####################
# Tarea - Statistics
####################

resource "aws_ecs_task_definition" "tarea-statistics-tf" {
  family                   = "tarea-statistics-tf"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = "arn:aws:iam::690031176274:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::690031176274:role/ecsTaskExecutionRole"
  container_definitions    = file("tareas_ecs/tarea-statistics.json")
}

########################
# Tarea - Authentication
########################

resource "aws_ecs_task_definition" "tarea-authentication-tf" {
  family                   = "tarea-authentication-tf"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = "arn:aws:iam::690031176274:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::690031176274:role/ecsTaskExecutionRole"
  container_definitions    = file("tareas_ecs/tarea-authentication.json")
}