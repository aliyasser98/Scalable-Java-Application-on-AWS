variable "environment" {
  description = "The environment for the application (e.g., dev, staging, prod)"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to use in the ASG"
  type        = string
}
variable "ami_id" {
  description = "The AMI ID to use for the EC2 instances in the ASG"
  type        = string
}
variable "min_size" {
  description = "The minimum number of EC2 instances in the ASG"
  type        = number
}
variable "max_size" {
  description = "The maximum number of EC2 instances in the ASG"
  type        = number
}
variable "desired_capacity" {
  description = "The desired number of EC2 instances in the ASG"
  type        = number
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access to the EC2 instances"
  type        = string
}
variable "user_data" {
  description = "The user data script to run on instance launch"
  type        = string
  
  
}
variable "region" {
  description = "The AWS region where the resources will be created"
  type        = string
}
variable "db_instance_class" {
  description = "The instance class for the RDS instance"
  type        = string

}
variable "db_allocated_storage" {
  description = "The allocated storage for the RDS instance in GB"  
  type        = number
}
variable "db_name" {
  description = "The name of the database to create"
  type        = string
 
}
variable "db_username" {
  description = "The master username for the RDS instance"
  type        = string
 
}  

variable "db_password" {
  description = "The master password for the RDS instance"
  type        = string
  sensitive   = true
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zones to use for the public subnets"
  type        = list(string)
}
