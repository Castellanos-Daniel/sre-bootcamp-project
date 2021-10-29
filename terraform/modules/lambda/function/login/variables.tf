variable "source_path" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "deps_layer_arn" {
  type = string
}

variable "env_vars" {
  type = map(string)
}
