""" To be run right after provisioning the DB """
import os
import logging
import pymysql
import boto3

# Logger settings - CloudWatch
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

# Required environment variables
db_user = os.environ['db_user']
db_pass = os.environ['db_pass']
db_host = os.environ['db_host']
s3_bucket = os.environ['bucket_name']
s3_filename = os.environ['filename']

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

    setup_lambda_user()

    for statement in body.decode("utf-8").split(';'):
        if len(statement.strip()) < 1:
            continue
        result = run_query(statement.strip())
        logger.info(result)
    return True


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
