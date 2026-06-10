
#Security Group
resource "aws_security_group" "app_sg" {
  vpc_id = var.app_vpc_id
  name   = "${var.env}-app-sg"
  tags = {
    Name        = "${var.env}-app-sg"
    Environment = var.env
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.env}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.env}-ec2-profile"
  role = aws_iam_role.ec2_ssm_role.name
}



# Launch Template

resource "aws_launch_template" "three_tier_lt" {
  # name_prefix = "${var.env}-lt"
  name_prefix            = "${local.env}-lt"
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  # user_data = base64encode(file("${path.module}/${var.script}"))
  user_data = base64encode(
    templatefile("${path.module}/script.sh", {
      environment = var.env
    })
  )

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.rbd_size
      volume_type = "gp3"
    }

  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env}-ec2-asg"
    }
  }
}



#Auto-Scaling Group
resource "aws_autoscaling_group" "three_tier_asg" {
  name = "${var.env}-asg"

  vpc_zone_identifier = var.private_subnets_id
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity

  launch_template {
    id      = aws_launch_template.three_tier_lt.id
    version = "$Latest"
  }


  target_group_arns = [
    var.tg_arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = var.health_check_period

  tag {
    key                 = "Name"
    value               = "${var.env}-asg"
    propagate_at_launch = true

  }
}
