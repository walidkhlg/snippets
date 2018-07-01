provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

module "vpc" {
  source = "../modules/vpc"

  cidrs = {
    public1 = "10.0.1.0/24"
    public2 = "10.0.2.0/24"
    rds1    = "10.0.5.0/24"
    rds2    = "10.0.6.0/24"
  }

  vpc_cidr = "${var.vpc_cidr}"
}

module "database" {
  source            = "../modules/database"
  db_subnet_group   = "${module.vpc.subnet_ids[2]}"
  vpc_id            = "${module.vpc.vpc_id}"
  db_name           = "${var.db_name}"
  db_password       = "${var.db_password}"
  db_user           = "${var.db_user}"
  db_instance_class = "${var.db_instance_class}"
  private_sg_id     = "${module.application.private_sg_id}"
}

module "application" {
  source        = "../modules/application"
  asg_max       = "${var.asg_max}"
  asg_min       = "${var.asg_min}"
  asg_capacity  = "${var.asg_capacity}"
  asg_grace     = "${var.asg_grace}"
  vpc_cidr      = "${var.vpc_cidr}"
  vpc_id        = "${module.vpc.vpc_id}"
  db_name       = "${var.db_name}"
  db_user       = "${var.db_password}"
  dbhost        = "${module.database.dbhost}"
  dbread        = "${module.database.dbread}"
  db_password   = "${var.db_password}"
  subnet_ids    = "${module.vpc.subnet_ids}"
  instance_type = "${var.instance_type}"
  bucket_name   = "${var.bucket_name}"
}

module "serverless" {
  source               = "../modules/serverless"
  lambda_runtime       = "${var.lambda_runtime}"
  db_host              = "${module.database.dbhost}"
  db_read              = "${module.database.dbread}"
  subnet_ids           = "${module.vpc.subnet_ids}"
  db_password          = "${var.db_password}"
  db_user              = "${var.db_user}"
  db_name              = "${var.db_user}"
  private_sg_id        = "${module.application.private_sg_id}"
  lambda_zip_file_name = "lambda_package.zip"
  lambda_runtime       = "${var.lambda_runtime}"
  deployment_stage     = "${var.deployment_stage}"
  aws_region           = "${var.aws_region}"
  rest_api_name        = "${var.rest_api_name}"
}
