locals {
  eks_oidc_issuer_host = trimprefix(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://")
}

resource "aws_iam_openid_connect_provider" "eks" {
  url             = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "external_secrets" {
  name = "loja-external-secrets-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRoleWithWebIdentity"
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      }
      Condition = {
        StringEquals = {
          "${local.eks_oidc_issuer_host}:aud" = "sts.amazonaws.com"
          "${local.eks_oidc_issuer_host}:sub" = "system:serviceaccount:${var.external_secrets.namespace}:${var.external_secrets.service_account_name}"
        }
      }
    }]
  })
}

resource "aws_iam_policy" "external_secrets" {
  name        = "loja-external-secrets-policy"
  description = "Permite ao External Secrets Operator ler segredos de runtime do projeto loja"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ]
      Resource = "arn:aws:secretsmanager:${var.assume_role.region}:${data.aws_caller_identity.current.account_id}:secret:${var.external_secrets.secret_name_prefix}*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "external_secrets" {
  role       = aws_iam_role.external_secrets.name
  policy_arn = aws_iam_policy.external_secrets.arn
}
