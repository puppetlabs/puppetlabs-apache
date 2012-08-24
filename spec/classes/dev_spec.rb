require 'spec_helper'

describe 'apache::dev', :type => :class do
  context "On a Debian OS" do
    let :facts do
      { :osfamily => 'Debian' }
    end
    it {
      should include_class("apache::params")
      should contain_package("libaprutil1-dev")
      should contain_package("libapr1-dev")
      should contain_package("apache2-prefork-dev")
    }
  end
  context "On a RedHat OS" do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    it {
      should include_class("apache::params")
      should contain_package("httpd-devel")
    }
  end
end
