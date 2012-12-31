require 'spec_helper'

describe 'apache', :type => :class do
  context "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    it { should include_class("apache::params") }
    it { should contain_package("httpd") }
    it { should contain_service("httpd").with(
      'ensure'    => 'true',
      'enable'    => 'true',
      'subscribe' => 'Package[httpd]'
      )
    }
    it { should contain_file("/etc/apache2/sites-enabled").with(
      'ensure'  => 'directory',
      'recurse' => 'true',
      'purge'   => 'true',
      'notify'  => 'Service[httpd]',
      'require' => 'Package[httpd]'
      )
    }
  end
  context "on a RedHat 5 OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '5',
        :concat_basedir         => '/dne',
      }
    end
    it { should include_class("apache::params") }
    it { should contain_package("httpd") }
    it { should contain_service("httpd").with(
      'ensure'    => 'true',
      'enable'    => 'true',
      'subscribe' => 'Package[httpd]'
      )
    }
    it { should contain_file("/etc/httpd/site.d").with(
      'ensure'  => 'directory',
      'recurse' => 'true',
      'purge'   => 'true',
      'notify'  => 'Service[httpd]',
      'require' => 'Package[httpd]'
      )
    }
  end
end
