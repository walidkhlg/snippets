aws_profile = "compte-lab-26"

aws_region = "eu-west-1"

vpc_cidr = "10.0.0.0/16"

cidrs = {
  public1  = "10.0.1.0/24"
  public2  = "10.0.2.0/24"
  rds1     = "10.0.5.0/24"
  rds2     = "10.0.6.0/24"
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
