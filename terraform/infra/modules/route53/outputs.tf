# Output variables to be used in other modules

output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

