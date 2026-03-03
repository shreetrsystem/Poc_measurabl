output "lambda_url" {
  value = aws_lambda_function_url.hello_world_url.function_url
}
