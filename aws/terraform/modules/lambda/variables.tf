variable "aws_owner" {
  description = "The owner of the infrastructure"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "lambda_package_path" {
  description = "The path to the package"
  type        = string
}

variable "lambda_package_name" {
  description = "The name of the package"
  type        = string
}