import boto3
from datetime import datetime
import logging
import os

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    s3 = boto3.client('s3')
    response = s3.list_buckets()

    # Get the environment variable
    environment = os.getenv('ENVIRONMENT', 'env_not_set')

    logger.info(f"Lambda function starting in {environment}")

    # Convert datetime objects to ISO 8601 formatted strings
    for bucket in response.get('Buckets', []):
        if 'CreationDate' in bucket:
            bucket['CreationDate'] = bucket['CreationDate'].isoformat()
    
    return {
        'statusCode': 200,
        'body': response
    }