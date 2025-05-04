module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name    = "myapp-eks-cluster"
  cluster_version = "1.32"

  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc_id
  cluster_endpoint_public_access = true

  tags = {
    environment = "dev"
    application = "myapp"
    managed_by  = "terraform"
  }

  eks_managed_node_groups = {
    dev = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 3
      desired_size = 3
    }
  }

}
