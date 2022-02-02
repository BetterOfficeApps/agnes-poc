resource "aws_cloudwatch_event_bus" "messenger" {
  name = "agnes-test-messenger"
}

resource "aws_cloudwatch_event_rule" "invoke_lambda" {
  name        = "invoke-lambda"
  description = "Invoke Lambda when receiving event"
  event_bus_name = aws_cloudwatch_event_bus.messenger.name

  event_pattern = <<EOF
  {
    "detail-type": [
      "appRequestSubmitted"
    ]
  }
  EOF
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.invoke_lambda.name
  target_id = "InvokeHelloWorldLambda"
  arn       = aws_lambda_function.hello_world.arn
}
