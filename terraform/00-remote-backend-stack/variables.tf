variable "tags" {
  type = map(string)
  default = {
    Environment = "production"
    Project     = "loja"
  }
}

variable "assume_role" {
  type = object({
    arn    = string
    region = string
  })
  default = {
    arn    = "arn:aws:iam::950992723561:role/role_loja"
    region = "us-east-1"
  }
}

variable "remote_backend" {
  type = object({
    bucket_name                = string
    dynamo_table_name          = string
    dynamo_table_billing_mode  = string
    dynamo_table_hash_key      = string
    dynamo_table_hash_key_type = string
  })

  default = {
    bucket_name                = "loja-remote-backend-bucket"
    dynamo_table_name          = "loja-state-locking-table"
    dynamo_table_billing_mode  = "PAY_PER_REQUEST"
    dynamo_table_hash_key      = "LockID"
    dynamo_table_hash_key_type = "S"
  }
}
