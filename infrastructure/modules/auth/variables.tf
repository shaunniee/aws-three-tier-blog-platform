variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string

}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
}
variable "cf_public_dns" {
  description = "CloudFront Public DNS"
  type        = string

}