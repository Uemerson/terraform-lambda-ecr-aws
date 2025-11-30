"""Lambda module handler."""

import json


def lambda_handler(event, context):
    """Lambda function handler."""

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"message": "Hello World"}),
    }
