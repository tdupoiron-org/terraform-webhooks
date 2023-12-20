variable "aws_owner" {
  description = "The owner of the infrastructure"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "aws_availability_zone" {
  description = "The AWS availability zone to deploy resources in"
  type        = string
}

variable "aws_elastic_ami" {
  description = "The AWS AMI to use for the elastic instance"
  type        = string
  default     = "ami-0a74f2a50a208a8a8"
}

variable "aws_elastic_instance_type" {
  description = "The AWS instance type to use for the elastic instance"
  type        = string
  default     = "t2.xlarge"
}

variable "aws_elastic_master_username" {
  description = "The AWS master username to use for the elastic instance"
  type        = string
  default     = "admin"
}

variable "aws_elastic_master_password" {
  description = "The AWS master password to use for the elastic instance"
  type        = string
  default     = "changeme"
}