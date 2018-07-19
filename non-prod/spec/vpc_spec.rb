require 'spec_helper'
require 'tfstate_values'


describe vpc(Values['vpc_id']) do
  it { should exist }
  it { should be_available }
end
