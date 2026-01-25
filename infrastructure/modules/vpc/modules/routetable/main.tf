resource "aws_route_table" "pub_rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-pub-rt"
    },
  )

}

resource "aws_route_table_association" "pub_rt_subnets" {

  for_each       = {for subnet_id in var.subnet_ids["pub"] : subnet_id => subnet_id}
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = each.value
}

resource "aws_route_table" "app_rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gw_id
  }
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-app-rt"
    },
  )

}

resource "aws_route_table_association" "app_rt_subnets" {
  for_each       = {for subnet_id in var.subnet_ids["app"] : subnet_id => subnet_id}
  route_table_id = aws_route_table.app_rt.id
  subnet_id      = each.value
}

resource "aws_route_table" "db_rt" {
  vpc_id = var.vpc_id
   route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = var.igw_id
  }
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-db-rt"
    },
  )

}

resource "aws_route_table_association" "db_rt_subnets" {
  for_each       = {for subnet_id in var.subnet_ids["db"] : subnet_id => subnet_id}
  route_table_id = aws_route_table.db_rt.id
  subnet_id      = each.value
}
