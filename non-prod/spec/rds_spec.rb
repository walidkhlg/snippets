require 'spec_helper'
require 'tfstate_values'

include Tf_state_values

describe rds(Values['rds_identifier']) do
  it { should exist }
  it { should belong_to_vpc(Values['vpc_id']) }
  it { should belong_to_db_subnet_group(Values['rds_subnet_group_name']) }
  its(:engine)            {should eq Values['rds_engine']}
  its(:kms_key_id)        {should eq Values['kms_key']}
  its(:db_instance_class) {should eq Values['rds_instance_class']}
  its(:db_cluster_identifier) {should eq Values['cluster_identifier']}
  its(:availability_zone) {should eq Values['db_az']}
  #its(:storage_encrypted) {should eq Values['storage_encrypted']}
end
