variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string      
  
}
variable "bastion_ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet ID for the bastion host"
  type        = map(list(string))
}
variable "bastion_sg_id" {
  description = "Security Group ID for the bastion host"
  type        = string
}
