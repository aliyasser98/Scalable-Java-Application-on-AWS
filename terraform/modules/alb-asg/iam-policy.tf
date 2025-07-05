resource "aws_iam_role" "java_instance_role" {
    name = "java-instance-role-${var.environment}"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })
    tags = {
        Name = "java-instance-role-${var.environment}"
    }
  
}
resource "aws_iam_policy" "java_instance_policy" {
    name        = "java-instance-policy-${var.environment}"
    description = "Policy for Java instance to access S3 and CloudWatch"
    policy = jsonencode({
  Version = "2012-10-17",
  Statement = [
    {
      Sid = "SSMReadAccess",
      Effect = "Allow",
      Action = [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath"
      ],
      Resource = "*"
    },
    {
      Sid = "SecretsManagerAccess",
      Effect = "Allow",
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecrets" 
      ],
      Resource = "*"
    },
    {
      Sid = "CloudWatchLogs",
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "*"
    }
  ]
})
    tags = {
        Name = "java-instance-policy-${var.environment}"
    }
}
resource "aws_iam_role_policy_attachment" "java_instance_policy_attachment" {
    role       = aws_iam_role.java_instance_role.name
    policy_arn = aws_iam_policy.java_instance_policy.arn
}

resource "aws_iam_instance_profile" "java_instance_profile" {
    name = "java-instance-profile-${var.environment}"
    role = aws_iam_role.java_instance_role.name
    tags = {
        Name = "java-instance-profile-${var.environment}"
    }
}