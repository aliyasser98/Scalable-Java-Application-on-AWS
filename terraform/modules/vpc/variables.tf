variable "environment" {
  description = "The environment for the VPC (e.g., dev, staging, prod)"
  type        = string
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}
variable "availability_zones" {
  description = "List of availability zones for the public subnets"
  type        = list(string)
  
}
