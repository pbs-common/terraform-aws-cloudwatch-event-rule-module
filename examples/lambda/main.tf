data "archive_file" "lambdazip" {
  type        = "zip"
  output_path = "handler.zip"

  source_dir = "../lambda-src/"
}

module "lambda" {
  source = "github.com/pbs/terraform-aws-lambda-module?ref=0.0.2"

  handler  = "handler.handler"
  runtime  = "python3.8"
  filename = data.archive_file.lambdazip.output_path

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
}

module "event_rule" {
  source = "../.."

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

  targets = {
    "lambda_target_id" = {
      arn = module.lambda.arn
    }
  }

  lambda_permissions = {
    "invoke_cms_deploys_lambda" = module.lambda.arn
  }

  organization = var.organization
  environment  = var.environment
  product      = var.product
  owner        = var.owner
  repo         = var.repo
}
