# Output variables to be used in other modules

output "db-table-name" {
  description = "The DyanamoDB table name"
  value       = aws_dynamodb_table.url-shortener.name
}