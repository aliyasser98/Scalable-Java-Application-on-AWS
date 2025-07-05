variable "environment" {
  description = "The environment for the RDS instance (e.g., dev, staging, prod)"
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
  description = "The username for the RDS instance"
  type        = string
  
}
variable "db_password" {
  description = "The password for the RDS instance"
  type        = string
  sensitive   = true
}
variable "subnet_ids" {
  description = "List of subnet IDs for the RDS instance"
  type        = list(string)
}
variable "vpc_id" {
  description = "The ID of the VPC where the RDS instance will be created"
  type        = string
}