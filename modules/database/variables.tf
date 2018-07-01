variable "vpc_id" {}
variable "db_subnet_group" {}
data "aws_availability_zones" "available" {}

variable "private_sg_id" {}

variable "db_engine" {
  default = "aurora-mysql"
}

variable "db_name" {}
variable "db_user" {}
variable "db_instance_class" {}
variable "db_password" {}
