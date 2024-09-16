This project uses the lambda, dynamoDB, S3 and EventBridge AWS services.
I am creating a lambda function which save a message in the dynamoDB database.
In addition I have implemented an EventBridge event, trigger automatically to save data in the S3 bucket.
I configured Terraform to use S3 bucket as remote backend.