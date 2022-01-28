resource "aws_lambda_function" "hello_world" {
  function_name = "agnes-test-${var.environment}"
  image_uri     = local.placeholder_uri # Do not change: overwritten by application deployment.
  memory_size   = 256
  package_type  = "Image"
  role          = aws_iam_role.lambda.arn
  timeout       = 30

  environment {
    variables = {
      ENVIRONMENT      = var.environment,
      ENVIRONMENT_TYPE = var.environment_type,
      S3_BUCKET        = aws_s3_bucket.this.bucket,
      SENTRY_DSN       = var.enable_sentry ? "<INSERT_SENTRY_DSN>" : ""
    }
  }

  lifecycle {
    ignore_changes = [
      image_uri
    ]
  }

  tags = {
    env     = var.environment              # Used by Datadog.
    service = "agnes-test" # Used by Datadog.
  }
}

resource "aws_lambda_event_source_mapping" "sqs_event_source" {
  event_source_arn  = aws_sqs_queue.event_queue.arn
  function_name     = aws_lambda_function.hello_world.arn
}

resource "aws_lambda_function_event_invoke_config" "hello_world" {
  function_name          = aws_lambda_function.hello_world.arn
  maximum_retry_attempts = 0
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name              = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"
  retention_in_days = 90
}

module "ecr_hello_world" {
  source  = "cloudposse/ecr/aws"
  version = "0.32.2"

  delimiter            = "/"
  image_tag_mutability = "MUTABLE"
  max_image_count      = 100
  name                 = "hello-world"
  namespace            = "${var.project}-${var.environment}"
  scan_images_on_push  = true
}
