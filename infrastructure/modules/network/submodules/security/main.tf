resource "aws_security_group" "bastion_sg" {
  name        = "${var.name_prefix}-sg-bastion"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name_prefix}-sg-bastion"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ingress" {
  description       = "Allow SSH from admin IP"
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = var.admin_ip
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  tags = merge(
    var.tags,
    {
      "Name" = "SSH to Bastion SG Rule"
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "bastion_egress" {
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  tags = merge(
    var.tags,
    {
      "Name" = "Bastion Egress Rule"
    }
  )
}


resource "aws_security_group" "alb_pub_sg" {
  name        = "${var.name_prefix}-sg-alb"
  description = "Security group for ALB public"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name_prefix}-sg-alb"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress_http" {
  description       = "Allow HTTP from anywhere"
  security_group_id = aws_security_group.alb_pub_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  tags = merge(
    var.tags,
    {
      "Name" = "ALB Ingress HTTP Rule"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress_https" {
  description       = "Allow HTTPS from anywhere"
  security_group_id = aws_security_group.alb_pub_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(
    var.tags,
    {
      "Name" = "ALB Ingress HTTPS Rule"
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "alb_egress_asg" {
  description                  = "Allow traffic to ASG SG"
  security_group_id            = aws_security_group.alb_pub_sg.id
  referenced_security_group_id = aws_security_group.asg_priv_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  tags = merge(
    var.tags,
    {
      "Name" = "ALB Egress to ASG Rule"
    }
  )
}

resource "aws_security_group" "asg_priv_sg" {
  name        = "${var.name_prefix}-sg-asg"
  description = "Security group for ASG private"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name_prefix}-sg-asg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "asg_ingress_alb" {
  description                  = "Allow traffic from ALB SG"
  security_group_id            = aws_security_group.asg_priv_sg.id
  referenced_security_group_id = aws_security_group.alb_pub_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  tags = merge(
    var.tags,
    {
      "Name" = "ASG Ingress from ALB Rule"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "asg_ingress_bastion" {
  description                  = "Allow SSH from Bastion SG"
  security_group_id            = aws_security_group.asg_priv_sg.id
  referenced_security_group_id = aws_security_group.bastion_sg.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  tags = merge(
    var.tags,
    {
      "Name" = "ASG Ingress from Bastion Rule"
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "asg_egress_db" {
  description                  = "Allow traffic to RDS SG"
  security_group_id            = aws_security_group.asg_priv_sg.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.db_sg.id
  tags = merge(
    var.tags,
    {
      "Name" = "ASG Egress to RDS Rule"
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "asg_egress_https" {
  description       = "Allow HTTPS outbound"
  security_group_id = aws_security_group.asg_priv_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags = merge(
    var.tags,
    {
      "Name" = "ASG Egress HTTPS Rule"
    }
  )
}

resource "aws_security_group" "db_sg" {
  name        = "${var.name_prefix}-sg-db"
  description = "Security group for RDS DB"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name_prefix}-sg-db"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "db_ingress_asg" {
  description       = "Allow traffic from ASG SG"
  security_group_id = aws_security_group.db_sg.id
  referenced_security_group_id = aws_security_group.asg_priv_sg.id
  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"
  tags = merge(
    var.tags,
    {
      "Name" = "RDS Ingress from ASG Rule"
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "db_egress" {
  description                  = "Allow all outbound traffic"
  security_group_id            = aws_security_group.db_sg.id
  referenced_security_group_id = aws_security_group.asg_priv_sg.id
  ip_protocol                  = "-1"
  tags = merge(
    var.tags,
    {
      "Name" = "RDS Egress Rule"
    }
  )
}


