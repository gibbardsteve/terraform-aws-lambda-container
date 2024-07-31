# terraform-aws-lambda-container

Simple terraform configuration for deploying a containerised lambda function.  

The architecture is set to arm64 by default, if you are building for a differnt platform this must match your image architecture.

The default configuration deploys the following:

**Lambda Function** - a lambda function, deployed from a specified image and version and built to a specified architecure.  The example lambda lists the s3 buckets in the associated account.

**Cloudwatch Log Group** - a log group to catch logging from the lambda function.

**Eventbridge** - a scheduled event to trigger the lambda function.

## Prerequisites

This project uses poetry for package management, colima a license free tool for containerisation, the AWS cli commands for interacting with cloud services and Terraform for deploying changes.

It is expected you have these tools installed before progressing further.

[Instructions to install Poetry](https://python-poetry.org/docs/)

[Instructions to install Colima](https://github.com/abiosoft/colima/blob/main/README.md)

[Instructions to install AWS cli tool](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[Terraform to configure AWS](https://developer.hashicorp.com/terraform/install)

See the section on deployment for specific requirements and prerequisites to deploy to AWS.

## Run locally

### Build the container

```bash
docker build -t lambda-function . 
```

### Run the container

Replace the placeholders with the values for your AWS account.

```bash
docker run -p 9000:8080 \
  -e AWS_ACCESS_KEY_ID=XAWSACCESSKEYIDX \
  -e AWS_SECRET_ACCESS_KEY=XAWSSECRETACCESSKEYX \
  -e AWS_DEFAULT_REGION=xx-region-x \
  -e ENVIRONMENT=dev \
  lambda-function
```

### Trigger the local container

```bash
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
```

### Stop the container

List the running containers

```bash
docker ps
CONTAINER ID   IMAGE                COMMAND                  CREATED          STATUS          PORTS                                       NAMES
601d47f4f256   lambda-function   "/lambda-entrypoint.…"   18 seconds ago   Up 18 seconds   0.0.0.0:9000->8080/tcp, :::9000->8080/tcp   competent_robinson
```

Stop the container

```bash
docker stop <container_id || name>
```

## Deploy to AWS

### Deloyment Prerequisites

- A terraform user is created in your AWS account with the necessarry permissions to deploy the lambda and interact with ECR.

- An ECR user is created in your AWS account with the necessarry permissions (EC2ContainerRegisteryFullAccess) to push a container image to the ECR repository.

- An ECR repository is created following the naming convention **env**-**lambda_name** in the AWS console.

### Testing in AWS

The lambda can be triggered using the AWS CLI:

```bash
aws lambda invoke --function-name lambda-function --payload '{}' response.json
```

Output is written to response.json

## Trivy for Terraform Scanning

Install trivy and use the following command to verify the terraform:

```bash
cd $PROJECT_ROOT

trivy config --config trivy-config.yml terraform

2024/07/31 13:55:01 INFO Loaded file_path=trivy-config.yml
2024-07-31T13:55:01+01:00       INFO    Misconfiguration scanning is enabled
2024-07-31T13:55:01+01:00       INFO    Detected config files   num=3

data.tf (terraform)

Tests: 5 (SUCCESSES: 0, FAILURES: 0, EXCEPTIONS: 5)
Failures: 0 (MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```

Exceptions can be highlighted:

- inline (e.g in data.tf #trivy:ignore:AVD-AWS-0057)
- project scope (e.g in trivy-config.yml)
