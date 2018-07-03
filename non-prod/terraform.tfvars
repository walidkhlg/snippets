aws_profile = "role-C2E2-e2etesting"

aws_region = "eu-west-1"

vpc_id = "vpc-0665f760"
cidrs = {
  public1  = "10.0.1.0/24"
  public2  = "10.0.2.0/24"
  rds1     = "10.0.5.0/24"
  rds2     = "10.0.6.0/24"
}
ec2_role = "role-C2E2-ec2s3e2e_test"
kms_key = "arn:aws:kms:eu-west-1:854634259953:key/a53056c0-468a-4445-8412-c2366e565201"
subnet_ids = {
  "public1" = "${data.aws_subnet_ids.private[0]}"
  "public2" = "${data.aws_subnet_ids.private[1]}"
  "rds1"    = "${data.aws_subnet_ids.local[0]}"
  "rds2"    = "${data.aws_subnet_ids.private[1]}"
}
bucket_name = "s3-walid-web"

instance_type = "t2.medium"

asg_capacity = "2"

asg_max = "4"

asg_min = "2"

asg_grace = "300"

db_instance_class = "db.t2.medium"

db_name = "web"

db_user = "walid"

db_password = "password123"

lambda_runtime="python3.6"

deployment_stage = "dev"

rest_api_name = "web"
