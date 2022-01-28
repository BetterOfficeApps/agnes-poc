# Required variables

variable "environment" {
  type        = string
  description = "(Required) The environment this is being deployed to. Examples: \"prd1\", \"xandar\", etc."
}

variable "environment_type" {
  type        = string
  description = "(Required) The environment type this is being deployed to. Options: [\"production\", \"staging\", \"development\"]"
}

# Optional variables

variable "enable_sentry" {
  type        = bool
  description = "(Optional) Enables error reporting to Sentry for all Lambda functions."
  default     = true
}

variable "project" {
  type        = string
  description = "(Optional) The project name used for identifying resources. Default: \"hello-world\""
  default     = "hello-world"
}
