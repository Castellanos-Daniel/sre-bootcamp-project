import json

from modules.auth_methods import Token
from modules.database import Database

token_functions = Token()
database = Database()


def lambda_handler(event, context):

    payload = json.loads(event['body'])

    try:
        user = payload['username']
        password = payload['password']
    except (ValueError, KeyError):
        # TODO: Handle this error, investigate how to return unauthorized
        return json.dumps({
            "errorType": "Unauthorized",
            "statusCode": 401
        })

    is_authorized = database.validate_user_password(user, password)

    if not is_authorized:
        # TODO: Add method to respond unauthorized
        return json.dumps({
            "errorType": "Unauthorized",
            "statusCode": 401
        })

    query_result = database.get_role_by_username('admin')
    token = token_functions.generate_token(query_result)

    return {
        "statusCode": 200,
        "body": json.dumps(
            { "data" : token }
        )
    }