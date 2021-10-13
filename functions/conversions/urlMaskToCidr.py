import json
from modules.networking import ConversionMethods

convert = ConversionMethods()

def urlMaskToCidr(event, context):
    """
    url example:
        e.g. http://127.0.0.1:8000/mask-to-cidr?value=255.0.0.0
    Gets mask value from GET request and returns a json response
    with the form:
        { "function": "cidrToMask"
            "input": <value-from-request>
            "output": <calculated-CIDR>
        }
    Requieres authentication token
    """
    try:
        request_parameters = event['multiValueQueryStringParameters']
        mask = request_parameters['value'][0]
    except (TypeError, KeyError) as error:
        # TODO: Create an error handler for this cases
        print("Catched error: ", str(error))
        mask = ""

    return {
        "statusCode": 200,
        "body": json.dumps({
            "function": "maskToCidr",
            "input": mask,
            "output": convert.mask_to_cidr(mask)
        })
    }
