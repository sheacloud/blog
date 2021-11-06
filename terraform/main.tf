terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

data "aws_region" "primary" {}
data "aws_region" "secondary" {
  provider = aws.secondary
}

provider "aws" {
    region = "us-east-1"
    profile = terraform.workspace == "dev" ? "dev" : "prod"
}

provider "aws" {
    region = "us-west-2"
    alias = "secondary"
    profile = terraform.workspace == "dev" ? "dev" : "prod"
}

provider "aws" {
    region = "us-east-1"
    alias = "dns"
    profile = terraform.workspace == "dev" ? "dev" : "core"
}