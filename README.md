# AWS Serverless Data Processing Application

## Project Overview

This project demonstrates a serverless application architecture using various AWS services to process and store data efficiently. The application leverages AWS Lambda, DynamoDB, S3, and EventBridge to create a scalable and event-driven system.

## Architecture

The application consists of two main components:

1. Data Ingestion Lambda Function
2. Data Aggregation Lambda Function

### Component Details

#### 1. Data Ingestion Lambda Function
- Receives payload data
- Stores the received data in a DynamoDB table

#### 2. Data Aggregation Lambda Function
- Triggered by EventBridge on a schedule
- Reads the item count from the DynamoDB table
- Stores the count data in an S3 bucket

## Infrastructure as Code

This project uses Terraform to manage and provision the AWS infrastructure. The Terraform state is stored remotely using:
- S3 backend for state storage
- DynamoDB for state locking

## Continuous Integration and Deployment

GitHub Actions workflows are implemented to automate the deployment process:
1. Deploy the Terraform S3 backend with DynamoDB
2. Deploy the application infrastructure and code to AWS

## Getting Started

To test the application, use the command curl -i -X POST -d "{'key1':'value1'}" <store_payload_lambda_function_url>

## Configuration

You need to configure the variables and secrets of the env block in the yml files of github workflows.
