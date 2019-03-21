# "zzz_" got added to ensure, this test runs last, as it breaks the non-SCL httpd in later tests
require 'spec_helper_acceptance'

describe 'CentOS with SCL enabled', if: (host_inventory['facter']['os']['name'] == 'centos' && os[:release].to_i != 5) do
  context 'when setting the respective parameters' do
    pp = <<-MANIFEST
      package { 'centos-release-scl-rh':
        ensure => installed,
      }
      host { 'sclphp.example.com':
        ip => '127.0.0.1',
      }
      class { 'apache::version':
        scl_httpd_version => '2.4',
        scl_php_version   => '7.0',
      }
      class { 'apache':
        mpm_module => 'prefork',
      }
      class { 'apache::mod::php': }
      apache::vhost { 'sclphp.example.com':
        port    => '80',
        docroot => '/opt/rh/httpd24/root/var/www/php',
      }
      file { '/opt/rh/httpd24/root/var/www/php/index.php':
        ensure  => file,
        content => "<?php echo 'Hello world'; ?>",
      }
    MANIFEST

    it 'succeeds in puppeting Apache and PHP from SCL' do
      # stop the non-SCL Apache before this test
      shell('service httpd stop')

      apply_manifest(pp, catch_failures: true)
    end

    it 'answers to sclphp.example.com' do
      shell("/usr/bin/curl -H 'Host: sclphp.example.com' 127.0.0.1:80") do |r|
        expect(r.stdout).to eq('Hello world')
        expect(r.exit_code).to eq(0)
      end
    end
  end
end
