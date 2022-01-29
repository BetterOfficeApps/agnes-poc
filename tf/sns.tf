resource "aws_sns_topic" "say_hello" {
  name = "say-hello-topic"
}

resource "aws_iam_role" "sns" {
  name = "agnes-${var.project}-${var.environment}-sns"
  assume_role_policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Action" = "sts:AssumeRole",
          "Effect" = "Allow",
          "Principal" = {
            "Service" = "sns.amazonaws.com"
          }
        }
      ]
    }
  )
}

resource "aws_iam_policy" "sns_default_policy" {
  name = "agnes-${var.project}-${var.environment}-sns-default"
  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Action" = [
            "SNS:Subscribe",
            "SNS:SetTopicAttributes",
            "SNS:RemovePermission",
            "SNS:Publish",
            "SNS:ListSubscriptionsByTopic",
            "SNS:GetTopicAttributes",
            "SNS:DeleteTopic",
            "SNS:AddPermission",
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

resource "aws_iam_role_policy_attachment" "sns_has_default" {
  role       = aws_iam_role.sns.name
  policy_arn = aws_iam_policy.sns_default_policy.arn
}

resource "aws_sns_topic_subscription" "lambda_say_hello" {
  topic_arn = aws_sns_topic.say_hello.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.hello_world.arn
}
