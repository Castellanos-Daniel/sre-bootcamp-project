import os
import unittest
from functions.auth.modules.auth_methods import Token

class TestTokenMethods(unittest.TestCase):

    def setUp(self):
        self.convert = Token()
        self.test_token = os.getenv('API_TOKEN')

    def test_generate_token(self):
        self.assertEqual(self.test_token,
                         self.convert.generate_token('admin'))


if __name__ == '__main__':
    unittest.main()
