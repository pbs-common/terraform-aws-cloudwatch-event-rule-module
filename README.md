# PBS TF CloudWatch Event Rule Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-cloudwatch-event-rule-module?ref=x.y.z
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This module provisions a CloudWatch Event Rule. Use this to automate activity in AWS through CloudWatch based on events like CloudTrail events and scheduled events (crons).

Integrate this module like so:

```hcl
module "rule" {
  source = "github.com/pbs/terraform-aws-cloudwatch-event-rule-module?ref=x.y.z"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "ec2.amazonaws.com"
    ],
    "eventName": [
      "DescribeInstances"
    ]
  }
}
PATTERN

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
}
```

## Adding This Version of the Module

If this repo is added as a subtree, then the version of the module should be close to the version shown here:

`x.y.z`

Note, however that subtrees can be altered as desired within repositories.

Further documentation on usage can be found [here](./docs).

Below is automatically generated documentation on this Terraform module using [terraform-docs][terraform-docs]

---

[terraform-docs]: https://github.com/terraform-docs/terraform-docs

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.48.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.ecs_event_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.event_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_lambda_permission.allow_event_invocation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Tag used to group resources according to owner | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description for the Cloud Watch Event Rule | `string` | `null` | no |
| <a name="input_ecs_targets"></a> [ecs\_targets](#input\_ecs\_targets) | Map of ECS task targets for the CloudWatch event rule. e.g. { "example\_target\_id" = { arn = "example\_cluster\_arn", role\_arn = "example\_role\_arn", task\_definition\_arn = "example\_task\_def\_arn" } } | <pre>map(object({<br/>    arn                 = string<br/>    role_arn            = string<br/>    task_definition_arn = string<br/>    task_count          = optional(number, 1)<br/>    launch_type         = optional(string, "FARGATE")<br/>    platform_version    = optional(string, null)<br/>    propagate_tags      = optional(bool, true)<br/>    network_configuration = optional(object({<br/>      subnets          = list(string)<br/>      security_groups  = optional(list(string), [])<br/>      assign_public_ip = optional(bool, false)<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_event_pattern"></a> [event\_pattern](#input\_event\_pattern) | CloudWatch event pattern. Exactly one of event\_pattern or schedule\_expression must be set. | `string` | `null` | no |
| <a name="input_lambda_permissions"></a> [lambda\_permissions](#input\_lambda\_permissions) | Map of lambda permissions for the CloudWatch event rule. e.g. { "example\_statement\_id\_prefix" = "example\_lambda\_arn" } | `map(any)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the Cloud Watch Event Rule | `string` | `null` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | CloudWatch schedule expression (e.g. rate(5 minutes) or cron(0 12 * * ? *)). Exactly one of event\_pattern or schedule\_expression must be set. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_targets"></a> [targets](#input\_targets) | Map of targets for the CloudWatch event rule. e.g. { "example\_target\_id" = { arn = "example\_lambda\_arn", role\_arn = "example\_event\_role\_arn" } } | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the CloudWatch Event Rule |
