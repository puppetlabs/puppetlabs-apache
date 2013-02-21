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
    describe "Alternate confd/mod/vhosts directory" do
      let :params do
        {
          :vhost_dir => '/etc/httpd/conf.d',
          :confd_dir => '/etc/httpd/conf.d',
          :mod_dir   => '/etc/httpd/conf.d',
        }
      end

      it { should contain_file("/etc/httpd/conf.d").with(
        'ensure'  => 'directory',
        'recurse' => 'true',
        'purge'   => 'true',
        'notify'  => 'Service[httpd]',
        'require' => 'Package[httpd]'
      ) }
      it { should_not contain_file("/etc/httpd/site.d") }
      it { should_not contain_file("/etc/httpd/mod.d") }
      it { should contain_file("/etc/httpd/conf/httpd.conf").with_content %r{^Include /etc/httpd/conf\.d/\*\.conf$} }
      it { should contain_file("/etc/httpd/conf/httpd.conf").with_content %r{^Include /etc/httpd/conf\.d/\*\.load$} }
    end

    describe "Alternate conf.d directory" do
      let :params do
        { :confd_dir => '/etc/httpd/special_conf.d' }
      end

      it { should contain_file("/etc/httpd/special_conf.d").with(
        'ensure'  => 'directory',
        'recurse' => 'true',
        'purge'   => 'true',
        'notify'  => 'Service[httpd]',
        'require' => 'Package[httpd]'
      ) }
      it { should_not contain_file("/etc/httpd/conf.d") }
    end
  end
end
