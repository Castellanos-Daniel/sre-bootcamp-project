import json

from modules.auth_methods import Token
from modules.database import Database

token_functions = Token()
database = Database()


def lambda_handler(event, context):

    payload = json.loads(event['body'])
    unauthorized_response = {
            "statusCode": 401,
            "body": json.dumps({
                "message": "unauthorized"
            })
        }

    try:
        user = payload['username']
        password = payload['password']
    except (ValueError, KeyError):
        return unauthorized_response

    is_authorized = database.validate_user_password(user, password)

    if not is_authorized:
        return unauthorized_response

    query_result = database.get_role_by_username('admin')
    token = token_functions.generate_token(query_result)

    return {
        "statusCode": 200,
        "body": json.dumps(
            { "data" : token }
        )
    }