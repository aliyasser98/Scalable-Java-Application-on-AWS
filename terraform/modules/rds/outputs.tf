output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.java_db_instance.endpoint
  
}
output "rds_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.java_db_instance.address
}

output "master_user_secret" {
  description = "The master user secret of the RDS instance"
  value       = aws_db_instance.java_db_instance.master_user_secret
}