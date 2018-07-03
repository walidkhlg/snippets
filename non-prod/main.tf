provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

/*module "iam" {
  source      = "../modules/iam"
  bucket_name = "${module.application.logs_bucket_name}"
  logs_bucket = "${module.application.bucket_name}"
}*/

module "database" {
  source            = "../modules/database"
  subnet_ids        = "${var.subnet_ids}"
  vpc_id            = "${var.vpc_id}"
  db_name           = "${var.db_name}"
  db_password       = "${var.db_password}"
  db_user           = "${var.db_user}"
  db_instance_class = "${var.db_instance_class}"
  private_sg_id     = "${module.application.private_sg_id}"
  kms_key_id        = "${var.kms_key}"
}

module "application" {
  source        = "../modules/application_infra"
  app_file      = "log.sh"
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
  subnet_ids    = "${var.subnet_ids}"
  instance_type = "${var.instance_type}"
  kms_key_id    = "${var.kms_key}"
  iam_role      = "${var.ec2_role}"
}

/*module "serverless" {
  source               = "../modules/serverless"
  lambda_runtime       = "${var.lambda_runtime}"
  db_host              = "${module.database.dbhost}"
  db_read              = "${module.database.dbread}"
  subnet_ids           = "${var.subnet_ids}"
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
*/
