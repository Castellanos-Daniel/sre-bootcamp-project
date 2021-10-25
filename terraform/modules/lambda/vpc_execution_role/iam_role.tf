data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_vpc_role" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]

  inline_policy {
    name = "database_access"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["rds-db:connect"]
          Effect   = "Allow"
          Resource = "arn:aws:rds-db:us-east-2:874223335165:dbuser:*/${var.db_username}"
        },
      ]
    })
  }
 
  inline_policy {
    name = "secret_manager_read_access"
    
    policy = jsonencode({
      "Version" = "2012-10-17",
      "Statement" = [
        {
          Action = "secretsmanager:GetSecretValue",
          Effect = "Allow",
          Resource = "*"
        }
      ]
    })
  }

  tags = {
    created-by = "terraform"
  }
}
