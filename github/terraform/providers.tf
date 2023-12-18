terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
  backend "s3" {}
}

provider "github" {
  owner = var.organization
}

provider "aws" {
  region = var.aws_region
}