variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public Subnet ids"
  type        = list(string)
}

variable "app_subnet_ids" {
  description = "App Subnet ids"
  type        = list(string)
}

variable "db_subnet_ids" {
  description = "DB Subnet ids"
  type        = list(string)

}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
}

variable "public_subnet_cidr" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "app_subnet_cidr" {
  description = "List of app subnet CIDR blocks"
  type        = list(string)
}

variable "db_subnet_cidr" {
  description = "List of db subnet CIDR blocks"
  type        = list(string)
}

variable "admin_ip" {
  description = "Admin ip for ssh"
  type        = string
  default     = "0.0.0.0/0"
}

locals {
  public_nacl_rules = [
    {
      name       = "ingress-allow-http"
      rule_no    = 100
      protocol   = "tcp"
      from_port  = 80
      to_port    = 80
      action     = "allow"
      cidr_block = "0.0.0.0/0"
    },
    {
      name       = "ingress-allow-https"
      rule_no    = 110
      protocol   = "tcp"
      from_port  = 443
      to_port    = 443
      action     = "allow"
      cidr_block = "0.0.0.0/0"
    },
    {
      name       = "ingress-allow-ssh"
      rule_no    = 120
      protocol   = "tcp"
      from_port  = 22
      to_port    = 22
      action     = "allow"
      cidr_block = var.admin_ip
    },
    {
      name       = "ingress-allow-ephemeral-ports"
      rule_no    = 130
      protocol   = "tcp"
      from_port  = 1024
      to_port    = 65535
      action     = "allow"
      cidr_block = "0.0.0.0/0"
    },
    {
      name       = "egress-allow-all"
      rule_no    = 100
      protocol   = "-1"
      from_port  = 0
      to_port    = 0
      action     = "allow"
      egress     = true
      cidr_block = "0.0.0.0/0"
    }
  ]
}


locals {
  app_network_acl_rules = [
    { name       = "ingress-allow-http-pub1"
      rule_no    = 100
      protocol   = "tcp"
      from_port  = 80
      to_port    = 80
      action     = "allow"
      cidr_block = var.public_subnet_cidr[0]
    },
    { name       = "ingress-allow-http-pub2"
      rule_no    = 101
      protocol   = "tcp"
      from_port  = 80
      to_port    = 80
      action     = "allow"
      cidr_block = var.public_subnet_cidr[1]
      }, {
      name       = "ingress-allow-ssh"
      rule_no    = 120
      protocol   = "tcp"
      from_port  = 22
      to_port    = 22
      action     = "allow"
      cidr_block = var.public_subnet_cidr[0]
    },
    {
      name       = "ingress-allow-ephemeral-ports"
      rule_no    = 130
      protocol   = "tcp"
      from_port  = 1024
      to_port    = 65535
      action     = "allow"
      cidr_block = "0.0.0.0/0"
    },
    {
      name       = "egress-db-c1"
      rule_no    = 100
      protocol   = "tcp"
      from_port  = 5432
      to_port    = 5432
      action     = "allow"
      egress     = true
      cidr_block = var.db_subnet_cidr[0]
      }, {
      name       = "egress-db-c2"
      rule_no    = 101
      protocol   = "tcp"
      from_port  = 5432
      to_port    = 5432
      action     = "allow"
      egress     = true
      cidr_block = var.db_subnet_cidr[1]
    },

    {
      name       = "egress-https"
      rule_no    = 110
      protocol   = "tcp"
      from_port  = 443
      to_port    = 443
      action     = "allow"
      action     = "allow"
      egress     = true
      cidr_block = "0.0.0.0/0"
      }, {
      name       = "egress-allow-ephemeral-ports"
      rule_no    = 120
      egress     = true
      protocol   = "tcp"
      from_port  = 1024
      to_port    = 65535
      action     = "allow"
      cidr_block = "0.0.0.0/0"
    }

  ]
}

locals {
  db_nacl_rules = [
    {
      name       = "ingress from app subnet 1"
      rule_no    = 100
      protocol   = "tcp"
      from_port  = 5432
      to_port    = 5432
      action     = "allow"
      cidr_block = var.app_subnet_cidr[0]
    },
    {
      name       = "ingress from app subnet 2"
      rule_no    = 101
      protocol   = "tcp"
      from_port  = 5432
      to_port    = 5432
      action     = "allow"
      cidr_block = var.app_subnet_cidr[1]
    },
    {
      name       = "egress-allow-ephemeral-ports to app subnet 1"
      rule_no    = 120
      egress     = true
      protocol   = "tcp"
      from_port  = 1024
      to_port    = 65535
      action     = "allow"
      cidr_block = var.app_subnet_cidr[0]
    },
    {
      name       = "egress-allow-ephemeral-ports to app subnet 2"
      rule_no    = 121
      egress     = true
      protocol   = "tcp"
      from_port  = 1024
      to_port    = 65535
      action     = "allow"
      cidr_block = var.app_subnet_cidr[1]
    }

  ]
}