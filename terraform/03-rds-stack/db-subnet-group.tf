resource "aws_db_subnet_group" "this" {
  name       = "loja-keycloak-db-subnet-group"
  subnet_ids = data.aws_subnets.private.ids
}
