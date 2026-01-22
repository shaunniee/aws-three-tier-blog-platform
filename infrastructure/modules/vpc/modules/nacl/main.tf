
resource "aws_network_acl" "public_network_acl" {
  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnet_ids
  tags       = merge(var.tags, { Name = "${var.name_prefix}-nacl-pub" })
}

resource "aws_network_acl_rule" "public_network_acl_rules" {
  for_each       = { for rule in local.public_nacl_rules : rule.name => rule }
  network_acl_id = aws_network_acl.public_network_acl.id
  rule_number    = each.value.rule_no
  protocol       = each.value.protocol
  rule_action    = each.value.action
  egress         = lookup(each.value, "egress", false)
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl" "app_network_acl" {
  vpc_id     = var.vpc_id
  subnet_ids = var.app_subnet_ids
  tags       = merge(var.tags, { Name = "${var.name_prefix}-nacl-app" })
}

resource "aws_network_acl_rule" "app_network_acl_rules" {
  for_each       = { for rule in local.app_network_acl_rules : rule.name => rule }
  network_acl_id = aws_network_acl.app_network_acl.id
  rule_number    = each.value.rule_no
  protocol       = each.value.protocol
  rule_action    = each.value.action
  egress         = lookup(each.value, "egress", false)
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl" "db_network_acl" {
  vpc_id     = var.vpc_id
  subnet_ids = var.db_subnet_ids
  tags       = merge(var.tags, { Name = "${var.name_prefix}-nacl-db" })
}

resource "aws_network_acl_rule" "db_network_acl_rules" {
  for_each       = { for rule in local.db_nacl_rules : rule.name => rule }
  network_acl_id = aws_network_acl.db_network_acl.id
  rule_number    = each.value.rule_no
  protocol       = each.value.protocol
  rule_action    = each.value.action
  egress         = lookup(each.value, "egress", false)
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}
