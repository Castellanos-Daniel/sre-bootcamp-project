import json
from modules.networking import ConversionMethods

convert = ConversionMethods()

def urlCidrToMask(event, context):
    """
    url example:
         e.g. http://127.0.0.1:8000/cidr-to-mask?value=8
    Gets CIDR value from GET request and returns a json response
    with the form:
         { "function": "cidrToMask"
              "input": <value-from-request>
              "output": <calculated-mask>
         }
    Requieres authentication token
    """

    try:
        request_parameters = event['multiValueQueryStringParameters']
        cidr = request_parameters['value'][0]
    except (TypeError, KeyError) as error:
        print("Catched this error: ", str(error))
        cidr = ""

    return {
        "statusCode": 200,
        "body": json.dumps(
           {
               "function": "cidrToMask",
               "input": cidr,
               "output": convert.cidr_to_mask(cidr)
           }
        )
    }
