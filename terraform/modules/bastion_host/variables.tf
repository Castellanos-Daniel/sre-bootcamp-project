variable "vpc_ids" {
  type = list(string)
}
variable "subnet_id" {
  type = string
}

variable "name" {
  type = string
  default = ""
}