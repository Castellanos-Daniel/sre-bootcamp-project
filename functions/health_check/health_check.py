import json

def event_handler(event, context):

    return {
        "statusCode": 200,
        "body": json.dumps(
            { "status": "ok" }
        )
    }