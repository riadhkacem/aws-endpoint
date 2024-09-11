terraform {

}
provider "aws" {
  region = var.region_name
}
resource "aws_s3_bucket" "backend_bucket" {
  bucket = var.backend_bucket_name
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_public_access_block" "backend_bucket" {
  bucket                  = var.backend_bucket_name
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_server_side_encryption_configuration" "backend_bucket" {
  bucket = var.backend_bucket_name
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_versioning" "backend_bucket" {
  bucket = var.backend_bucket_name
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_dynamodb_table" "locks_table" {
  name = var.locks_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
