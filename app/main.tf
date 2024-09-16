terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.6.0"
    }
  }
  /*  backend "s3" {
  }*/
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "managed_by_terraform" = true
    }
  }
}

data "archive_file" "store_payload_lambda_function" {
  type        = "zip"
  source_file = "./src/store_payload_lambda_function/app.py"
  output_path = "./out/store_payload_lambda_function.zip"
}

resource "aws_iam_role" "store_payload_lambda_function_role" {
  name = "${var.store_payload_lambda_function_name}_lambda_function_role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
    }
  )
}

resource "aws_lambda_function" "store_payload_lambda_function" {
  filename         = "./out/store_payload_lambda_function.zip"
  function_name    = var.store_payload_lambda_function_name
  role             = aws_iam_role.store_payload_lambda_function_role.arn
  handler          = "app.lambda_handler"
  runtime          = "python3.9"
  timeout          = 30
  source_code_hash = data.archive_file.store_payload_lambda_function.output_base64sha256
  environment {
    variables = {
      "DYNAMODB_TABLE_NAME"     = var.dynamodb_table_name
      "TOTAL_ITEM_COUNT_KEY_ID" = var.total_item_count_key_id
    }
  }
}

resource "aws_lambda_function_url" "store_payload_lambda_function" {
  authorization_type = "NONE"
  function_name      = aws_lambda_function.store_payload_lambda_function.function_name

}

resource "aws_iam_role_policy_attachment" "store_playload_function" {
  role       = aws_iam_role.store_payload_lambda_function_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "store_payload_lambda_function" {
  name              = "/aws/lambda/${var.store_payload_lambda_function_name}"
  retention_in_days = 14
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "item_count" {
  table_name = aws_dynamodb_table.dynamodb_table.name
  hash_key   = aws_dynamodb_table.dynamodb_table.hash_key

  item = <<ITEM
{
  "id": {"S": "${var.total_item_count_key_id}"},
  "value": {"N": "0"}
}
ITEM
  lifecycle {
    ignore_changes = [item]
  }
}

resource "aws_iam_role_policy" "store_payload_lambda_funtion_dynamodb_role_policy" {
  name = "store_payload_lambda_funtion_dynamodb_role_policy"
  role = aws_iam_role.store_payload_lambda_function_role.id

  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Effect" = "Allow",
          "Action" = [
            "dynamodb:PutItem",
            "dynamodb:UpdateItem"
          ],
          "Resource" = [
            aws_dynamodb_table.dynamodb_table.arn
          ]
        }
      ]
    }
  )
}

