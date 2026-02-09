terraform {
  
  required_version = "~> 1.14.3"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }

     cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 5.15.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      Environment = "dev"
      Project     = "ecs"
      Owner       = "rihad"
      Terraform   = "true"
    }
  }
}
