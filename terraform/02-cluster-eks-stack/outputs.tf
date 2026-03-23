output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "eks_node_group_name" {
  value = aws_eks_node_group.this.node_group_name
}

output "eks_cluster_security_group_id" {
  value = aws_security_group.eks_cluster.id
}

output "eks_node_group_security_group_id" {
  value = aws_security_group.eks_node_group.id
}

output "github_role_arn" {
  value = aws_iam_role.github.arn
}

output "ecr_repository_arns" {
  value = aws_ecr_repository.this[*].arn
}
