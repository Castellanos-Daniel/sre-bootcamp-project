resource "aws_security_group" "vpc_sg" {
  name        = "vpc_sg"
  description = "Created for private vpc"
  vpc_id      = var.vpc_id

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = {
    Name = "terraform_vpc_sg"
  }
}