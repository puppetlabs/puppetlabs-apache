require 'spec_helper'

describe 'apache::mod::jk', :type => :class do
  it_behaves_like 'a mod class, without including apache'

  shared_examples 'minimal resources' do
    it { is_expected.to compile }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to create_class('apache::mod::jk') }
    it { is_expected.to contain_class('apache') }
    it { is_expected.to contain_apache__mod('jk') }
    it { is_expected.to contain_file('jk.conf').that_notifies('Class[apache::service]') }
  end

  default_ip = '192.168.1.1'
  default_port = '80'
  altern8_port = '8008'

  context "RHEL 6 with only required facts and default parameters" do

    let (:facts) do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6',
        :ipaddress              => default_ip,
      }
    end

    let (:pre_condition) do
      'include apache'
    end

    let (:params) do
      {
        :logroot => '/var/log/httpd',
      }
    end

    it_behaves_like 'minimal resources'
    it { is_expected.to contain_apache__listen("#{default_ip}:#{default_port}") }
    it {
      verify_contents(catalogue, 'jk.conf', ['<IfModule jk_module>', '</IfModule>'])
    }

  end

  context "Debian 8 with only required facts and default parameters" do

    let (:facts) do
      {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '8',
        :ipaddress              => default_ip,
      }
    end

    let (:pre_condition) do
      'include apache'
    end

    let (:params) do
      {
        :logroot => '/var/log/apache2',
      }
    end

    it_behaves_like 'minimal resources'
    it { is_expected.to contain_apache__listen("#{default_ip}:#{default_port}") }
    it {
      verify_contents(catalogue, 'jk.conf', ['<IfModule jk_module>', '</IfModule>'])
    }

  end

  context "RHEL 6 with required facts and alternative port" do

    let (:facts) do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6',
        :ipaddress              => default_ip,
      }
    end

    let (:pre_condition) do
      'include apache'
    end

    let (:params) do
      {
        :port    => altern8_port,
        :logroot => '/var/log/httpd',
      }
    end

    it { is_expected.to contain_apache__listen("#{default_ip}:#{altern8_port}") }

  end

  context "RHEL 6 with required facts and no binding" do

    let (:facts) do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6',
        :ipaddress              => default_ip,
      }
    end

    let (:pre_condition) do
      'include apache'
    end

    let (:params) do
      {
        :add_listen => false,
        :logroot    => '/var/log/httpd',
      }
    end

    it { is_expected.not_to contain_apache__listen("#{default_ip}:#{default_port}") }

  end

end
