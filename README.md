# Terraform Repository Guide

This Terraform repository contains both root and child modules for managing infrastructure as code (IaC).

## Repository Structure

•⁠  ⁠*Root Modules*: A set of reusable Terraform templates that can be used to create infrastructure components.
•⁠  ⁠*Child Modules*: Specific implementations that consume the root modules to define and deploy infrastructure.

## Adding a New Module

To add a new module to the repository:
1.⁠ ⁠Create a new folder inside the ⁠ modules ⁠ directory with the desired module name.
2.⁠ ⁠Ensure the module contains at least the following files:
   - ⁠ main.tf ⁠: Defines the core resources.
   - ⁠ variables.tf ⁠: Specifies the required input variables.
   - ⁠ outputs.tf ⁠: Defines the outputs of the module (if necessary).

## Deploying Infrastructure to a New Environment

To deploy infrastructure for a new environment:

1.⁠ ⁠In the root folder, define the resources to be created by referencing the required root module.
2.⁠ ⁠If additional variables are required, define them in the ⁠ variables.tf ⁠ file.
3.⁠ ⁠In the ⁠ environment/ ⁠ directory:
   - Create a new folder for the new environment.
   - Define the backend configuration in ⁠ backend.conf ⁠.
   - Populate the ⁠ .tfvars ⁠ file with values for the required variables.

### Terraform Commands

Run the following commands to deploy the infrastructure:

⁠ sh
# Initialize Terraform with backend configuration
terraform init --backend-config=environment/dev/backend.conf

# Preview the planned changes
terraform plan --var-file=environment/dev/dev.tfvars

# Apply the changes
terraform apply --var-file=environment/dev/dev.tfvars
 ⁠

## Best Practices
•⁠  ⁠Always use *version control* to track changes.
•⁠  ⁠*Review Terraform plans* before applying changes to avoid unintended modifications.
•⁠  ⁠Use *remote state storage* (e.g., S3, Terraform Cloud) to maintain consistency across deployments.
•⁠  ⁠Ensure that *secrets and sensitive values* are stored securely (e.g., in AWS Secrets Manager or HashiCorp Vault).

For further details, refer to the official [Terraform documentation](https://developer.hashicorp.com/terraform/docs).