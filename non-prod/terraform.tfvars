aws_profile = "role-C2E2-e2etesting"

aws_region = "eu-west-1"

# vpc
vpc_id = "vpc-0665f760"
ec2_role = "role-C2E2-ec2s3e2e_test"
kms_key = "arn:aws:kms:eu-west-1:854634259953:key/a53056c0-468a-4445-8412-c2366e565201"
subnet_ids = {
  "private1" = "${data.aws_subnet_ids.private.ids[0]}"
  "private2" = "${data.aws_subnet_ids.private.ids[1]}"
  "rds1"    = "${data.aws_subnet_ids.local.ids[0]}"
  "rds2"    = "${data.aws_subnet_ids.local.ids[1]}"
}
bucket_name = "s3-walid-web"
# autoscaling
instance_type = "t2.medium"

asg_capacity = "2"

asg_max = "4"

asg_min = "2"

asg_grace = "600"
# Database
db_instance_class = "db.t2.medium"

db_name = "web"

db_user = "walid"

db_password = "password123"

db_instance_count = 2
# lambda & API Gateway
lambda_runtime="python3.6"

deployment_stage = "dev"

rest_api_name = "web"
