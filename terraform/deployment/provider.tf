terraform {

  required_version = "~> 1.14.3"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }
  }
  
  backend "s3" {
  bucket = "rihads3"
  key = "terraform.tfstate"
  region = "eu-west-2"
  use_lockfile = true
  encrypt = true
 }
}

provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = var.aws_tags
  }
}
