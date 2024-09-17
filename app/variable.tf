variable "aws_region" {
  type = string
}
variable "store_payload_lambda_function_name" {
  type    = string
  default = "store-payload"
}

variable "dynamodb_table_name" {
  type = string
  default = "dynamodb_table"
}

variable "total_item_count_key_id" {
  type = string
  default = "ITEM_COUNT"
}

variable "report_lambda_function_name" {
  type = string
  default = "generate-report"
}

variable "report_bucket_name" {
  type = string
  default = "aws-endpoint-luckily-jolly-calm-ladybird"
}

variable "report_bucket_exists" {
  type = bool
  default = false
}

variable "report_lambda_function_schedule" {
  default = "rate(5 minutes)"
}