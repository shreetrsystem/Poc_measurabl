variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}

variable "handler" {
  description = "The Lambda handler function"
  type        = string
}

variable "runtime" {
  description = "The Lambda runtime"
  type        = string
}

variable "source_path" {
  description = "The path to the Lambda source code zip file"
  type        = string
}

variable "source_hash" {
  description = "The base64-encoded SHA256 hash of the source code"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
