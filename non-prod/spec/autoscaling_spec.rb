require 'spec_helper'
require 'tfstate_values'

include Tf_state_values

describe autoscaling_group(Values['autoscaling_name']) do
  it { should exist }
  it { should have_elb( Values['elb_name'] ) }
  it { should have_launch_configuration(Values['launch_config_name']) }
  its(:auto_scaling_group_name) {should eq Values['autoscaling_name']}
end

describe launch_configuration( Values['launch_config_name'] ) do
  it { should exist }
  its(:image_id) {should eq Values['image_id']}
  its(:instance_type) {should eq Values['instance_type'] }
  its(:iam_instance_profile) {should eq Values['iam_instance_profile']}
end

describe elb(Values['elb_name']) do
  it { should exist }
  it { should belong_to_vpc(Values['vpc_id']) }
  its(:dns_name) {should eq Values['elb_dns']}
  its(:load_balancer_name) {should eq Values['elb_name']}
end
