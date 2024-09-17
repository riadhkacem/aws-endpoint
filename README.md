# AWS Endpoint Integration

This project demonstrates the integration of various AWS services, including Lambda, DynamoDB, S3, and EventBridge, to create a serverless application that processes and stores data.

## Features

- **Lambda Function**: A serverless function that receives messages and saves them to a DynamoDB database.
- **DynamoDB Database**: A NoSQL database for storing messages received from the Lambda function.
- **S3 Bucket**: An object storage service that automatically receives data triggered by an EventBridge event.
- **EventBridge Event**: A scheduled event that triggers the automatic saving of data to the S3 bucket.
- **Terraform Configuration**: Infrastructure as Code (IaC) setup using Terraform to manage the AWS resources, including the use of an S3 bucket as a remote backend for storing the Terraform state file.

## Prerequisites

- AWS Account
- Python 3.8 or later
- Terraform installed

## Project Workflow
 - The Lambda function is invoked, either manually or through an event source (e.g., API Gateway, S3 event, etc.).

 - The Lambda function processes the incoming data and saves the message to the DynamoDB database.

 - Separately, an EventBridge event is scheduled to run periodically (e.g., daily, weekly, etc.).

 - When the EventBridge event is triggered, it invokes a Lambda function or another AWS service to save data to the S3 bucket.

 - The Terraform configuration manages the provisioning and maintenance of the AWS resources used in this project, including the Lambda functions, DynamoDB table, S3 bucket, and EventBridge event.

This project demonstrates the integration of multiple AWS services, showcasing serverless computing, data storage, event-driven architectures, and infrastructure as code principles.