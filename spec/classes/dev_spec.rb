require 'spec_helper'

describe 'apache::dev', :type => :class do

  it { should include_class("apache::params") }
  it { should contain_package("apache_dev_package") }

end
