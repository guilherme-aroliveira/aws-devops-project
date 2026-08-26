

locals {
  tags = {
    ManagedBy   = "Terraform"
    Project     = "devops"
    Environment = "${var.env}"
  }
}