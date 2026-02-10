# Creating DynammoDB table

resource "aws_dynamodb_table" "url-shortener" {
  name           = "url-shortener"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "short_id"

  attribute {
    name = "short_id"
    type = "S"
  }

  attribute {
    name = "url"
    type = "S"
  }

    point_in_time_recovery {
    enabled = true
  }
}
