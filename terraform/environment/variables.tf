variable "AWS_REGION" {
  description = "AWS region for the tfstate S3 bucket"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  type        = string
  description = <<-EOF
    Deployment environment (e.g. dev, staging, prod)
    
    This variable automatically captures the value from the 
    GitHub environment variable TF_VAR_env to configure jobs.
  EOF
}