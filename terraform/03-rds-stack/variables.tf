variable "tags" {
  type = map(string)
  default = {
    Environment = "production"
    Project     = "loja"
  }
}

variable "assume_role" {
  description = "Role e regiao usadas pelo provider AWS. Defina em terraform.tfvars local."
  type = object({
    arn    = string
    region = string
  })
}

variable "rds" {
  type = object({
    identifier              = string
    db_name                 = string
    engine                  = string
    engine_version          = string
    instance_class          = string
    allocated_storage       = number
    max_allocated_storage   = number
    storage_type            = string
    username                = string
    port                    = number
    publicly_accessible     = bool
    multi_az                = bool
    backup_retention_period = number
    skip_final_snapshot     = bool
    storage_encrypted       = bool
    deletion_protection     = bool
  })

  default = {
    identifier              = "loja-keycloak-postgres"
    db_name                 = "keycloak"
    engine                  = "postgres"
    engine_version          = "17.4"
    instance_class          = "db.t4g.micro"
    allocated_storage       = 20
    max_allocated_storage   = 0
    storage_type            = "gp3"
    username                = "keycloak"
    port                    = 5432
    publicly_accessible     = false
    multi_az                = false
    backup_retention_period = 1
    skip_final_snapshot     = true
    storage_encrypted       = true
    deletion_protection     = false
  }
}

variable "rds_password" {
  description = "Senha do usuario administrador inicial do banco."
  type        = string
  sensitive   = true
}
