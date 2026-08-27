variable "env" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
}

variable "tags" {
  type = map
  description = "Tags to add to AWS resources"
}

variable "ecr_images" {
  description = "List of ECR repositories"
  type        = list(string)
  default = [
    "test-image",
  ]
}