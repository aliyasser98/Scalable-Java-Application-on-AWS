terraform {
  backend "s3" {
    bucket= "tfstate-lock-dev-2f09ad72"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws_dynamodb-lock"
    encrypt        = true
    
  }
}