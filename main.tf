resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = local.name
  description = local.description

  event_pattern       = var.event_pattern
  schedule_expression = var.schedule_expression

  tags = local.tags

  lifecycle {
    precondition {
      condition     = (var.event_pattern != null) != (var.schedule_expression != null)
      error_message = "Exactly one of event_pattern or schedule_expression must be provided."
    }
  }
}

resource "aws_cloudwatch_event_target" "event_target" {
  for_each  = var.targets
  target_id = each.key
  rule      = aws_cloudwatch_event_rule.event_rule.name
  arn       = each.value.arn
  role_arn  = lookup(each.value, "role_arn", null)
}

resource "aws_cloudwatch_event_target" "ecs_event_target" {
  for_each  = var.ecs_targets
  target_id = each.key
  rule      = aws_cloudwatch_event_rule.event_rule.name
  arn       = each.value.arn
  role_arn  = each.value.role_arn

  ecs_target {
    task_definition_arn = each.value.task_definition_arn
    task_count          = each.value.task_count
    launch_type         = each.value.launch_type
    platform_version    = each.value.platform_version
    propagate_tags      = each.value.propagate_tags ? "TASK_DEFINITION" : null

    dynamic "network_configuration" {
      for_each = each.value.network_configuration != null ? [each.value.network_configuration] : []
      content {
        subnets          = network_configuration.value.subnets
        security_groups  = network_configuration.value.security_groups
        assign_public_ip = network_configuration.value.assign_public_ip
      }
    }
  }
}

resource "aws_lambda_permission" "allow_event_invocation" {
  for_each            = var.lambda_permissions
  statement_id_prefix = each.key
  action              = "lambda:InvokeFunction"
  function_name       = each.value
  principal           = "events.amazonaws.com"
  source_arn          = aws_cloudwatch_event_rule.event_rule.arn
}
