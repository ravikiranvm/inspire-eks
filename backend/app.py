from flask import Flask, jsonify
from flask_cors import CORS
import boto3, random

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

#Adding the dynamodb client
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table = dynamodb.Table('quotes')

@app.route('/quote', methods=['GET'])
def get_quote():

    # Get a random quote id from 1..5
    random_id = str(random.randint(1, 5))

    # Retrive the quote from the table
    response = table.get_item(Key={'quoteId' : random_id})
    
    if 'Item' in response:
        quote = response['Item']
        return jsonify({'quote': quote['quote'], 'author': quote['author']})
    else:
        return jsonify({'error': 'Quote not found'}), 404
    
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)