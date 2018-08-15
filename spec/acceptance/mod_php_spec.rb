require 'spec_helper_acceptance'
require_relative './version.rb'

unless fact('operatingsystem') == 'SLES' && fact('operatingsystemmajrelease') == '12'
  describe 'apache::mod::php class' do
    context 'default php config' do
      if ['16.04', '18.04'].include?(fact('operatingsystemmajrelease'))
        # this policy defaults to 101. it prevents newly installed services from starting
        # it is useful for containers, it prevents new processes during 'docker build'
        # but we actually want to test the services and this should not behave like docker
        # but like a normal operating system

        # without this apache fails to start -> installation of mod-php-something fails because it reloads apache to enable the module
        # exit codes are documented at https://askubuntu.com/a/365912. Default for docker images is 101
        shell("if [ -a '/usr/sbin/policy-rc.d' ]; then sed -i 's/^exit.*/exit 0/' /usr/sbin/policy-rc.d; fi")
      end
      if fact('operatingsystemmajrelease') == '18.04'
        # apache helper script has a bug which prevents the installation of certain apache modules
        # https://bugs.launchpad.net/ubuntu/+source/php7.2/+bug/1771934
        # https://bugs.launchpad.net/ubuntu/+source/apache2/+bug/1782806
        pp1 = "class { 'apache': mpm_module => 'prefork',}"
        it 'succeeds in installing apache' do
          apply_manifest(pp1, catch_failures: true)
        end
        it 'fixes the broken apache2 helper from Ubuntu 18.04' do
          shell("sed -i 's|a2query -m \"$mpm_$MPM\"|a2query -m \"mpm_$MPM\"|' /usr/share/apache2/apache2-maintscript-helper")
        end
      end
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

      describe service($service_name) do
        if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
          pending 'Should be enabled - Bug 760616 on Debian 8'
        else
          it { is_expected.to be_enabled }
        end
        it { is_expected.to be_running }
      end

      if fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemmajrelease') == '16.04'
        describe file("#{$mod_dir}/php7.0.conf") do
          it { is_expected.to contain 'DirectoryIndex index.php' }
        end
      elsif fact('operatingsystemmajrelease') == '18.04'
        describe file("#{$mod_dir}/php7.2.conf") do
          it { is_expected.to contain 'DirectoryIndex index.php' }
        end
      else
        describe file("#{$mod_dir}/php5.conf") do
          it { is_expected.to contain 'DirectoryIndex index.php' }
        end
      end

      it 'answers to php.example.com #stdout' do
        shell('/usr/bin/curl php.example.com:80') do |r|
          expect(r.stdout).to match(%r{PHP Version})
        end
      end
      it 'answers to php.example.com #exit_code' do
        shell('/usr/bin/curl php.example.com:80') do |r|
          expect(r.exit_code).to eq(0)
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

      describe service($service_name) do
        if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
          pending 'Should be enabled - Bug 760616 on Debian 8'
        else
          it { is_expected.to be_enabled }
        end
        it { is_expected.to be_running }
      end

      describe file("#{$vhost_dir}/25-php.example.com.conf") do
        it { is_expected.to contain '  php_flag display_errors on' }
        it { is_expected.to contain '  php_value include_path ".:/usr/share/pear:/usr/bin/php"' }
        it { is_expected.to contain '  php_admin_flag engine on' }
        it { is_expected.to contain '  php_admin_value open_basedir /var/www/php/:/usr/share/pear/' }
      end

      it 'answers to php.example.com #stdout' do
        shell('/usr/bin/curl php.example.com:80') do |r|
          expect(r.stdout).to match(%r{\/usr\/share\/pear\/})
        end
      end
      it 'answers to php.example.com #exit_code' do
        shell('/usr/bin/curl php.example.com:80') do |r|
          expect(r.exit_code).to eq(0)
        end
      end
    end

    context 'provide custom config file' do
      pp = <<-MANIFEST
          class {'apache':
            mpm_module => 'prefork',
          }
          class {'apache::mod::php':
            content => '# somecontent',
          }
      MANIFEST
      it 'succeeds in puppeting php' do
        apply_manifest(pp, catch_failures: true)
      end
      path = if fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemmajrelease') == '16.04'
               "#{$mod_dir}/php7.0.conf"
             elsif fact('operatingsystemmajrelease') == '18.04'
               "#{$mod_dir}/php7.2.conf"
             else
               "#{$mod_dir}/php5.conf"
             end
      describe file(path) do
        it { is_expected.to contain '# somecontent' }
      end
    end

    context 'provide content and template config file' do
      # does the following even makes sense? Why do we hardcode the php5 template?
      # I don't see what we gain from this test
      pp = <<-MANIFEST
          class {'apache':
            mpm_module => 'prefork',
          }
          class {'apache::mod::php':
            content  => '# somecontent',
            template => 'apache/mod/php5.conf.erb',
          }
      MANIFEST
      it 'succeeds in puppeting php' do
        apply_manifest(pp, catch_failures: true)
      end

      path = if fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemmajrelease') == '16.04'
               "#{$mod_dir}/php7.0.conf"
             elsif fact('operatingsystemmajrelease') == '18.04'
               "#{$mod_dir}/php7.2.conf"
             else
               "#{$mod_dir}/php5.conf"
             end
      describe file(path) do
        it { is_expected.to contain '# somecontent' }
      end
    end
  end
end
