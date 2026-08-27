# 1. Create IAM Role for the EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "EKSClusterRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# 2. Attach the standard AWS policy for the EKS Cluster
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# 3. Create IAM Role for the EKS Node
resource "aws_iam_role" "eks_node_role" {
  name = "EKSNodeRole"
  assume_role_policy = jsondecode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# 4. Attach the standard AWS policy for the EKS Node
resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

# 5. Create IAM Role for the Load Balancer Controller
resource "aws_iam_role" "eks_lb_controller_role" {
  name = "EKSLoadBalancerControllerRole"
  assume_role_policy = jsondecode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "elastiloadbalacing.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# 6. Attach the standard AWS policy for the LB Controller
resource "aws_iam_role_policy_attachment" "eks_lb_controller_policy" {
  role       = aws_iam_role.eks_lb_controller_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLoadBalancerControllerIAMPolicy"
}