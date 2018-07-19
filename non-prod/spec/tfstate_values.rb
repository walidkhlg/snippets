require 'json'

module Tf_state_values
  tfstate = File.read('terraform.tfstate')
  parsed = JSON.parse(tfstate)
  root = parsed['modules'][0]
  compute = parsed['modules'][1]
  database = parsed['modules'][2]
  Values = Hash.new
  Values['vpc_id']                 = compute['resources']['data.aws_subnet_ids.private']['primary']['attributes']['vpc_id']
  Values['kms_key']                = database['resources']['aws_rds_cluster_instance.cluster-instance1']['primary']['attributes']['kms_key_id']
  Values['rds_engine']             = database['resources']['aws_rds_cluster_instance.cluster-instance1']['primary']['attributes']['engine']
  Values['rds_identifier']         = database['resources']['aws_rds_cluster_instance.cluster-instance1']['primary']['attributes']['identifier']
  Values['rds_instance_class']     = database['resources']['aws_rds_cluster_instance.cluster-instance1']['primary']['attributes']['instance_class']
  Values['rds_subnet_group_name']  = database['resources']['aws_rds_cluster_instance.cluster-instance1']['primary']['attributes']['db_subnet_group_name']
  Values['cluster_identifier']     = database['resources']['aws_rds_cluster_instance.cluster-instance1']['primary']['attributes']['cluster_identifier']
  Values['db_az']                  = database['resources']['aws_rds_cluster_instance.cluster-instance1']['primary']['attributes']['availability_zone']
  Values['storage_encrypted']      = database['resources']['aws_rds_cluster_instance.cluster-instance1']['primary']['attributes']['storage_encrypted']

  Values['autoscaling_name']       = compute['resources']['aws_autoscaling_group.web-asg']['primary']['attributes']['name']
  Values['asg_lb']                 = compute['resources']['aws_autoscaling_group.web-asg']['primary']['attributes']['load_balancer']
  Values['launch_config_name']     = compute['resources']['aws_launch_configuration.web-lc']['primary']['attributes']['name']
  Values['image_id']               = compute['resources']['aws_launch_configuration.web-lc']['primary']['attributes']['image_id']
  Values['instance_type']          = compute['resources']['aws_launch_configuration.web-lc']['primary']['attributes']['instance_type']
  Values['iam_instance_profile']   = compute['resources']['aws_launch_configuration.web-lc']['primary']['attributes']['iam_instance_profile']
  Values['elb_name']               = compute['resources']['aws_elb.web-elb']['primary']['attributes']['id']
  Values['elb_az']                 = compute['resources']['aws_elb.web-elb']['primary']['attributes']['availability_zones']
  Values['elb_dns']                = compute['resources']['aws_elb.web-elb']['primary']['attributes']['dns_name']


end
