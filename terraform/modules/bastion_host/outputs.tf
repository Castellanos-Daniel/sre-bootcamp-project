output "host_sg_name" {
    value = aws_security_group.instance_sg.name
}

output "host_sg_id" {
    value = aws_security_group.instance_sg.id
}