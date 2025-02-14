terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "mike-archer-tfstate-bucket"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}