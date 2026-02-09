# Output variables to be used in other modules

output "vpc-id" {
  description = "VPC ID"
  value       = aws_vpc.terraform_vpc.id
}

output "subnet-pub1" {
  description = "Public Subnet 1 ID"
  value       = aws_subnet.public_1.id
}

output "subnet-pub2" {
  description = "Public Subnet 2 ID"
  value       = aws_subnet.public_2.id
}

output "subnet-pri1" {
  description = "Private Subnet 1 ID"
  value       = aws_subnet.private_1.id
}

output "subnet-pri2" {
  description = "Private Subnet 2 ID"
  value       = aws_subnet.private_2.id
}