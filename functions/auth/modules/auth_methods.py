import jwt
from ._config import Config

config = Config()

class Token:
    """ This class is for operations related to JWT tokens"""

    def generate_token(self, role):
        """
        Generates a JWT token.

        Args:
            param1 : user role to be added in the token body.

        Returns:
            JWT signed token
        """
        encoded_token = jwt.encode(
            {"role": role},
            config.SIGNATURE, algorithm='HS256')

        return encoded_token
