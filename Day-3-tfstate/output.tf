output "public_ip" {
    value = aws_instance.name.public_ip
}
output "private_ip"{
    value = aws_instance.name.private_ip
}
output "instance_name"{
    value = aws_instance.name.tags["Name"]
}