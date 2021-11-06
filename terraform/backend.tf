terraform {
    backend "s3" {
        bucket = "sheacloud-terraform-state"
        key = "aws/blog/terraform.tfstate"
        region = "us-east-1"
        profile = "core"
    }
}