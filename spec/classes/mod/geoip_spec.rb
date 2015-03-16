require 'spec_helper'

describe 'apache::mod::geoip', :type => :class do
  let :pre_condition do
    [
      'include apache',
    ]
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
        :is_pe                  => false,
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod('geoip') }
    it { is_expected.to contain_file("geoip.conf").with_ensure('present') }
    it { is_expected.to contain_file("geoip.conf").with({
      'path' => '/etc/apache2/mods-available/geoip.conf',
    } )}
    it { is_expected.to contain_file("geoip.conf symlink").with_ensure('link') }
    describe "enable geoip" do
      let :params do
        { :enabled => true }
      end
      it { is_expected.to contain_file("geoip.conf").with_content(/^GeoIPEnable On$/) }
    end
    describe "disable geoip" do
      let :params do
        { :enabled => false }
      end
      it { is_expected.to contain_file("geoip.conf").with_content(/^GeoIPEnable Off$/) }
    end
    describe "with db_file => /usr/share/GeoIP/GeoIP.dat" do
      let :params do
        { :db_file => "/usr/share/GeoIP/GeoIP.dat" }
      end
     it { is_expected.to contain_file("geoip.conf").with_content(/^GeoIPDBFile \/usr\/share\/GeoIP\/GeoIP.dat$/) }
    end
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
        :is_pe                  => false,
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod('geoip') }
    it { is_expected.to contain_file("geoip.conf").with_ensure('present') }
    it { is_expected.to contain_file("geoip.conf").with({
      'path' => '/etc/httpd/conf.d/geoip.conf',
    } )}
    describe "enable geoip" do
      let :params do
        { :enabled => true }
      end
      it { is_expected.to contain_file("geoip.conf").with_content(/^GeoIPEnable On$/) }
    end
    describe "disable geoip" do
      let :params do
        { :enabled => false }
      end
      it { is_expected.to contain_file("geoip.conf").without_content(/^GeoIPEnable [.]+$/) }
    end
    describe "with db_file => /usr/share/GeoIP/GeoIP.dat" do
      let :params do
        { :db_file => "/usr/share/GeoIP/GeoIP.dat" }
      end
     it { is_expected.to contain_file("geoip.conf").with_content(/^GeoIPDBFile \/usr\/share\/GeoIP\/GeoIP.dat$/) }
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
        :is_pe                  => false,
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod('geoip') }
    it { is_expected.to contain_file("geoip.conf").with_ensure('present') }
    it { is_expected.to contain_file("geoip.conf").with({
      'path' => '/usr/local/etc/apache24/Modules/geoip.conf',
    } )}
    describe "enable geoip" do
      let :params do
        { :enabled => true }
      end
      it { is_expected.to contain_file("geoip.conf").with_content(/^GeoIPEnable On$/) }
    end
    describe "disable geoip" do
      let :params do
        { :enabled => false }
      end
      it { is_expected.to contain_file("geoip.conf").without_content(/^GeoIPEnable [.]+$/) }
    end
    describe "with db_file => /usr/share/GeoIP/GeoIP.dat" do
      let :params do
        { :db_file => "/usr/share/GeoIP/GeoIP.dat" }
      end
     it { is_expected.to contain_file("geoip.conf").with_content(/^GeoIPDBFile \/usr\/share\/GeoIP\/GeoIP.dat$/) }
    end
  end
  context "on a Gentoo OS" do
    let :facts do
      {
        :osfamily               => 'Gentoo',
        :operatingsystem        => 'Gentoo',
        :operatingsystemrelease => '3.16.1-gentoo',
        :concat_basedir         => '/dne',
        :id                     => 'root',
        :kernel                 => 'Linux',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin',
        :is_pe                  => false,
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod('geoip') }
    it { is_expected.to contain_file("geoip.conf").with_ensure('present') }
    it { is_expected.to contain_file("geoip.conf").with({
      'path' => '/etc/apache2/modules.d/geoip.conf',
    } )}
    describe "enable geoip" do
      let :params do
        { :enabled => true }
      end
      it { is_expected.to contain_file("geoip.conf").with_content(/^GeoIPEnable On$/) }
    end
    describe "disable geoip" do
      let :params do
        { :enabled => false }
      end
      it { is_expected.to contain_file("geoip.conf").without_content(/^GeoIPEnable [.]+$/) }
    end
    describe "with db_file => /usr/share/GeoIP/GeoIP.dat" do
      let :params do
        { :db_file => "/usr/share/GeoIP/GeoIP.dat" }
      end
     it { is_expected.to contain_file("geoip.conf").with_content(/^GeoIPDBFile \/usr\/share\/GeoIP\/GeoIP.dat$/) }
    end
  end
end
