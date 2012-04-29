require 'spec_helper'

describe 'apache::ssl', :type => :class do

  it { should include_class("apache") }
  it { should include_class("apache::params") }

  describe "it should install the ssl package in redhat" do
    let :facts do
      { :operatingsystem => 'redhat' }
    end

    it { should contain_package("apache_ssl_package").with(
        'ensure'  => 'installed'
      )
    }
  end

  describe "it should contain a2mod ssl in debian" do
    let :facts do
      { :operatingsystem => 'debian' }
    end

    it { should contain_a2mod("ssl").with(
        'ensure'  => 'present'
      )
    }
  end

end
