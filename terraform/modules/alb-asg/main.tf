resource "aws_security_group" "alb_sg" {
    name        = "java-alb-sg-${var.environment}"
    description = "Security group for Java ALB"
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}
resource "aws_lb" "java_alb" {

    name               = "java-alb-${var.environment}"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb_sg.id]
    subnets            = var.subnet_ids
    
    enable_deletion_protection = false
    
    tags ={
        Name = "java-alb-${var.environment}",
        }

}
resource "aws_lb_listener" "java_alb_listener" {
    load_balancer_arn = aws_lb.java_alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.java_alb_tg.arn
    }
}

resource "aws_lb_target_group" "java_alb_tg" {
    name = "java-alb-tg-${var.environment}"
    port        = 8080
    protocol    = "HTTP"
    vpc_id      = var.vpc_id
    target_type = "instance"
    load_balancing_algorithm_type = "round_robin"

    health_check {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = 8080
        protocol            = "HTTP"
        matcher             = "200"
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }
  
}
resource "aws_security_group" "asg_sg" {
    name        = "java-asg-sg-${var.environment}"
    description = "Security group for Java ASG"
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
}
    tags = {
        Name = "java-asg-sg-${var.environment}"
    }
}
resource "aws_autoscaling_group" "java_asg" {
    name                = "java-asg-${var.environment}"
    vpc_zone_identifier = var.subnet_ids
    min_size            = var.min_size
    max_size            = var.max_size
    desired_capacity    = var.desired_capacity
    target_group_arns   = [aws_lb_target_group.java_alb_tg.arn]
    launch_template {
        id      = aws_launch_template.java_launch_template.id
        version = aws_launch_template.java_launch_template.latest_version
    }
    tag {
        key                 = "Name"
        value               = "java-asg-${var.environment}"
        propagate_at_launch = true
    }
}
resource "aws_launch_template" "java_launch_template" {
    name_prefix   = "java-launch-template-${var.environment}-"
    image_id      = var.ami_id
    instance_type = var.instance_type
    key_name      = var.key_name
    iam_instance_profile {
    name = aws_iam_instance_profile.java_instance_profile.name
    }

    network_interfaces {
        security_groups = [aws_security_group.asg_sg.id]
        associate_public_ip_address = true
    }

    user_data = base64encode(var.user_data)

    lifecycle {
        create_before_destroy = true
    }
    tags = {
        Name = "java-launch-template-${var.environment}"
    }
  
}


  



