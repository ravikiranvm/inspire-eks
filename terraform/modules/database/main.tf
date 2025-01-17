resource "aws_dynamodb_table" "quotes" {
    name = "quotes"
    billing_mode = "PAY_PER_REQUEST"

    attribute {
        name = "quoteId"
        type = "S"
    }

    # Primary key
    hash_key = "quoteId"
}

