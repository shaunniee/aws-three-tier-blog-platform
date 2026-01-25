data "aws_ami" "image_id" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_caller_identity" "current" {}



resource "aws_lb" "backend_alb" {
  name               = "${var.name_prefix}-backend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.subnet_ids["pub"]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-backend-alb"
  })
}

resource "aws_lb_listener" "aws_lb_listener" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_lb_tg.arn
  }
}

resource "aws_lb_target_group" "aws_lb_tg" {
  name_prefix = "blog"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    port = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
    lifecycle {
    create_before_destroy = true
  }
}


locals {
  user_data = templatefile("${path.module}/user_data.sh", {
    AWS_REGION   = "eu-west-1"
    AWS_ACCOUNT_ID = data.aws_caller_identity.current.account_id
  })
}

resource "aws_launch_template" "l_temp" {
  name_prefix            = "${var.name_prefix}-backend-lt-ch"
  image_id               = data.aws_ami.image_id.id
  instance_type          = "t3.micro"
  key_name               = "blogapp-backend-key"
  vpc_security_group_ids = [var.app_sg_id]
  iam_instance_profile {
    name = module.instance_profile.backend_instance_profile
  }

  user_data = base64encode(local.user_data)

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      Name = "${var.name_prefix}-backend-instance"
    })
  }

}

resource "aws_autoscaling_group" "backend_asg" {
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2
  vpc_zone_identifier = var.subnet_ids["app"]
  launch_template {
    id      = aws_launch_template.l_temp.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.aws_lb_tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-backend-asg"
    propagate_at_launch = true
  }

    instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 60
    }
    }
  health_check_type         = "ELB"
  health_check_grace_period = 300

}

module "instance_profile" {
  source = "./instance_profile"
  s3_arn = var.s3_arn
  db_secret_arn = var.db_secret_arn
  cog_user_pool_arn = var.cog_user_pool_arn
}
