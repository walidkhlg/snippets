variable "vpc_id" {}
data "aws_availability_zones" "available" {}

variable "private_sg_id" {}

variable "db_engine" {
  default = "aurora-mysql"
}
variable "kms_key_id" {}

variable "db_name" {}
variable "db_user" {}
variable "db_instance_class" {}
variable "db_password" {}

variable "subnet_ids" {
  type = "map"
}
