data "aws_vpcs" "created_vpc" {
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  depends_on = [
    module.my_vpc
  ]
}
data "aws_caller_identity" "current" {}
