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
}

resource "aws_lambda_function_url" "store_payload_lambda_function" {
  authorization_type = "NONE"
  function_name      = aws_lambda_function.store_payload_lambda_function.function_name

}