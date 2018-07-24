variable "aws_region" {}
variable "aws_profile" {}

variable "bucket_name" {}

data "aws_availability_zones" "available" {}

variable "vpc_id" {}

variable "db_instance_count" {}

variable "kms_key" {}
variable "instance_type" {}

variable "launch_ami" {
  default = "ami-25aaa6cf"
}

variable "autoscaling_instance_tags" {
  type = "list"
}

variable "ec2_role" {}
variable "asg_max" {}
variable "asg_min" {}
variable "asg_capacity" {}
variable "asg_grace" {}

variable "db_name" {}
variable "db_user" {}
variable "db_instance_class" {}
variable "db_password" {}

variable "db_engine" {
  default = "aurora-mysql"
}

variable "db_instance_tags" {
  type = "map"
}

variable "rest_api_name" {}
variable "lambda_runtime" {}
variable "deployment_stage" {}

data "aws_caller_identity" "current" {}
