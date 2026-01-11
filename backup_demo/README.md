# Azure Demo Workspace

This repository demonstrates how to build and deploy a simple web application on Microsoft Azure using Terraform for Infrastructure as Code (IaC).

## Structure

- `infra/`: Contains Terraform configuration files to provision Azure resources.
- `app/`: Contains a sample Python (Flask) web application.

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform](https://www.terraform.io/downloads.html)
- [Docker](https://docs.docker.com/get-docker/) (optional, for local testing)

## getting Started

### 1. Infrastructure Setup

Navigate to the `infra` directory:

```bash
cd infra
```

Login to Azure:

```bash
az login
```

Initialize Terraform:

```bash
terraform init
```

Preview the changes:

```bash
terraform plan
```

Apply the changes to create resources:

```bash
terraform apply
```

### 2. Application Deployment

The Terraform script provisions an Azure App Service. You can deploy the code using various methods (GitHub Actions, Azure CLI, Zip deploy).

For a quick manual deploy using Azure CLI (from the root of the repo):

```bash
az webapp up --sku B1 --name <your-app-name> --resource-group <your-resource-group> --runtime "PYTHON:3.9"
```

*Note: The Terraform config already creates an App Service. You can configure CI/CD to deploy to it.*

## Cleanup

To destroy the created resources:

```bash
cd infra
terraform destroy
```
