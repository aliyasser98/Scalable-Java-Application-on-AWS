resource "random_id" "bucket_suffix" {
  byte_length = 4
}
resource "aws_s3_bucket" "tfstate" {
  bucket = "tfstate-lock-${var.environment}-${random_id.bucket_suffix.hex}"

  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
  

  tags = {
    Name        = "Terraform State Bucket"
    Environment = var.environment
  }
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  }
resource "aws_dynamodb_table" "tfstate_lock" {
  name         = "aws_dynamodb-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"


  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Lock Table"
    Environment = var.environment
  }
  
}