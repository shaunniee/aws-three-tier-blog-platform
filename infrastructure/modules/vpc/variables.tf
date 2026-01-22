variable "vpc_cidr" {
  description = "vpc cidr"
  type        = string
}

variable "tags" {
  description = "tags to be applied to resources"
  type        = map(string)
  default     = {}
}
variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "no_of_azs" {
  description = "Number of availability zones to use"
  type        = number
}

variable "subnets" {
  description = "A map of subnet types to subnet IDs"
  type        = map(list(string))
  
}

