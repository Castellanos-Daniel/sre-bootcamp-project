import os
from unittest import TestCase

import boto3
from botocore.exceptions import ClientError
import requests

"""
Make sure env variable AWS_SAM_STACK_NAME exists with the name of the stack we are going to test. 
"""


class TestApiGateway(TestCase):
    api_endpoint: str

    @classmethod
    def get_stack_name(cls) -> str:
        stack_name = os.environ.get("AWS_SAM_STACK_NAME")
        if not stack_name:
            raise Exception(
                "Cannot find env var AWS_SAM_STACK_NAME. \n"
                "Please setup this environment variable with the stack name \
                    where we are running integration tests."
            )

        return stack_name

    def setUp(self) -> None:
        """
        Based on the provided env variable AWS_SAM_STACK_NAME,
        here we use cloudformation API to find out
        what the CapstoneProjectApi URL is
        """
        stack_name = TestApiGateway.get_stack_name()

        client = boto3.client("cloudformation")

        try:
            response = client.describe_stacks(StackName=stack_name)
        except ClientError as error:
            raise Exception(
                f"Cannot find stack {stack_name}. \n" \
                f'Please make sure stack with the name "{stack_name}" exists.'
            ) from error

        stacks = response["Stacks"]

        stack_outputs = stacks[0]["Outputs"]
        api_outputs = [ output 
            for output in stack_outputs 
                if output["OutputKey"] == "CapstoneProjectApi" ]

        self.assertTrue(
            api_outputs, f"Cannot find output CapstoneProjectApi in stack {stack_name}")

        self.api_endpoint = api_outputs[0]["OutputValue"]

    def test_api_gateway(self):
        """
        Call the API Gateway endpoint and check the response
        """

        for url in [f"{self.api_endpoint}/", f"{self.api_endpoint}/_health"]:
            
            response = requests.get(url)
            self.assertDictEqual(response.json(), {"status": "ok"})

    def test_authentication(self):
        """
        Based on the provided env variable API_TOKEN,
        call a protected url and evaluate the response.
        """

        protected_url = f"{self.api_endpoint}/cidr-to-mask?value=8"
        token = os.getenv('API_TOKEN')

        if not token:
            raise Exception(
                "API_TOKEN variable is not defined, can`t test authentication"
            )

        headers = {'Authorization':
                   f'Bearer JWT  {token}'}

        response = requests.get(protected_url, headers=headers)
        self.assertEqual(response.status_code, 200)