variable "event_pattern" {
  description = "CloudWatch event pattern. Exactly one of event_pattern or schedule_expression must be set."
  default     = null
  type        = string
}

variable "schedule_expression" {
  description = "CloudWatch schedule expression (e.g. rate(5 minutes) or cron(0 12 * * ? *)). Exactly one of event_pattern or schedule_expression must be set."
  default     = null
  type        = string
}

variable "name" {
  description = "Name for the Cloud Watch Event Rule"
  default     = null
  type        = string
}

variable "description" {
  description = "Description for the Cloud Watch Event Rule"
  default     = null
  type        = string
}

variable "targets" {
  description = "Map of targets for the CloudWatch event rule. e.g. { \"example_target_id\" = { arn = \"example_lambda_arn\", role_arn = \"example_event_role_arn\" } }"
  default     = {}
  type        = map(any)
}

variable "lambda_permissions" {
  description = "Map of lambda permissions for the CloudWatch event rule. e.g. { \"example_statement_id_prefix\" = \"example_lambda_arn\" }"
  default     = {}
  type        = map(any)
}

variable "ecs_targets" {
  description = "Map of ECS task targets for the CloudWatch event rule. e.g. { \"example_target_id\" = { arn = \"example_cluster_arn\", role_arn = \"example_role_arn\", task_definition_arn = \"example_task_def_arn\" } }"
  default     = {}
  type = map(object({
    arn                 = string
    role_arn            = string
    task_definition_arn = string
    task_count          = optional(number, 1)
    launch_type         = optional(string, "FARGATE")
    platform_version    = optional(string, null)
    propagate_tags      = optional(bool, true)
    network_configuration = optional(object({
      subnets          = list(string)
      security_groups  = optional(list(string), [])
      assign_public_ip = optional(bool, false)
    }), null)
  }))
}
