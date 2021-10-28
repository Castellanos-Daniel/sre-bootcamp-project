import jwt
from modules._config import Config
import logging

# Logger settings - CloudWatch
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

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
        logger.info("Attempting to read tocken:" + event['authorizationToken'])
        authorization = event['authorizationToken']
        request_token = authorization.split()[-1]

        logger.info("Got token "+ request_token)

        decoded_token = jwt.decode(
            request_token, config.SIGNATURE, algorithms='HS256')

        logger.info("Token decoded, evaluating to grand access to "+ event['methodArn'])
        if 'role' not in decoded_token:
            return format_policy("user", event['methodArn'], "Deny")

        return format_policy("user", event['methodArn'], "Allow")

    except (AttributeError, jwt.DecodeError):
        logger.error("Error attempting to decode token")
        return format_policy("user", event['methodArn'], "Deny")