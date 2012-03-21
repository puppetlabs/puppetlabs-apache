require 'spec_helper'

describe 'apache::params', :type => :class do

  it { should contain_apache__params }

  # There are 4 resources in this class currently
  # there should not be any more resources because it is a params class
  # The resources are class[apache::params], class[main], class[settings], stage[main]
  it "Should not contain any resources" do
    subject.resources.size.should == 4
  end
end
