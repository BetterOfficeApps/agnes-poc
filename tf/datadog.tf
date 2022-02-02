module "datadog" {
  source                         = "scribd/datadog/aws"
  version                        = "2.4.0"
  aws_account_id                 = data.aws_caller_identity.current.account_id
  aws_region                     = data.aws_region.current.name
  create_elb_logs_bucket         = false
  datadog_api_key                = data.aws_ssm_parameter.dd_api_key.value
  dd_forwarder_template_version  = "3.27.0"
  enable_datadog_aws_integration = false
  env                            = var.environment
  namespace                      = var.project

  cloudwatch_log_groups = [
    aws_cloudwatch_log_group.hello_world.name,
    aws_cloudwatch_log_group.event_generator.name
  ]
}
