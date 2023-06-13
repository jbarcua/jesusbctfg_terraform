#################
# ALB + Listeners
#################

# Balanceador de carga ALB
resource "aws_lb" "ALB-tf" {
  name                = "ALB-tf"
  internal            = "false"
  load_balancer_type = "application"
  subnets             = [aws_subnet.subred-servicios-1a-tf.id, aws_subnet.subred-front-1b-tf.id]
  security_groups     = [aws_security_group.alb-sg-tf.id] 
  tags = {
    "Name" = "ALB-tf"
  }
}
# Listener - Front: 4200
resource "aws_lb_listener" "front-listener-tf" {
  load_balancer_arn = aws_lb.ALB-tf.arn
  port              = "4200"
  protocol          = "HTTP"
  # Regla redireccion de la peticion hacia el grupo de destino
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front-target-tf.arn
  }
}
# Listener - Plots: 8080
resource "aws_lb_listener" "plots-listener-tf" {
  load_balancer_arn = aws_lb.ALB-tf.arn
  port              = "8080"
  protocol          = "HTTP"
  # Regla redireccion de la peticion hacia el grupo de destino
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.plots-target-tf.arn
  }
}
# Listener - Sensor: 8081
resource "aws_lb_listener" "sensor-listener-tf" {
  load_balancer_arn = aws_lb.ALB-tf.arn
  port              = "8081"
  protocol          = "HTTP"
  # Regla redireccion de la peticion hacia el grupo de destino
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sensor-target-tf.arn
  }
}
# Listener - Statistics: 8082
resource "aws_lb_listener" "statistics-listener-tf" {
  load_balancer_arn = aws_lb.ALB-tf.arn
  port              = "8082"
  protocol          = "HTTP"
  # Regla redireccion de la peticion hacia el grupo de destino
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.statistics-target-tf.arn
  }
}
# Listener - Authentication: 8999
resource "aws_lb_listener" "authentication-listener-tf" {
  load_balancer_arn = aws_lb.ALB-tf.arn
  port              = "8999"
  protocol          = "HTTP"
  # Regla redireccion de la peticion hacia el grupo de destino
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.authentication-target-tf.arn
  }
}


###################################################
# Grupos de destino + Asignacion instancias destino
###################################################

# Grupo de destino - Front
resource "aws_lb_target_group" "front-target-tf" {
  name        = "front-target-tf"
  target_type = "instance"
  port        = "4200"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc-tf.id
  # Comprobacion de estado de salud
  health_check {
    healthy_threshold   = "2"
    interval            = "30"
    port                = "4200"
    path                = "/"
    protocol            = "HTTP"
    unhealthy_threshold = "2"
  }
}
# Asignar las instancias destino al grupo de destino - Front
resource "aws_lb_target_group_attachment" "asignacion-destinos-front" {
    target_group_arn = aws_lb_target_group.front-target-tf.arn
    target_id        = aws_instance.ec2-front-tf.id
    port             = 4200
}

# Grupo de destino - Plots
resource "aws_lb_target_group" "plots-target-tf" {
  name        = "plots-target-tf"
  target_type = "instance"
  port        = "8080"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc-tf.id
  # Comprobacion de estado de salud
  health_check {
    healthy_threshold   = "2"
    interval            = "30"
    port                = "8080"
    path                = "/actuator/health"
    protocol            = "HTTP"
    unhealthy_threshold = "2"
  }
}
# Asignar las instancias destino al grupo de destino - Plots
# Instancias EC2 pertenecientes al cluster ECS
resource "aws_alb_target_group_attachment" "asignacion-destinos-plots" {
  count = length(aws_instance.ec2-ecs-tf)
  target_group_arn = aws_lb_target_group.plots-target-tf.arn
  target_id = aws_instance.ec2-ecs-tf[count.index].id
}

# Grupo de destino - Sensor
resource "aws_lb_target_group" "sensor-target-tf" {
  name        = "sensor-target-tf"
  target_type = "instance"
  port        = "8081"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc-tf.id
  # Comprobacion de estado de salud
  health_check {
    healthy_threshold   = "2"
    interval            = "30"
    port                = "8081"
    path                = "/actuator/health"
    protocol            = "HTTP"
    unhealthy_threshold = "2"
  }
}
# Asignar las instancias destino al grupo de destino - Sensor
# Instancias EC2 pertenecientes al cluster ECS
resource "aws_alb_target_group_attachment" "asignacion-destinos-sensor" {
  count = length(aws_instance.ec2-ecs-tf)
  target_group_arn = aws_lb_target_group.sensor-target-tf.arn
  target_id = aws_instance.ec2-ecs-tf[count.index].id
}

# Grupo de destino - Statistics
resource "aws_lb_target_group" "statistics-target-tf" {
  name        = "statistics-target-tf"
  target_type = "instance"
  port        = "8082"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc-tf.id
  # Comprobacion de estado de salud
  health_check {
    healthy_threshold   = "2"
    interval            = "30"
    port                = "8082"
    path                = "/actuator/health"
    protocol            = "HTTP"
    unhealthy_threshold = "2"
  }
}
# Asignar las instancias destino al grupo de destino - Statistics
# Instancias EC2 pertenecientes al cluster ECS
resource "aws_alb_target_group_attachment" "asignacion-destinos-statistics" {
  count = length(aws_instance.ec2-ecs-tf)
  target_group_arn = aws_lb_target_group.statistics-target-tf.arn
  target_id = aws_instance.ec2-ecs-tf[count.index].id
}

# Grupo de destino - Authentication
resource "aws_lb_target_group" "authentication-target-tf" {
  name        = "authentication-target-tf"
  target_type = "instance"
  port        = "8999"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc-tf.id
  # Comprobacion de estado de salud
  health_check {
    healthy_threshold   = "2"
    interval            = "30"
    port                = "8999"
    path                = "/actuator/health"
    protocol            = "HTTP"
    unhealthy_threshold = "2"
  }
}
# Asignar las instancias destino al grupo de destino - Authentication
# Instancias EC2 pertenecientes al cluster ECS
resource "aws_alb_target_group_attachment" "asignacion-destinos-authentication" {
  count = length(aws_instance.ec2-ecs-tf)
  target_group_arn = aws_lb_target_group.authentication-target-tf.arn
  target_id = aws_instance.ec2-ecs-tf[count.index].id
}