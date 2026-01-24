variable "name_prefix" {
  description = "The name prefix for resources"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs for the DB subnet group"
  type        = map(list(string))
}

variable "db_sg_id" {
  description = "The ID of the DB security group"
  type        = string
}