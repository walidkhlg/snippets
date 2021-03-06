provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

module "database" {
  source            = "../modules/database"
  db_instance_count = "${var.db_instance_count}"
  vpc_id            = "${var.vpc_id}"
  db_name           = "${var.db_name}"
  db_password       = "${var.db_password}"
  db_user           = "${var.db_user}"
  db_instance_class = "${var.db_instance_class}"
  private_sg_id     = "${module.application.private_sg_id}"
  kms_key_id        = "${var.kms_key}"
  db_instance_tags  = "${var.db_instance_tags}"
}

module "application" {
  source        = "../modules/application_infra"
  launch_ami    = "${var.launch_ami}"
  asg_max       = "${var.asg_max}"
  asg_min       = "${var.asg_min}"
  asg_capacity  = "${var.asg_capacity}"
  asg_grace     = "${var.asg_grace}"
  vpc_id        = "${var.vpc_id}"
  db_name       = "${var.db_name}"
  db_user       = "${var.db_password}"
  dbhost        = "${module.database.dbhost}"
  dbread        = "${module.database.dbread}"
  db_password   = "${var.db_password}"
  instance_type = "${var.instance_type}"
  iam_role      = "${var.ec2_role}"
  tags          = ["${var.autoscaling_instance_tags}"]
}

/*module "serverless" {
  source           = "../modules/serverless"
  db_host          = "${module.database.dbhost}"
  db_read          = "${module.database.dbread}"
  db_password      = "${var.db_password}"
  db_user          = "${var.db_password}"
  lambda_runtime   = "${var.lambda_runtime}"
  deployment_stage = "${var.deployment_stage}"
}*/

