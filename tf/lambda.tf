locals {
  placeholder_uri = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/cloud-common/placeholders:alpine-3.14.0"
}

resource "aws_iam_role" "lambda" {
  name = "agnes-${var.project}-${var.environment}-lambda"
  assume_role_policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Action" = "sts:AssumeRole",
          "Effect" = "Allow",
          "Principal" = {
            "Service" = "lambda.amazonaws.com"
          }
        }
      ]
    }
  )
}

resource "aws_iam_policy" "lambda_use_cloudwatch" {
  name = "agnes-${var.project}-${var.environment}-lambda-use-cloudwatch"
  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Action" = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" = [
            "${aws_cloudwatch_log_group.hello_world.arn}:*"
          ],
          "Effect" = "Allow"
        }
      ]
    }
  )
}

resource "aws_iam_policy" "lambda_use_s3" {
  name = "agnes-${var.project}-${var.environment}-lambda-use-s3"
  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Action" = [
            "s3:PutObject"
          ],
          "Effect" = "Allow",
          "Resource" = [
            "${aws_s3_bucket.this.arn}/*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_policy" "lambda_use_sqs" {
  name = "agnes-${var.project}-${var.environment}-lambda-use-sqs"
  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Action" = [
            "sqs:ReceiveMessage",
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes"
          ],
          "Effect" = "Allow",
          "Resource" = [
            "${aws_sqs_queue.event_queue.arn}"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_policy" "lambda_use_sns" {
  name = "agnes-${var.project}-${var.environment}-lambda-use-sns"
  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Action" = [
            "sns:GetTopicAttributes",
            "sns:List*",
          ],
          "Effect" = "Allow",
          "Resource" = [
            "${aws_sns_topic.say_hello.arn}"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_policy" "lambda_allow_sns_invoke" {
  name = "agnes-${var.project}-${var.environment}-lambda-allow-sns-invoke"
  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Action" = [
            "lambda:InvokeFunction",
          ],
          "Effect" = "Allow",
          "Principal": {
            "Service": [
              "sns.amazonaws.com"
            ]
          }
          "Resource" = [
            "${aws_sns_topic.say_hello.arn}"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "lambda_use_cloudwatch" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda_use_cloudwatch.arn
}

resource "aws_iam_role_policy_attachment" "lambda_use_s3" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda_use_s3.arn
}

resource "aws_iam_role_policy_attachment" "lambda_use_sqs" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda_use_sqs.arn
}

resource "aws_iam_role_policy_attachment" "lambda_use_sns" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda_use_sns.arn
}

resource "aws_iam_role_policy_attachment" "lambda_allow_sns_invoke" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda_allow_sns_invoke.arn
}

resource "aws_iam_role_policy_attachment" "lambda_use_xray" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}
