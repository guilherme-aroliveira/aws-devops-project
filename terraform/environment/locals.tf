locals {
  tags = {
    Organization = "HomeLabs"
    ManagedBy    = "Terraform"
    Project      = "eks-devops"
    Environment  = "${var.env}"
  }
}
