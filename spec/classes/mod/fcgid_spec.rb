require 'spec_helper'

describe 'apache::mod::fcgid' do
  let :pre_condition do
    'include apache'
  end

  context "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    it { should contain_class("apache::params") }
    it { should contain_apache__mod('fcgid') }
    it { should contain_package("libapache2-mod-fcgid") }
  end

  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end

    describe 'without parameters' do
      it { should contain_class("apache::params") }
      it { should contain_apache__mod('fcgid') }
      it { should contain_package("mod_fcgid") }
    end

    describe 'with parameters' do
      let :params do {
        :options                     => {
          'FcgidIPCDir'               => '/var/run/fcgidsock',
          'SharememPath'              => '/var/run/fcgid_shm',
          'FcgidMinProcessesPerClass' => '0',
          'AddHandler'                => 'fcgid-script .fcgi',
        }
      } end

      it 'should contain the correct config' do
        content = subject.resource('file', 'fcgid.conf').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
          '<IfModule mod_fcgid.c>',
          '  AddHandler fcgid-script .fcgi',
          '  FcgidIPCDir /var/run/fcgidsock',
          '  FcgidMinProcessesPerClass 0',
          '  SharememPath /var/run/fcgid_shm',
          '</IfModule>',
        ]
      end
    end
  end

  context "on a FreeBSD OS" do
    let :facts do
      {
        :osfamily               => 'FreeBSD',
        :operatingsystemrelease => '9',
        :concat_basedir         => '/dne',
      }
    end

    it { should contain_class("apache::params") }
    it { should contain_apache__mod('fcgid') }
    it { should contain_package("www/mod_fcgid") }
  end
end
