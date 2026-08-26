variable "env" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
}

variable "ecr_images" {
  description = "List of ECR repositories"
  type        = list(string)
  default = [
    "test-image",
  ]
}