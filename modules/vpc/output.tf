
output "public_subnet_a_id" {
  value = aws_subnet.public_subnet_a_result.id
}

output "public_subnet_b_id" {
  value = aws_subnet.public_subnet_b_result.id
}

output "private_subnet_a_id" {
  value = aws_subnet.private_subnet_a_result.id
}

output "private_subnet_b_id" {
  value = aws_subnet.private_subnet_b_result.id
}

output "default_security_group_id" {
  value = data.aws_security_group.default_security_group.id
}

output "ssh_security_group_id" {
  value = aws_security_group.ssh_security_group_result.id
}

output "http_8080_security_group_id" {
  value = aws_security_group.http_8080_security_group_result.id
}
