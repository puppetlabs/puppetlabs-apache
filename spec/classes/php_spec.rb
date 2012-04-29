require 'spec_helper'

describe 'apache::php', :type => :class do

  it { should include_class("apache::params") }
  it { should contain_package("apache_php_package") }

end
