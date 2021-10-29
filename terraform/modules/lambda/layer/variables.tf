variable "name" {
  type = string
}

variable "filename" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "object_key" {
  type = string
  default = "deps.zip"
}