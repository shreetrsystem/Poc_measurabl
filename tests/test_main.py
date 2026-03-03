import json
from app.main import handler

def test_handler():
    event = {"key": "value"}
    context = {}
    
    response = handler(event, context)
    
    assert response["statusCode"] == 200
    assert response["headers"]["Content-Type"] == "application/json"
    
    body = json.loads(response["body"])
    assert body["message"] == "Hello World"
