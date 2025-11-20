########################################
# Provider Configuration
########################################
provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket         = "project1-max-fotios"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-statelock-max-fotios"
  }
}