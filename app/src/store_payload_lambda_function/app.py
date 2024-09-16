import logging

from http import HTTPStatus
import os
import boto3
import uuid
import time

HTTP_METHOD = "POST"
HTTP_PATH = "/"

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def status_code(status_code):
    return {
        "statusCode": status_code,
    }


def bad_request():
    return status_code(HTTPStatus.BAD_REQUEST)


def not_found():
    return status_code(HTTPStatus.NOT_FOUND)


def internal_server_error():
    return status_code(HTTPStatus.INTERNAL_SERVER_ERROR)


def ok():
    return status_code(HTTPStatus.OK)


def lambda_handler(event, context):
    logger.info("Event: %s", event)
    logger.info("Context: %s", context)

    requestContext = event["requestContext"]
    if requestContext is None:
        logger.error("Request context is null")
        return internal_server_error()
    http = requestContext["http"]
    if http is None:
        logger.error("Request context http is null")
        return internal_server_error()
    method = http["method"]
    path = http["path"]
    if method != HTTP_METHOD or path != HTTP_PATH:
        logger.warning("Handler support only %s %s requests", HTTP_METHOD, HTTP_PATH)
        return not_found()
    body = event["body"]
    if body is None:
        return bad_request()
    table_name = os.environ["DYNAMODB_TABLE_NAME"]
    if table_name is None:
        logger.error("Table name should be configured as environment variable")
        return internal_server_error()
    total_item_count_key = os.environ["TOTAL_ITEM_COUNT_KEY_ID"]
    if total_item_count_key is None:
        logger.error(
            "Total item count key id should be configured as environment variable"
        )
        return internal_server_error()
    dynamodb = boto3.client("dynamodb")
    payload_id = f"PAYLOAD-{str(uuid.uuid4()).upper()}"
    created_at = str(time.time())
    dynamodb.transact_write_items(
        TransactItems=[
            {
                "Put": {
                    "TableName": table_name,
                    "Item": {
                        "id": {"S": payload_id},
                        "created_at": {"S": created_at},
                        "payload": {"S": body},
                    },
                }
            },
            {
                "Update": {
                    "TableName": table_name,
                    "Key": {
                        "id": {"S": total_item_count_key},
                    },
                    "UpdateExpression": "SET #value = #value + :incr",
                    "ExpressionAttributeNames": {
                        "#value": "value",
                    },
                    "ExpressionAttributeValues": {
                        ":incr": {"N": "1"},
                    },
                }
            },
        ]
    )
    logger.info("Payload %s created", payload_id)
    return ok()


"""
    try:
        return ok()
    except Exception as e:
        logger.error(e)
        return internal_server_error()
"""
