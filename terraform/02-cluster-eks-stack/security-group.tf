data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["${terraform.workspace}-loja-vpc"]
  }
}

resource "aws_security_group" "eks_cluster" {
  name        = "loja-eks-cluster-sg"
  description = "Security group do control plane do EKS"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description = "Comunicacao interna da VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  egress {
    description = "Saida liberada"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "eks_node_group" {
  name        = "loja-eks-node-group-sg"
  description = "Security group dos nodes do EKS"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description     = "Trafego vindo do control plane"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  ingress {
    description = "Comunicacao entre nodes na VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  egress {
    description = "Saida liberada"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
