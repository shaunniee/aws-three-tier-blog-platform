# variable "app_subnet_cidr" {
#   description = "CIDR for App subnets"
#   type        = list(string)
# }

# variable "db_subnet_cidr" {
#   description = "CIDR for DB subnets"
#   type        = list(string)
# }

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}
# variable "public_subnet_cidr" {
#   description = "CIDR for Public subnets"
#   type        = list(string)
# }
variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "no_of_azs" {
  description = "Number of availability zones to use"
  type        = number
}

variable "subnets" {
  description = "A map of subnet tiers to list of CIDR blocks"
  type        = map(list(string))

}

data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.azs.names, 0, var.no_of_azs)
}

locals {
  subnets = {
    for tier, sub in var.subnets : tier => {
      for idx, cidr in sub : "${tier}-${idx + 1}" => {
        cidr_block = cidr
        az         = local.azs[idx]
      }
    }
  }
}

locals{
  subnets_by_tier = {
    for tier, tier_map in local.subnets : tier => [
      for k, v in tier_map : aws_subnet.subnets_creation["${k}"].id
    ]
  }
}

locals {
  subnet_info={
    for tier,tier_map in aws_subnet.subnets_creation: tier=>{
      id:tier_map.id,
      cidr: tier_map.cidr_block,
      az: tier_map.availability_zone
      tier: tier_map.tags["Name"]
    }
  }
}
