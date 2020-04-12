import boto3
import os
import json

def callback_handler(event, context):
  sqs = boto3.client('sqs')
  queue_url = os.environ['QUEUE_URL']
  body = json.loads(event['body'])
  parsed_body = json.dumps(body)
  response = sqs.send_message(
    QueueUrl=queue_url,
    MessageBody=parsed_body
  )
  return {
    "statusCode": 200,
    "body": parsed_body
  }