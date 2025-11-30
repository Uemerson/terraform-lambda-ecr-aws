resource "aws_ecr_repository" "ecr_repository" {
  name                  = var.ecr_repository_name
  image_tag_mutability  = "MUTABLE"
  force_delete          = true
}

data "aws_ecr_image" "lambda_image" {
  repository_name = aws_ecr_repository.ecr_repository.name
  image_tag       = "latest"
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_name}-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_name
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.ecr_repository.repository_url}@${data.aws_ecr_image.lambda_image.image_digest}"
  role          = aws_iam_role.lambda_role.arn
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory
}