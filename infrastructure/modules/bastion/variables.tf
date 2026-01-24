variable "name_prefix" {
  description = "Prefix for naming resources"
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
