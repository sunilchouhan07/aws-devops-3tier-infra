resource "aws_security_group" "alb_sg" {
  name        = "${var.env}-alb-sg"
  vpc_id      = var.vpc_id
  description = "Security group for Application Load Balancer"
  tags = {
    Name        = "${var.env}-alb-sg"
    Environment = var.env
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_lb" "app_alb" {
  name               = "${var.env}-alb"
  load_balancer_type = "application"
  internal           = false

  subnets = var.public_sub_id

  security_groups = [aws_security_group.alb_sg.id]
  tags = {
    Name        = "${var.env}-app-alb"
    Environment = var.env
  }

}


resource "aws_lb_target_group" "app_tg" {
  name     = "${var.env}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = var.health_interval
    timeout             = var.timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    matcher             = "200"
  }

  tags = {
    Name        = "${var.env}-alb-tg"
    Environment = var.env
  }

}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

