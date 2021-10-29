provider "aws" {
  region = var.region
}
terraform {
  backend "s3" {
    bucket  = "daniel-terraform-backend"
    key     = "project-prod/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}
