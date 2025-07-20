#!/usr/bin/env bash

# Set Subscription ID
export ARM_SUBSCRIPTION_ID=""

# Set Application Name / Environment
export TF_VAR_application_name="observability"
export TF_VAR_environment_name="prod"

# Set Backend
export BACKEND_RESOURCE_GROUP="rg-terraform-state-prod"
export BACKEND_STORAGE_ACCOUNT="st9tfzyxt91e"
export BACKEND_STORAGE_CONTAINER="tfstate"
export BACKEND_KEY=${TF_VAR_application_name}-${TF_VAR_environment_name}

# Run Terraform
terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_STORAGE_CONTAINER}" \
    -backend-config="key=${BACKEND_KEY}" 

terraform $*

# Clean up local .terraform directory
rm -rf .terraform/

exit 0