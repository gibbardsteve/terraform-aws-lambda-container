data "aws_ecr_repository" "profile_lambda_ecr_repo" {
  name = local.lambda_repo
}

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"] #trivy:ignore:AVD-AWS-0057
  }
}

data "aws_iam_policy_document" "lambda_s3_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListAllMyBuckets", # Allows listing all buckets in the account
      "s3:GetObject",        # Allows reading objects in buckets
      "s3:PutObject"         # Allows writing objects to buckets
    ]

    resources = [
      "arn:aws:s3:::*",  # Allows access to all buckets
      "arn:aws:s3:::*/*" # Allows access to all objects within all buckets
    ]
  }
}

data "aws_iam_policy_document" "lambda_eventbridge_policy" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      aws_lambda_function.lambda_function.arn
    ]
  }
}

