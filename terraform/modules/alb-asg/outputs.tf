output "dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.java_alb.dns_name
  
}