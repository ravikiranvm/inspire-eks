import boto3
import json
from botocore.exceptions import ClientError

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

# Define the table name
table_name = 'quotes'  # Change this to your actual table name

# Reference to the DynamoDB table
table = dynamodb.Table(table_name)

# Function to load quotes from a JSON file
def load_quotes_from_json(file_path):
    with open(file_path, 'r') as file:
        return json.load(file)

# Function to add quotes to DynamoDB
def add_quotes_to_dynamodb(quotes):
    for i, quote in enumerate(quotes, start=1):  # Add an ID to each quote
        try:
            response = table.put_item(
                Item={
                    'quoteId': quote['id'],
                    'author': quote['author'],
                    'quote': quote['quote']
                }
            )
            print(f"Quote {i} added successfully: {quote['quote']}")
        except ClientError as e:
            print(f"Error adding quote {i}: {e.response['Error']['Message']}")

# Path to the JSON file containing the quotes
json_file_path = 'quotes-data.json'  # Replace with the path to your JSON file

# Load quotes from the JSON file
quotes = load_quotes_from_json(json_file_path)

# Call the function to add quotes to DynamoDB
add_quotes_to_dynamodb(quotes)
