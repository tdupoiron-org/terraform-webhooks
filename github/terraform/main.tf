resource "github_organization_webhook" "webhook" {

  configuration {
    url          = var.webhook_url
    content_type = "form"
    insecure_ssl = false
  }

  active = true

  events = ["workflow_run", "workflow_job"]
}