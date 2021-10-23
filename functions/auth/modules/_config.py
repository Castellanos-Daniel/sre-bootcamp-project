import boto3
from botocore.exceptions import ClientError
from os import getenv
import json

class Config:
    """
    Data class. Retrieves configuration variables from environment
    """

    def __init__(self):

        secret_name = getenv('DbSecret')
        region_name = getenv('AwsRegion')

        try:
            session = boto3.session.Session()
            client = session.client(
                service_name='secretsmanager',
                region_name=region_name
            )

            get_secret_value_response = client.get_secret_value(
                SecretId=secret_name
            )
        except ClientError as client_error:
            raise client_error
        else:
            secret = json.loads(get_secret_value_response['SecretString'])

        self.SIGNATURE=secret['secretKey']