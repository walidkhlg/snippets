

variable "subnet_ids" {
  type = "map"
}

variable "kms_key_id" {}

variable "app_file" {}
variable "iam_role" {}
variable "instance_type" {}
variable "vpc_id" {}

variable "launch_ami" {
  default = "ami-25aaa6cf"
}

variable "asg_max" {}
variable "asg_min" {}
variable "asg_capacity" {}
variable "asg_grace" {}

variable "dbhost" {}
variable "db_user" {}
variable "db_password" {}
variable "db_name" {}
variable "dbread" {}
