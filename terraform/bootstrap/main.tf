# S3 Bucket Creation

resource "aws_s3_bucket" "s3" {
  bucket = "rihad-ecs"
}

resource "aws_s3_bucket_versioning" "rihads3" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_public_access_block" "rihads3" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Hosted Zone Creation

resource "aws_route53_zone" "networking" {
  name = "networking.rihad.co.uk"
 }

output "ns" {
  value = "${aws_route53_zone.networking.name_servers}"
 }

## Linkage Of Route53 Hosted Zone NS' to Cloudflare


data "cloudflare_zone" "domain_zone" {
  zone_id = "415c05da9144abf5a32a57c25dfefe06"
}

 resource "cloudflare_dns_record" "route53-ns" {
  name    = "networking"
  count   = "${length(aws_route53_zone.networking.name_servers)}"
  ttl     = 300
  type    = "NS"
  content   = "${element(aws_route53_zone.networking.name_servers, count.index)}"
  zone_id = data.cloudflare_zone.domain_zone.zone_id
}

# ECR Repo Creation

resource "aws_ecr_repository" "ecs-project" {
  name                 = "ecs-project"
  image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"

  image_tag_mutability_exclusion_filter {
    filter      = "latest*"
    filter_type = "WILDCARD"
  }
}

resource "aws_ecr_lifecycle_policy" "ecs-project" {
  repository = aws_ecr_repository.ecs-project.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Archive images not pulled in 30 days",
      "selection": {
        "tagStatus": "any",
        "countType": "sinceImagePulled",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "transition",
        "targetStorageClass": "archive"
      }
    },
    {
      "rulePriority": 2,
      "description": "Delete images archived for more than 90 days",
      "selection": {
        "tagStatus": "any",
        "storageClass": "archive",
        "countType": "sinceImageTransitioned",
        "countUnit": "days",
        "countNumber": 90
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}