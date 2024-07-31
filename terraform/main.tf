resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_name
  timeout       = 5 # seconds
  image_uri     = "${data.aws_ecr_repository.profile_lambda_ecr_repo.repository_url}:${var.lambda_version}"
  package_type  = "Image"
  architectures = [var.lambda_arch]

  role = aws_iam_role.lambda_function_role.arn

  environment {
    variables = {
      ENVIRONMENT = var.env_name
    }
  }
}

resource "aws_iam_role" "lambda_function_role" {
  name = "${var.lambda_name}-${var.env_name}-role"

  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_function_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_policy" "lambda_s3_policy" {
  name        = "${var.lambda_name}-${var.env_name}-s3-policy"
  description = "IAM policy for S3 access for Lambda function"
  policy      = data.aws_iam_policy_document.lambda_s3_policy.json
}

resource "aws_iam_role_policy_attachment" "s3_policy" {
  role       = aws_iam_role.lambda_function_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

resource "aws_iam_policy" "lambda_eventbridge_policy" {
  name        = "${var.lambda_name}-${var.env_name}-eventbridge-policy"
  description = "IAM policy to allow EventBridge to invoke Lambda function"
  policy      = data.aws_iam_policy_document.lambda_eventbridge_policy.json
}

resource "aws_iam_role_policy_attachment" "eventbridge_policy" {
  role       = aws_iam_role.lambda_function_role.name
  policy_arn = aws_iam_policy.lambda_eventbridge_policy.arn
}

resource "aws_cloudwatch_log_group" "loggroup" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
  retention_in_days = var.log_retention_days
}