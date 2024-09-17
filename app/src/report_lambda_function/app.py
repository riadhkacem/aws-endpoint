import logging
import boto3
import os
from datetime import datetime, timezone

logger = logging.getLogger()
logger.setLevel(logging.INFO)

REPORT_OBJECT_KEY_FORMAT = '%Y%m%d%H%M%S%f.txt'

def lambda_handler(event, context):
    logger.info("Event : %s", event)
    logger.info("Context : %s", context)

    table_name = os.environ['DYNAMODB_TABLE_NAME']
    if table_name is None:
        logger.error("DYNAMODB_TABLE_NAME environment variable should be set")
        return 
    total_item_count_key = os.environ['TOTAL_ITEM_COUNT_KEY_ID']
    if total_item_count_key is None:
        logger.error("Total item count key id should be configured as environment variable")
        return 
    s3_bucket_name = os.environ['S3_BUCKET_NAME']
    if s3_bucket_name is None:
        logger.error("S3 bucket name should be configured as environment variable")
        return 
    
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)
    response = table.get_item(Key={'id': total_item_count_key})
    if response is None:
        logger.error("Total item count should be saved in the database")
        return 
    item = response['Item']
    item_count = item['value']
    s3 = boto3.resource('s3')
    body = str(item_count)
    report_object_key = datetime.strftime(datetime.now(timezone.utc), REPORT_OBJECT_KEY_FORMAT)

    s3.Object(s3_bucket_name, report_object_key).put(Body=body)
    logger.info("Report saved to s3://%s/%s", s3_bucket_name, report_object_key)