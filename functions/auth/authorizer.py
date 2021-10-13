import jwt
from modules._config import Config

config = Config()

def format_policy(principal_id, resource, effect):
    authResponse = {}
    authResponse['principalId'] = principal_id
 
    if effect and resource:
        policyDocument = {
            'Version': '2012-10-17',
            'Statement': [
                {
                    'Sid': 'FirstStatement',
                    'Action': 'execute-api:Invoke',
                    'Effect': effect,
                    'Resource': resource
                }
            ]
        }
 
        authResponse['policyDocument'] = policyDocument

    return authResponse

def verify_token(event, context):

    try:
        authorization = event['authorizationToken']
        request_token = authorization.split()[-1]

        decoded_token = jwt.decode(
            request_token, config.SIGNATURE, algorithms='HS256')

        if 'role' not in decoded_token:
            return format_policy("user", event['methodArn'], "Deny")

        return format_policy("user", event['methodArn'], "Allow")

    except (AttributeError, jwt.DecodeError):
        return format_policy("user", event['methodArn'], "Deny")