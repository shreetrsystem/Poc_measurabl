import json
import logging
from typing import Any, Dict

# Configure structured logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Simple Hello World Lambda handler with basic logging.
    """
    logger.info("Received event: %s", json.dumps(event))
    
    response = {
        "statusCode": 200,
        "body": json.dumps({"message": "Hello World"}),
        "headers": {
            "Content-Type": "application/json",
            "X-Content-Type-Options": "nosniff"
        }
    }
    
    logger.info("Sending response: %s", json.dumps(response))
    return response
