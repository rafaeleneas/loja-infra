#06 = existência + conteúdo do segredo
#07 = acesso do cluster a esses segredos
#08 = acesso humano/roles ao EKS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "loja-remote-backend-bucket"
    key          = "eks-access/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.assume_role.region

  assume_role {
    role_arn = var.assume_role.arn
  }

  default_tags {
    tags = var.tags
  }
}
