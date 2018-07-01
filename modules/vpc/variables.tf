variable "cidrs" {
  type = "map"
}

data "aws_availability_zones" "available" {}
variable "vpc_cidr" {}
