variable "aws_region" {
  type = string
}

variable "organization" {
  type = string
}

variable "webhook_url" {
  type = string
  default = "https://dummy.com"
}