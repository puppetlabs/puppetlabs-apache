require 'spec_helper'

describe 'apache', :type => :class do

  it { should include_class("apache::params") }

  it { should contain_package("httpd") }

  it { should contain_service("httpd").with(
    'ensure'    => 'running',
    'enable'    => 'true',
    'subscribe' => 'Package[httpd]'
    )
  }

  it { should contain_file("httpd_vdir").with(
    'ensure'  => 'directory',
    'recurse' => 'true',
    'purge'   => 'true',
    'notify'  => 'Service[httpd]',
    'require' => 'Package[httpd]'
    )
  }
end
