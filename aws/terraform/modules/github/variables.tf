variable "aws_region" {
  type = string
}

variable "github_organization" {
  type = string
}

variable "github_webhook_url" {
  type    = string
  default = "https://dummy.com"
}