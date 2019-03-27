require 'spec_helper_acceptance'
require_relative './version.rb'

unless host_inventory['facter']['os']['name'] == 'SLES' && os[:release].to_i >= 12
  describe 'apache::mod::php class' do
    context 'default php config' do
      pp = <<-MANIFEST
          class { 'apache':
            mpm_module => 'prefork',
          }
          class { 'apache::mod::php': }
          apache::vhost { 'php.example.com':
            port    => '80',
            docroot => '#{$doc_root}/php',
          }
          host { 'php.example.com': ip => '127.0.0.1', }
          file { '#{$doc_root}/php/index.php':
            ensure  => file,
            content => "<?php phpinfo(); ?>\\n",
          }
      MANIFEST
      it 'succeeds in puppeting php' do
        apply_manifest(pp, catch_failures: true)
      end

      if (host_inventory['facter']['os']['name'] == 'Ubuntu' && host_inventory['facter']['os']['release']['full'] == '16.04') ||
         (host_inventory['facter']['os']['name'] == 'Debian' && os[:release].to_i == 9)
        describe file("#{$mod_dir}/php7.0.conf") do
          it { is_expected.to contain 'DirectoryIndex index.php' }
        end
      elsif host_inventory['facter']['os']['name'] == 'Ubuntu' && host_inventory['facter']['os']['release']['full'] == '18.04'
        describe file("#{$mod_dir}/php7.2.conf") do
          it { is_expected.to contain 'DirectoryIndex index.php' }
        end
      else
        describe file("#{$mod_dir}/php5.conf") do
          it { is_expected.to contain 'DirectoryIndex index.php' }
        end
      end
    end

    context 'custom extensions, php_flag, php_value, php_admin_flag, and php_admin_value' do
      pp = <<-MANIFEST
          class { 'apache':
            mpm_module => 'prefork',
          }
           class { 'apache::mod::php':
           extensions => ['.php','.php5'],
         }

          apache::vhost { 'php.example.com':
            port             => '80',
            docroot          => '#{$doc_root}/php',
            php_values       => { 'include_path' => '.:/usr/share/pear:/usr/bin/php', },
            php_flags        => { 'display_errors' => 'on', },
            php_admin_values => { 'open_basedir' => '/var/www/php/:/usr/share/pear/', },
            php_admin_flags  => { 'engine' => 'on', },
          }
          host { 'php.example.com': ip => '127.0.0.1', }
          file { '#{$doc_root}/php/index.php5':
            ensure  => file,
            content => "<?php phpinfo(); ?>\\n",
          }
      MANIFEST
      it 'succeeds in puppeting php' do
        apply_manifest(pp, catch_failures: true)
      end

      describe file("#{$vhost_dir}/25-php.example.com.conf") do
        it { is_expected.to contain '  php_flag display_errors on' }
        it { is_expected.to contain '  php_value include_path ".:/usr/share/pear:/usr/bin/php"' }
        it { is_expected.to contain '  php_admin_flag engine on' }
        it { is_expected.to contain '  php_admin_value open_basedir /var/www/php/:/usr/share/pear/' }
      end
    end
  end
end
