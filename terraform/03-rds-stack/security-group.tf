resource "aws_security_group" "rds" {
  name        = "loja-keycloak-rds-sg"
  description = "Security group do RDS usado pelo Keycloak"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description = "PostgreSQL vindo da rede privada da VPC"
    from_port   = var.rds.port
    to_port     = var.rds.port
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
