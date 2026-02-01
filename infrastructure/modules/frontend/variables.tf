
variable "name_prefix" {
    description = "Prefix for naming resources"
    type        = string
}
variable "tags" {
    description = "A map of tags to assign to resources"
    type        = map(string)
    default     = {}
}