""" To be run right after provisioning the DB """
import os
import logging
import pymysql
import boto3
from botocore.exceptions import ClientError
import json

# Logger settings - CloudWatch
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

# Required environment variables
s3_bucket = os.environ['s3_bucket']
s3_filename = os.environ['s3_filename']
db_host = os.environ['db_host']
region_name = os.environ['region_name']
secret_name = os.environ['secret_name']
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
    logger.error("Error getting secrets!")
    raise client_error
else:
    secret = json.loads(get_secret_value_response['SecretString'])
db_user = secret['username']
db_pass = secret['password']

# Connect to s3 and get data file
s3 = boto3.resource('s3')
obj = s3.Object(s3_bucket, s3_filename)
body = obj.get()['Body'].read()

# Create connection
db_connection = pymysql.connect(
    host=db_host,
    port=3306,
    user=db_user,
    passwd=db_pass,
    db="bootcamp",
    charset='utf8',
    connect_timeout=5)

logger.debug("SUCCESS: Connection to MySQL database succeeded")


def lambda_handler(event, context):
    """
    Main entry of the AWS Lambda function.
    """
    logger.info("Setting up user...")
    if not user_exists():
        setup_lambda_user()
    else:
        logger.info("The user exists aldeay, skipping step...")

    logger.info("Import to database")
    for statement in body.decode("utf-8").split(';'):
        if len(statement.strip()) < 1:
            continue
        result = run_query(statement.strip())
        logger.info(result)

    return True


def user_exists():

    with db_connection.cursor(pymysql.cursors.DictCursor) as cur:
        try:
            cur.execute(
                'select * from mysql.user where User = "lambda-user";'
            )
            query_result = cur.fetchall()

            if query_result:
                return True
            return False

        except Exception as query_error:
            return False


def setup_lambda_user():
    """ Create user to authenticate with IAM plugin and read DB """
    run_query(
        "CREATE USER 'lambda-user'@'%' IDENTIFIED WITH AWSAuthenticationPlugin as 'RDS';"
    )
    run_query(
        "GRANT SELECT ON bootcamp.* TO 'lambda-user'@'%';"
    )


def run_query(sql_query):
    """
    Execute the query on the MySQL database
    """

    with db_connection.cursor(pymysql.cursors.DictCursor) as cur:
        try:
            items = cur.execute(sql_query)
            db_connection.commit()

            return items

        except Exception as query_error:
            db_connection.rollback()
            raise query_error
