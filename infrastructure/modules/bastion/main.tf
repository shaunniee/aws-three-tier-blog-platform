data "aws_ami" "bastion_ami" {
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


resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.bastion_ami.id
  instance_type               = "t3.micro"
  subnet_id                   = element(var.subnet_ids["pub"], 0)
  vpc_security_group_ids      = [var.bastion_sg_id]
  key_name                    = "blogapp-bastion-key"
  associate_public_ip_address = true
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bastion"
  })
}