variable "myregion" {
    type = string
}

variable "accountId" {
    type = string
}

variable "invoke_arns" {
    type = list(string)
}

variable "function_names" {
    type = list(string)
}

variable "authorizer" {
  type = map(string)
}