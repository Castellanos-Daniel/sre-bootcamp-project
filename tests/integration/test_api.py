import os
import unittest
import json
import requests
from schema import Schema, And, Use

"""
This module runs to test the dev stage api 
"""


class TestDevelopmentAPI(unittest.TestCase):

    """
        Main test case, requires the below environment variables to run:

            API_URL: Current API endpoint to test.
            TEST_TOKEN: Valid jwt token to test authentication.
            VALID_USER: Valid db user to test login function.
            VALID_PASS: Valid pass that matches user above.
            NO_ROLE_TOKEN: token without expected content.
    """

    def setUp(self):

        self.api_url = os.environ['API_URL']
        token = os.environ['TEST_TOKEN']

        self.headers = {'Authorization':
                        f'Bearer JWT  {token}'}

        self.success_schema = Schema(And(Use(json.loads), {
            "function": str,
            "input": str,
            "output": str
        }))

        self.error_schema = Schema(And(Use(json.loads), {
            lambda s: s in ('message', 'Message'): str,
        }))

        self.login_schema = Schema(And(Use(json.loads), {
            "data": str,
        }))

        self.test_values = [
            ('8', '255.0.0.0'),
            ('16', '255.255.0.0'),
            ('20', '255.255.240.0'),
            ('32', '255.255.255.255')
        ]

    def test_health_check_urls(self):
        self.assertEqual(
            requests.get(self.api_url+'/_health').status_code, 200)
        self.assertEqual(
            requests.get(self.api_url+'/').status_code, 200)

    def is_valid_schema(self, test_string):
        if 'function' in test_string:
            return self.success_schema.validate(test_string)
        elif 'message' in test_string or 'Message' in test_string:
            return self.error_schema.validate(test_string)
        elif 'data' in test_string:
            return self.login_schema.validate(test_string)

    def make_assertions(self, path, input_value, expected_response):
        """
        Use the input value to make the request to a url, and validates
        against the expected result.

        Args:
            param1(`str`): url to make the request
            param2(`str`): input value to send,
            param3(`str`): expected output from the request

        Returns:
            None
        """
        json_response = requests.get(f'{self.api_url + path}?value={input_value}',
                                     headers=self.headers)
        decoded_response = json_response.content.decode()
        parsed_response = json.loads(decoded_response)

        self.assertTrue(self.is_valid_schema(decoded_response))
        self.assertEqual(
            parsed_response['output'], expected_response
        )

    def test_login(self):

        credentials = {
            'username': os.environ['VALID_USER'],
            'password': os.environ['VALID_PASSWORD']
        }

        json_response = requests.post(
            self.api_url + '/login',
            json={
                "username": os.environ['VALID_USER'],
                "password": os.environ['VALID_PASSWORD']
            })

        print(json_response.request.headers)

        self.assertEqual(json_response.status_code, 200)
        self.assertTrue(
            self.is_valid_schema(json_response.content.decode()))

    def test_failed_login(self):

        missing_credentials_request = requests.post(self.api_url+'/login')
        self.assertEqual(missing_credentials_request.status_code, 502)
        print(missing_credentials_request.text)
        self.assertTrue(
            self.is_valid_schema(
                missing_credentials_request.content.decode()
            )
        )

        wrong_password_request = \
            requests.post(self.api_url + '/login',
                          json={
                              'username': os.environ['VALID_USER'],
                              'password': "fake_pass"
                          })
        self.assertTrue(
            self.is_valid_schema(wrong_password_request.content.decode()))

    def assert_failed_access(self, json_response):

        self.assertEqual(
            json_response.status_code, 403
        )
        print(json_response.content.decode())
        self.assertTrue(
            self.is_valid_schema(json_response.content.decode()))

    def test_cidr_to_mask(self):

        for (cidr, mask) in self.test_values:
            self.make_assertions('/cidr-to-mask', cidr, mask)

    def test_mask_to_cidr(self):

        for (cidr, mask) in self.test_values:
            self.make_assertions('/mask-to-cidr', mask, cidr)

    def test_failed_access_request(self):

        for url in '/cidr-to-mask', '/mask-to-cidr':
            json_response = requests.get(
                self.api_url + url)
            self.assertEqual(
                json_response.status_code, 401
            )
            print(json_response.content.decode())
            self.assertTrue(
                self.is_valid_schema(json_response.content.decode()))

    def test_requiere_token_no_role(self):

        invalid_token = os.environ['NO_ROLE_TOKEN']
        headers = {'Authorization':
                   f'Bearer JWT  {invalid_token}'}

        for url, input_value in ('/cidr-to-mask', '8'), ('/mask-to-cidr', '255.0.0.0'):
            json_response = requests.get(f'{self.api_url+url}?value={input_value}',
                                         headers=headers)

            self.assert_failed_access(json_response)
