terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.4.0"
    }
  }

  # Best Practice: Use S3 for state management
  backend "s3" {
    bucket         = "my-poc-tf-state"
    key            = "poc/hello-world/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-poc-tf-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.tags
  }
}

# Archive the app directory
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../app"
  output_path = "${path.module}/lambda_function.zip"
  excludes    = ["__pycache__", ".pytest_cache"]
}

# Call the reusable Lambda module
module "hello_world_lambda" {
  source = "./modules/lambda"

  app_name    = var.app_name
  environment = var.environment
  handler     = "main.handler"
  runtime     = "python3.11"
  source_path = data.archive_file.lambda_zip.output_path
  source_hash = data.archive_file.lambda_zip.output_base64sha256
  tags        = var.tags
}
