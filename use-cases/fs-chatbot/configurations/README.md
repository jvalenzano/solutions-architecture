# Forest Service Chatbot Configurations

This directory contains all configuration files for the Forest Service Chatbot GCP infrastructure.

## Directory Structure

- 	erraform/: Infrastructure as Code configurations
- cloudbuild/: Cloud Build pipeline configurations
- dialogflow/: DialogFlow CX configurations
- unctions/: Cloud Functions configurations
- monitoring/: Monitoring and alerting configurations

## Usage

1. Configure required variables in terraform.tfvars
2. Initialize Terraform: 	erraform init
3. Plan deployment: 	erraform plan
4. Apply configuration: 	erraform apply

## Configuration Management

- All changes should go through PR review
- Use terraform fmt to format files
- Run terraform validate before commits
- Update documentation when adding new resources
