require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'apache parameters' do
  # Currently this test only does something on FreeBSD.
  describe 'default_confd_files => false' do
    it 'doesnt do anything' do
      pp = "class { 'apache': default_confd_files => false }"
      apply_manifest(pp, catch_failures: true)
    end

    if fact('osfamily') == 'FreeBSD'
      describe file("#{$confd_dir}/no-accf.conf.erb") do
        it { is_expected.not_to be_file }
      end
    end
  end
  describe 'default_confd_files => true' do
    it 'copies conf.d files' do
      pp = "class { 'apache': default_confd_files => true }"
      apply_manifest(pp, catch_failures: true)
    end

    if fact('osfamily') == 'FreeBSD'
      describe file("#{$confd_dir}/no-accf.conf.erb") do
        it { is_expected.to be_file }
      end
    end
  end

  describe 'when set adds a listen statement' do
    it 'applys cleanly' do
      pp = "class { 'apache': ip => '10.1.1.1', service_ensure => stopped }"
      apply_manifest(pp, catch_failures: true)
    end

    describe file($ports_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Listen 10.1.1.1' }
    end
  end

  describe 'service tests => true' do
    pp = <<-MANIFEST
        class { 'apache':
          service_enable => true,
          service_manage => true,
          service_ensure => running,
        }
    MANIFEST
    it 'starts the service' do
      apply_manifest(pp, catch_failures: true)
    end

    describe service($service_name) do
      it { is_expected.to be_running }
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
    end
  end

  describe 'service tests => false' do
    pp = <<-MANIFEST
        class { 'apache':
          service_enable => false,
          service_ensure => stopped,
        }
    MANIFEST
    it 'stops the service' do
      apply_manifest(pp, catch_failures: true)
    end

    describe service($service_name) do
      it { is_expected.not_to be_running }
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.not_to be_enabled }
      end
    end
  end

  describe 'service manage => false' do
    pp = <<-MANIFEST
        class { 'apache':
          service_enable => true,
          service_manage => false,
          service_ensure => true,
        }
    MANIFEST
    it 'we dont manage the service, so it shouldnt start the service' do
      apply_manifest(pp, catch_failures: true)
    end

    describe service($service_name) do
      it { is_expected.not_to be_running }
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.not_to be_enabled }
      end
    end
  end

  describe 'purge parameters => false' do
    pp = <<-MANIFEST
        class { 'apache':
          purge_configs   => false,
          purge_vhost_dir => false,
          vhost_dir       => "#{$confd_dir}.vhosts"
        }
    MANIFEST
    it 'applies cleanly' do
      shell("touch #{$confd_dir}/test.conf")
      shell("mkdir -p #{$confd_dir}.vhosts && touch #{$confd_dir}.vhosts/test.conf")
      apply_manifest(pp, catch_failures: true)
    end

    # Ensure the files didn't disappear.
    describe file("#{$confd_dir}/test.conf") do
      it { is_expected.to be_file }
    end
    describe file("#{$confd_dir}.vhosts/test.conf") do
      it { is_expected.to be_file }
    end
  end

  if fact('osfamily') != 'Debian'
    describe 'purge parameters => true' do
      pp = <<-MANIFEST
          class { 'apache':
            purge_configs   => true,
            purge_vhost_dir => true,
            vhost_dir       => "#{$confd_dir}.vhosts"
          }
      MANIFEST
      it 'applies cleanly' do
        shell("touch #{$confd_dir}/test.conf")
        shell("mkdir -p #{$confd_dir}.vhosts && touch #{$confd_dir}.vhosts/test.conf")
        apply_manifest(pp, catch_failures: true)
      end

      # File should be gone
      describe file("#{$confd_dir}/test.conf") do
        it { is_expected.not_to be_file }
      end
      describe file("#{$confd_dir}.vhosts/test.conf") do
        it { is_expected.not_to be_file }
      end
    end
  end

  describe 'serveradmin' do
    it 'applies cleanly' do
      pp = "class { 'apache': serveradmin => 'test@example.com' }"
      apply_manifest(pp, catch_failures: true)
    end

    describe file($vhost) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ServerAdmin test@example.com' }
    end
  end

  describe 'sendfile' do
    describe 'setup' do
      it 'applies cleanly' do
        pp = "class { 'apache': sendfile => 'On' }"
        apply_manifest(pp, catch_failures: true)
      end
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'EnableSendfile On' }
    end

    describe 'setup' do
      it 'applies cleanly' do
        pp = "class { 'apache': sendfile => 'Off' }"
        apply_manifest(pp, catch_failures: true)
      end
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Sendfile Off' }
    end
  end

  describe 'error_documents' do
    describe 'setup' do
      it 'applies cleanly' do
        pp = "class { 'apache': error_documents => true }"
        apply_manifest(pp, catch_failures: true)
      end
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Alias /error/' }
    end
  end

  describe 'timeout' do
    describe 'setup' do
      it 'applies cleanly' do
        pp = "class { 'apache': timeout => '1234' }"
        apply_manifest(pp, catch_failures: true)
      end
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Timeout 1234' }
    end
  end

  describe 'httpd_dir' do
    describe 'setup' do
      pp = <<-MANIFEST
          class { 'apache': httpd_dir => '/tmp', service_ensure => stopped }
          include 'apache::mod::mime'
      MANIFEST
      it 'applies cleanly' do
        apply_manifest(pp, catch_failures: true)
      end
    end

    describe file("#{$mod_dir}/mime.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'AddLanguage eo .eo' }
    end
  end

  describe 'http_protocol_options' do
    # Actually >= 2.4.24, but the minor version is not provided
    # https://bugs.launchpad.net/ubuntu/+source/apache2/2.4.7-1ubuntu4.15
    # basically versions of the ubuntu or sles  apache package cause issue
    if $apache_version >= '2.4' && fact('operatingsystem') !~ %r{Ubuntu|SLES}
      describe 'setup' do
        it 'applies cleanly' do
          pp = "class { 'apache': http_protocol_options => 'Unsafe RegisteredMethods Require1.0'}"
          apply_manifest(pp, catch_failures: true)
        end
      end

      describe file($conf_file) do
        it { is_expected.to be_file }
        it { is_expected.to contain 'HttpProtocolOptions Unsafe RegisteredMethods Require1.0' }
      end
    end
  end

  describe 'server_root' do
    describe 'setup' do
      it 'applies cleanly' do
        pp = "class { 'apache': server_root => '/tmp/root', service_ensure => stopped }"
        apply_manifest(pp, catch_failures: true)
      end
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ServerRoot "/tmp/root"' }
    end
  end

  describe 'confd_dir' do
    describe 'setup' do
      it 'applies cleanly' do
        pp = "class { 'apache': confd_dir => '/tmp/root', service_ensure => stopped, use_optional_includes => true }"
        apply_manifest(pp, catch_failures: true)
      end
    end

    if $apache_version == '2.4'
      describe file($conf_file) do
        it { is_expected.to be_file }
        it { is_expected.to contain 'IncludeOptional "/tmp/root/*.conf"' }
      end
    else
      describe file($conf_file) do
        it { is_expected.to be_file }
        it { is_expected.to contain 'Include "/tmp/root/*.conf"' }
      end
    end
  end

  describe 'conf_template' do
    describe 'setup' do
      it 'applies cleanly' do
        pp = "class { 'apache': conf_template => 'another/test.conf.erb', service_ensure => stopped }"
        shell("mkdir -p #{default['distmoduledir']}/another/templates")
        shell("echo 'testcontent' >> #{default['distmoduledir']}/another/templates/test.conf.erb")
        apply_manifest(pp, catch_failures: true)
      end
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'testcontent' }
    end
  end

  describe 'servername' do
    describe 'setup' do
      it 'applies cleanly' do
        pp = "class { 'apache': servername => 'test.server', service_ensure => stopped }"
        apply_manifest(pp, catch_failures: true)
      end
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ServerName "test.server"' }
    end
  end

  describe 'user' do
    describe 'setup' do
      pp = <<-MANIFEST
          class { 'apache':
            manage_user  => true,
            manage_group => true,
            user         => 'testweb',
            group        => 'testweb',
          }
      MANIFEST
      it 'applies cleanly' do
        apply_manifest(pp, catch_failures: true)
      end
    end

    describe user('testweb') do
      it { is_expected.to exist }
      it { is_expected.to belong_to_group 'testweb' }
    end

    describe group('testweb') do
      it { is_expected.to exist }
    end
  end

  describe 'logformats' do
    describe 'setup' do
      pp = <<-MANIFEST
          class { 'apache':
            log_formats => {
              'vhost_common'   => '%v %h %l %u %t \\\"%r\\\" %>s %b',
              'vhost_combined' => '%v %h %l %u %t \\\"%r\\\" %>s %b \\\"%{Referer}i\\\" \\\"%{User-agent}i\\\"',
            }
          }
      MANIFEST
      it 'applies cleanly' do
        apply_manifest(pp, catch_failures: true)
      end
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'LogFormat "%v %h %l %u %t \"%r\" %>s %b" vhost_common' }
      it { is_expected.to contain 'LogFormat "%v %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"" vhost_combined' }
    end
  end

  describe 'keepalive' do
    describe 'setup' do
      it 'applies cleanly' do
        pp = "class { 'apache': keepalive => 'Off', keepalive_timeout => '30', max_keepalive_requests => '200' }"
        apply_manifest(pp, catch_failures: true)
      end
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'KeepAlive Off' }
      it { is_expected.to contain 'KeepAliveTimeout 30' }
      it { is_expected.to contain 'MaxKeepAliveRequests 200' }
    end
  end

  describe 'limitrequestfieldsize' do
    describe 'setup' do
      it 'applies cleanly' do
        pp = "class { 'apache': limitreqfieldsize => '16830' }"
        apply_manifest(pp, catch_failures: true)
      end
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'LimitRequestFieldSize 16830' }
    end
  end

  describe 'limitrequestfields' do
    describe 'setup' do
      it 'applies cleanly' do
        pp = "class { 'apache': limitreqfields => '120' }"
        apply_manifest(pp, catch_failures: true)
      end
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'LimitRequestFields 120' }
    end
  end

  describe 'logging' do
    describe 'setup' do
      pp = <<-MANIFEST
          if $::osfamily == 'RedHat' and "$::selinux" == "true" {
            $semanage_package = $::operatingsystemmajrelease ? {
              '5'     => 'policycoreutils',
              default => 'policycoreutils-python',
            }

            package { $semanage_package: ensure => installed }
            exec { 'set_apache_defaults':
              command => 'semanage fcontext -a -t httpd_log_t "/apache_spec(/.*)?"',
              path    => '/bin:/usr/bin/:/sbin:/usr/sbin',
              require => Package[$semanage_package],
            }
            exec { 'restorecon_apache':
              command => 'restorecon -Rv /apache_spec',
              path    => '/bin:/usr/bin/:/sbin:/usr/sbin',
              before  => Service['httpd'],
              require => Class['apache'],
            }
          }
          file { '/apache_spec': ensure => directory, }
          class { 'apache': logroot => '/apache_spec' }
      MANIFEST
      it 'applies cleanly' do
        apply_manifest(pp, catch_failures: true)
      end
    end

    describe file("/apache_spec/#{$error_log}") do
      it { is_expected.to be_file }
    end
  end

  describe 'ports_file' do
    pp = <<-MANIFEST
        file { '/apache_spec': ensure => directory, }
        class { 'apache':
          ports_file     => '/apache_spec/ports_file',
          ip             => '10.1.1.1',
          service_ensure => stopped
        }
    MANIFEST
    it 'applys cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file('/apache_spec/ports_file') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Listen 10.1.1.1' }
    end
  end

  describe 'server_tokens' do
    pp = <<-MANIFEST
        class { 'apache':
          server_tokens  => 'Minor',
        }
    MANIFEST
    it 'applys cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ServerTokens Minor' }
    end
  end

  describe 'server_signature' do
    pp = <<-MANIFEST
        class { 'apache':
          server_signature  => 'testsig',
          service_ensure    => stopped,
        }
    MANIFEST
    it 'applys cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ServerSignature testsig' }
    end
  end

  describe 'trace_enable' do
    pp = <<-MANIFEST
        class { 'apache':
          trace_enable  => 'Off',
        }
    MANIFEST
    it 'applys cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'TraceEnable Off' }
    end
  end

  describe 'file_e_tag' do
    pp = <<-MANIFEST
        class { 'apache':
          file_e_tag  => 'None',
        }
    MANIFEST
    it 'applys cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file($conf_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'FileETag None' }
    end
  end

  describe 'package_ensure' do
    pp = <<-MANIFEST
        class { 'apache':
          package_ensure  => present,
        }
    MANIFEST
    it 'applys cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe package($package_name) do
      it { is_expected.to be_installed }
    end
  end
end
