aws_profile = "role-C2E2-e2etesting"

aws_region = "eu-west-1"

# vpc
vpc_id = "vpc-0665f760"
ec2_role = "role-C2E2-ec2s3e2e_test"
kms_key = "arn:aws:kms:eu-west-1:854634259953:key/a53056c0-468a-4445-8412-c2366e565201"

bucket_name = "s3-walid-web"
# autoscaling
instance_type = "t2.micro"

asg_capacity = "2"

asg_max = "2"

asg_min = "2"

asg_grace = "360"

### tags for instances launched by the autoscaling group
autoscaling_instance_tags = [
{
key                 = "Name"
propagate_at_launch = true
value               = "asg-web"
},
{
key                 = "airbus:stage"
propagate_at_launch = true
value               = "dev"
}
]

# Database
db_instance_class = "db.t2.medium"

db_name = "web"

db_user = "master"

db_password = "password123"

db_instance_count = 2

db_instance_tags {
"airbus:application_code" = "C2E2"
"airbus:environment"      = "creteste2e"
"airbus:stage"            = "dev"
}
# lambda & API Gateway
lambda_runtime="python3.6"

deployment_stage = "dev"

rest_api_name = "web"
