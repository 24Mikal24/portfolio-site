import json
import logging
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info('Event values: %s', event)
    client = boto3.client("ses")
    data = json.loads(event.get('body'))
    name = data['name']
    email = data['email']
    subject = data['subject']
    message = data['message']
    logger.info('Request Parameters: %s, %s, %s, %s', name, email, subject, message)
    body = {"Subject": {"Data": subject}, "Body": {"Text": {"Data": "Name: " + name + "\nEmail: " + email + "\nMessage: " + message}}}
    res = client.send_email(Source = "mikearcherdevsiteemails@gmail.com", Destination = {"ToAddresses": ["mikearcherdevsiteemails@gmail.com"]}, Message = body)
    logger.info('Response: %s', res)
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type" : "application/json",
            "Access-Control-Allow-Origin" : "*",
            "Allow" : "GET, OPTIONS, POST",
            "Access-Control-Allow-Methods" : "GET, OPTIONS, POST",
            "Access-Control-Allow-Headers" : "*"
        },
        "body": "Sent"
    }