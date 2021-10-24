variable "subnets" {
  type = list(string)
}

variable "instance_name" {
  type = string
}

variable "master_user" {
  type = string
  sensitive = true
}

variable "master_pass" {
  type = string
  sensitive = true
}

variable "db_name" {
  type = string
  default = "bootcamp"
}
