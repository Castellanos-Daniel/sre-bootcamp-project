resource "aws_security_group" "instance_sg" {
  name        = "Intance SG"
  description = "Manage host access"
  vpc_id      = var.vpc_ids[0]

  ingress {
    description = "SSh connection"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Allow SSH"
  }
}

resource "aws_network_interface" "nic" {
  subnet_id = var.subnet_id
  security_groups = [aws_security_group.instance_sg.id]
  tags = {
    Name = "bastion host NIC"
  }
}

resource "aws_instance" "bastion_host" {
  ami           = "ami-00dfe2c7ce89a450b" # us-east-2
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.nic.id
    device_index         = 0
  }

}

