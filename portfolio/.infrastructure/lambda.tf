resource "aws_lambda_function" "send_email_lambda" {
  function_name = "contactFormEmailSender"
  runtime = "python3.9"
  role = aws_iam_role.lambda_role.arn
  handler = "main.lambda_handler"
  filename = "my-deployment-package.zip"
  depends_on = [ 
    aws_iam_role_policy_attachment.lambda_ses,
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda_log_group
   ]
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/contactFormEmailSender"
  retention_in_days = 14
}

resource "aws_iam_policy" "lambda_log_policy" {
  name = "lambda_log_policy"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*",
        "Effect": "Allow"
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "lambda_ses_full_access" {
  name = "lambda_ses_full_access"
  path = "/"
  description = "IAM policy for giving lambda full access to ses"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ses:*"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_log_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_ses" {
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_ses_full_access.arn  
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}