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

  count          = length(var.subnet_ids["pub"])
  subnet_id      = var.subnet_ids["pub"][count.index]
  route_table_id = aws_route_table.pub_rt.id
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
  count          = length(var.subnet_ids["app"])
  route_table_id = aws_route_table.app_rt.id
  subnet_id      = var.subnet_ids["app"][count.index]
}

resource "aws_route_table" "db_rt" {
  vpc_id = var.vpc_id
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-db-rt"
    },
  )

}

resource "aws_route_table_association" "db_rt_subnets" {
  count          = length(var.subnet_ids["db"])
  route_table_id = aws_route_table.db_rt.id
  subnet_id      = var.subnet_ids["db"][count.index]
}
