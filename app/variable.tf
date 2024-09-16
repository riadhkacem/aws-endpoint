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