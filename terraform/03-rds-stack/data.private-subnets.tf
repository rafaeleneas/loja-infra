data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = [false]
  }

  filter {
    name   = "tag:Project"
    values = ["loja"]
  }

  filter {
    name   = "tag:Environment"
    values = ["production"]
  }

  filter {
    name = "tag:Name"
    values = [
      "loja-vpc-private-subnet-1a",
      "loja-vpc-private-subnet-1b"
    ]
  }
}
