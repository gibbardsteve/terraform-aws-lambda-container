variable "env_name" {
  description = "AWS environment"
  type        = string
  default     = "sg-dev"
}

variable "lambda_name" {
  description = "AWS Lambda Function Name"
  type        = string
  default     = "lambda-function"
}

variable "lambda_version" {
  description = "AWS Lambda Image Version"
  type        = string
  default     = "v0.0.1"
}

variable "lambda_arch" {
  description = "AWS Lambda Architecture"
  type        = string
  default     = "arm64"
}

variable "schedule" {
  description = "The schedule to trigger the lambda, rate(value minutes|hours|days) or cron(minutes hours day-of-month month day-of-week year)"
  type        = string
  default     = "rate(5 minutes)"
}

variable "log_retention_days" {
  description = "Lambda log retention in days"
  type        = number
  default     = 7
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "project_tag" {
  description = "Project"
  type        = string
  default     = "SDP"
}

variable "team_owner_tag" {
  description = "Team Owner"
  type        = string
  default     = "Knowledge Exchange Hub"
}

variable "business_owner_tag" {
  description = "Business Owner"
  type        = string
  default     = "DST"
}

locals {
  lambda_repo = "${var.env_name}-${var.lambda_name}"
}
