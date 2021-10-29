import os
import sys
import hashlib
import pymysql
import logging
import boto3
from botocore.exceptions import ClientError


class Database():

    def __init__(self):
        
        logger = logging.getLogger()
        logger.setLevel(logging.DEBUG)

        if os.environ['ENVIRONMENT'] == "test":
            try: 
                self.db_connection = pymysql.connect(
                    host=os.environ['DB_HOST'],
                    port=3306,
                    user=os.environ['DB_USER'],
                    passwd=os.environ['DB_PASS'],
                    db=os.environ['DB_NAME'],
                    connect_timeout=5
                )
            except pymysql.MySQLError as connection_error:
                logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
                logger.error(str(connection_error))
                sys.exit()
        else:

            try: 
                rds_client = boto3.client('rds')
                auth_token = rds_client.generate_db_auth_token( 
                    os.environ['DB_HOST'], 3306, os.environ['DB_USER'] )

            except ClientError as client_error:
                logger.error("BOTO Client FAILED:")
                logger.error(str(client_error))
                sys.exit()

            ssl_certificate = {'ca': '/opt/python/us-east-2-bundle.pem'}

            try: 
                self.db_connection = pymysql.connect(
                    host=os.environ['DB_HOST'],
                    port=3306,
                    user=os.environ['DB_USER'],
                    passwd=auth_token,
                    ssl=ssl_certificate,
                    db=os.environ['DB_NAME'],
                    connect_timeout=5
                )
            except pymysql.MySQLError as connection_error:
                logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
                logger.error(str(connection_error))
                sys.exit()
            
        logger.info("SUCCESS: Connection to RDS MySQL instance succeeded")
        self.cursor = self.db_connection.cursor()

    def get_user_by_name(self, username):
        """
        Query configured database for user info.

        Args:
            param1 (`str`): the username to match in the query

        Returns:
            `tuple`: salt value, password and role of the user
        """
        self.cursor.execute(
            f"SELECT salt, password, role \
                FROM users WHERE username ='{username}';")

        return self.cursor.fetchall()

    def validate_user_password(self, username, password_from_request):
        """
        Validate user password

        Args:
            param1 (`str`): User to test password
            param2 (`str`): password to validate

        Returns:
            `bool`: True if password is valid, False otherwise
        """
        user_info = self.get_user_by_name(username)
        if user_info:
            salt = user_info[0][0]
            user_password_from_db = user_info[0][1]
            hashed_password = hashlib.sha512(
                (password_from_request+salt).encode()).hexdigest()

            return hashed_password == user_password_from_db
        return False

    def get_role_by_username(self, username):
        """
        Get role of an specific user

        Args:
            param1 (`str`): user to match the query

        Returns:
            `str`: Role name of the matched user

        """
        user_info = self.get_user_by_name(username)

        if user_info:
            return user_info[0][2]
        return False

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.cursor.close()
        self.db_connection.close()
