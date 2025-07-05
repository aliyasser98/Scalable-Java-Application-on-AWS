output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for subnet in aws_subnet.java_public_subnet : subnet.id]
  
}
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.java_vpc.id
  
}