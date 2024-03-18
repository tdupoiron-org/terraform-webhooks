terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.1"
    }
  }
}

provider "github" {
  owner = var.github_organization
}