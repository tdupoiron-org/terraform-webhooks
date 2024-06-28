# terraform-webhooks

1. Add the GITHUB_TOKEN environment variable with the org permissions to create a webhook.

2. Build lambda code

```shell
cd aws/lambda
npm ci
npm run build
npm run zip
```

3. Deploy the lambda code

```shell
cd aws/terraform
terraform init -backend-config=backend.conf -reconfigure
terraform plan -out tfplan
terraform apply "tfplan"
``````