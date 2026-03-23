data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["${terraform.workspace}-loja-vpc"]
  }
}
