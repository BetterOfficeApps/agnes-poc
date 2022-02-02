resource "aws_lambda_function" "event_generator" {
  function_name = "agnes-test-event-generator${var.environment}"
  image_uri     = local.placeholder_uri # Do not change: overwritten by application deployment.
  memory_size   = 256
  package_type  = "Image"
  role          = aws_iam_role.lambda.arn
  timeout       = 30

  environment {
    variables = {
      ENVIRONMENT      = var.environment,
      ENVIRONMENT_TYPE = var.environment_type
    }
  }

  lifecycle {
    ignore_changes = [
      image_uri
    ]
  }
}

resource "aws_lambda_function_event_invoke_config" "event_generator" {
  function_name          = aws_lambda_function.event_generator.arn
  maximum_retry_attempts = 0
}

resource "aws_cloudwatch_log_group" "event_generator" {
  name              = "/aws/lambda/${aws_lambda_function.event_generator.function_name}"
  retention_in_days = 90
}

module "ecr_event_generator" {
  source  = "cloudposse/ecr/aws"
  version = "0.32.2"

  delimiter            = "/"
  image_tag_mutability = "MUTABLE"
  max_image_count      = 100
  name                 = "event-generator"
  namespace            = "${var.project}-${var.environment}"
  scan_images_on_push  = true
}
