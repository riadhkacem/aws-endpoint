output "backend_bucket_id" {
  value = aws_s3_bucket.backend_bucket.id
}
output "backend_bucket_name" {
  value = aws_s3_bucket.backend_bucket.bucket
}
output "backend_bucket_arn" {
  value = aws_s3_bucket.backend_bucket.arn
}

output "backend_bucket_region" {
  value = aws_s3_bucket.backend_bucket.region
}
output "aws_dynamodb_table_id" {
  value = aws_dynamodb_table.locks_table.id
}
output "aws_dynamodb_table_name" {
  value = aws_dynamodb_table.locks_table.name
}
output "aws_dynamodb_table_arn" {
  value = aws_dynamodb_table.locks_table.arn
}
