terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.12.1"
    }
  }
  required_version = "~> 1.1.9"
}

provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}