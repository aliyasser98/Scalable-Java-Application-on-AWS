
variable "environment" {
  description = "The environment for which the backend is being configured."
  type        = string
    default     = "dev"
}
variable "region" {
  description = "The AWS region where the backend resources will be created."
  type        = string
  default     = "us-east-1"
}