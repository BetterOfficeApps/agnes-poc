resource "aws_iot_topic_rule" "rule" {
  name        = "LambdaRule"
  description = "Rule for message that will invoke HelloWorldLambda"
  enabled     = true
  sql         = "SELECT * FROM 'lambda_requests'"
  sql_version = "2016-03-23"

  lambda {
    function_arn = aws_lambda_function.hello_world.arn
  }
}
