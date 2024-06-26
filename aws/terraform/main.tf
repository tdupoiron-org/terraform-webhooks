module "lambda" {
  source = "./modules/lambda"

  aws_owner  = var.aws_owner
  aws_region = var.aws_region

  lambda_package_path = "${path.module}/${var.lambda_package_path}"
  lambda_package_name = var.lambda_package_name
}

module "github" {
  source = "./modules/github"

  aws_region = var.aws_region

  github_organization = var.github_organization
  github_webhook_url  = format("%s/%s/events", module.lambda.api_gateway_endpoint, module.lambda.api_gateway_stage_name)
}

# module "elastic" {
#   source = "./modules/elastic"

#   aws_owner             = var.aws_owner
#   aws_region            = var.aws_region
#   aws_availability_zone = var.aws_availability_zone

# }