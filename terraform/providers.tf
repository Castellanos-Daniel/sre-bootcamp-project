provider "aws" {
  region = "us-east-2"
}
terraform {
  backend "s3" {
    bucket  = "daniel-terraform-backend"
    key     = "project/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}
