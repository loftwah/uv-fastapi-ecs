output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.main[*].id
}

output "vpc_endpoint_s3_id" {
  description = "The ID of S3 VPC endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "vpc_endpoint_security_group_id" {
  description = "The ID of the VPC endpoints security group"
  value       = aws_security_group.vpc_endpoints.id
}