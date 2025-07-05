variable "environment" {
  description = "The environment for the application (e.g., dev, staging, prod)"
  type        = string
}
variable "vpc_id" {
  description = "The VPC ID where the ALB and ASG will be created"
  type        = string
}
variable "subnet_ids" {
  description = "The list of subnet IDs where the ALB and ASG will be created"
  type        = list(string)
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

