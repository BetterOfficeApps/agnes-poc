resource "aws_sns_topic" "say_hello" {
  name = "say-hello-topic"
}

resource "aws_iam_role" "sns" {
  name = "agnes-${var.project}-${var.environment}-sns"
  assume_role_policy = jsonencode(
    {
      "Version" = "2022-01-28",
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
      "Version" = "2022-01-28",
      "Statement" = [
        {
          "Action" = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:PutMetricFilter",
            "logs:PutRetentionPolicy"
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
  policy_arn = aws_iam_policy.sns_default_policy
}
