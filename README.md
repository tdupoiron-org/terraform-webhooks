# terraform-webhooks

```shell
cd aws/terraform
terraform init -backend-config=backend.conf -reconfigure
terraform plan -out tfplan
terraform apply "tfplan"
``````