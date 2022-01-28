data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ssm_parameter" "dd_api_key" {
  name = "/default/DD_API_KEY"
}
