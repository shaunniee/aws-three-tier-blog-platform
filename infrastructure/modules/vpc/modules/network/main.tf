
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-vpc"
  })
}
resource "aws_subnet" "subnets_creation" {
  for_each = merge([
    for tier, tier_map in local.subnets : {
      for k, v in tier_map :
      "${k}" => merge(v, { tier = tier })
    }
  ]...)

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-sub-${each.key}"
  })

}

