data "archive_file" "lambda_app" {
  type        = "zip"
  output_path = local.file_name
  source_dir  = "${path.module}/app"

  output_file_mode = "0666"
}

resource "aws_lambda_function" "this" {
  filename         = local.file_name
  function_name    = local.function_name
  source_code_hash = filebase64sha256(data.archive_file.lambda_app.output_path)
  role             = aws_iam_role.this.arn
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  memory_size      = 258
  timeout          = 5

  tags = local.default_tags

  depends_on = [aws_iam_role_policy_attachment.lambda_logs]
}

resource "aws_iam_role" "this" {
  name = "${local.prefix}-${local.function_name}-iam-role"

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
  tags               = local.default_tags
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${local.prefix}-${local.function_name}-logging-policy"
  path        = "/"
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

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
