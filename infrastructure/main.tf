terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket  = "tfstate-bucket-cs302"
    key     = "state.tfstate"
    region  = "us-east-2"
    profile = "default"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}
