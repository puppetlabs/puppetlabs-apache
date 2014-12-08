require 'spec_helper'

describe 'apache::mod::wsgi', :type => :class do
  let :pre_condition do
    'include apache'
  end
  context "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :lsbdistcodename        => 'squeeze',
        :operatingsystem        => 'Debian',
        :id                     => 'root',
        :kernel                 => 'Linux',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_class('apache::mod::wsgi').with(
        'wsgi_socket_prefix' => nil
      )
    }
    it { is_expected.to contain_package("libapache2-mod-wsgi") }
  end
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :operatingsystem        => 'RedHat',
        :id                     => 'root',
        :kernel                 => 'Linux',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_class('apache::mod::wsgi').with(
        'wsgi_socket_prefix' => '/var/run/wsgi'
      )
    }
    it { is_expected.to contain_package("mod_wsgi") }

    describe "with custom WSGISocketPrefix" do
      let :params do
        { :wsgi_socket_prefix => 'run/wsgi' }
      end
      it {is_expected.to contain_file('wsgi.conf').with_content(/^  WSGISocketPrefix run\/wsgi$/)}
    end
    describe "with custom WSGIPythonHome" do
      let :params do
        { :wsgi_python_home => '/path/to/virtenv' }
      end
      it {is_expected.to contain_file('wsgi.conf').with_content(/^  WSGIPythonHome "\/path\/to\/virtenv"$/)}
    end
  end
  context "on a FreeBSD OS" do
    let :facts do
      {
        :osfamily               => 'FreeBSD',
        :operatingsystemrelease => '9',
        :concat_basedir         => '/dne',
        :operatingsystem        => 'FreeBSD',
        :id                     => 'root',
        :kernel                 => 'FreeBSD',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_class('apache::mod::wsgi').with(
        'wsgi_socket_prefix' => nil
      )
    }
    it { is_expected.to contain_package("www/mod_wsgi") }
  end
  context "on a Gentoo OS" do
    let :facts do
      {
        :osfamily               => 'Gentoo',
        :operatingsystem        => 'Gentoo',
        :operatingsystemrelease => '3.16.1-gentoo',
        :id                     => 'root',
        :kernel                 => 'Linux',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin',
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_class('apache::mod::wsgi').with(
        'wsgi_socket_prefix' => nil
      )
    }
    it { is_expected.to contain_package("www-apache/mod_wsgi") }
  end
end
