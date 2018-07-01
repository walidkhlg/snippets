variable "aws_region" {}
variable "aws_profile" {}
variable "vpc_cidr" {}

variable "bucket_name" {}

data "aws_availability_zones" "available" {}

variable "cidrs" {
  type = "map"
}

variable "instance_type" {}

variable "launch_ami" {
  default = "ami-9cbe9be5"
}

variable "asg_max" {}
variable "asg_min" {}
variable "asg_capacity" {}
variable "asg_grace" {}

variable "db_engine" {
  default = "aurora-mysql"
}

variable "rest_api_name" {}
variable "lambda_runtime" {}
variable "deployment_stage" {}
variable "db_name" {}
variable "db_user" {}
variable "db_instance_class" {}
variable "db_password" {}
data "aws_caller_identity" "current" {}
