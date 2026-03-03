output "lambda_url" {
  # value = aws_lambda_function_url.hello_world_url.function_url
  value = module.hello_world_lambda.lambda_function_url
}
