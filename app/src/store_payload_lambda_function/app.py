import logging

from http import HTTPStatus

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
    print("##Event")
    print(event)
    print("##Context")
    print(context)
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
        logger.warning('Handler support only %s %s requests', HTTP_METHOD, HTTP_PATH)
        return not_found()
    body = event["body"]
    if body is None:
        return bad_request()
    if event["httpMethod"] != HTTP_METHOD:
        return bad_request()

    if event["path"] != HTTP_PATH:
        return not_found()
    return ok()
"""
    try:
        return ok()
    except Exception as e:
        logger.error(e)
        return internal_server_error()
"""