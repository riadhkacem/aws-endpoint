output "store_payload_lambda_function_url" {
  value = aws_lambda_function_url.store_payload_lambda_function.function_url
}
output "report_lambda_function_url" {
  value = aws_lambda_function_url.report_lambda_function_url.function_url
}