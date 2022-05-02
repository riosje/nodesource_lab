
module "vpc_nodesource_lab" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
  name    = "node-source-lab-${var.env}"
  cidr    = "10.0.0.0/16"

  azs             = ["us-east-1b", "us-east-1c"]
  public_subnets  = ["10.0.0.0/23", "10.0.2.0/23"]
  private_subnets = ["10.0.4.0/23", "10.0.6.0/23"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  private_subnet_tags = { "kubernetes.io/role/internal-elb" = "1" }
  public_subnet_tags  = { "kubernetes.io/role/elb" = "1" }

  tags = {
  }
}

module "eks_cluster" {

  source          = "github.com/riosje/terraform_module_eks?ref=1.0.0"
  cluster_name    = "nodesource-lab-${var.env}"
  cluster_version = "1.21"
  vpc_config = {
    vpc_id          = module.vpc_nodesource_lab.vpc_id
    vpc_subnets_ids = concat(module.vpc_nodesource_lab.private_subnets, module.vpc_nodesource_lab.public_subnets)
  }

  eks_managed_node_groups = {
    main = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.large", "t3.medium"]
      capacity_type  = "SPOT"
      subnet_ids     = module.vpc_nodesource_lab.private_subnets
    }
  }

  load_balancer_controller = {
    enabled = true
    version = "1.4.1"
  }

}

locals {
  ecr_registry_name = [
    "nodesource-lab-micro-a",
  "nodesource-lab-micro-b"]
}

resource "aws_ecr_repository" "microservices" {
  for_each             = toset(local.ecr_registry_name)
  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}


resource "kubernetes_ingress_v1" "nodesource_ingress" {
  depends_on = [
    module.eks_cluster
  ]
  metadata {
    name      = "ingress-nodesource-lab"
    namespace = "default"
    annotations = {
      "alb.ingress.kubernetes.io/healthcheck-path" = "/health_check"
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
    }
  }

  spec {
    ingress_class_name = "aws-alb"
    rule {
      http {

        path {
          backend {
            service {
              name = "microservicea"
              port {
                number = 80
              }
            }
          }
          path      = "/service1"
          path_type = "Prefix"
        }

        path {
          backend {
            service {
              name = "microserviceb"
              port {
                number = 80
              }
            }
          }
          path      = "/service2"
          path_type = "Prefix"
        }

      }
    }
  }
}