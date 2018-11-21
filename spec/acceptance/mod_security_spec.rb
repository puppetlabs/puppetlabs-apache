require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'apache::mod::security class', unless: (fact('osfamily') == 'Debian' && (fact('lsbdistcodename') == 'squeeze' ||
                                                fact('lsbdistcodename') == 'lucid' || fact('lsbdistcodename') == 'precise' ||
                                                fact('lsbdistcodename') == 'wheezy')) || (fact('operatingsystem') == 'SLES' && fact('operatingsystemrelease') < '11') do
  context 'default mod_security config' do
    if fact('osfamily') == 'RedHat' && fact('operatingsystemmajrelease') =~ %r{(5|6)}
      pp_one = "class { 'epel': }"
      it 'adds epel' do
        apply_manifest(pp_one, catch_failures: true)
      end
    elsif fact('osfamily') == 'RedHat' && fact('operatingsystemmajrelease') == '7'
      pp_two = <<-MANIFEST
          ini_setting { 'obsoletes':
            path    => '/etc/yum.conf',
            section => 'main',
            setting => 'obsoletes',
            value   => '0',
          }
      MANIFEST
      it 'changes obsoletes, per PUP-4497' do
        apply_manifest(pp_two, catch_failures: true)
      end
    end

    pp_three = <<-MANIFEST
        host { 'modsec.example.com': ip => '127.0.0.1', }
        class { 'apache': }
        class { 'apache::mod::security': }
        apache::vhost { 'modsec.example.com':
          port    => '80',
          docroot => '#{$doc_root}/html',
        }
        file { '#{$doc_root}/html/index.html':
          ensure  => file,
          content => 'Index page',
        }
    MANIFEST
    it 'succeeds in puppeting mod_security' do
      apply_manifest(pp_three, catch_failures: true)

      # Need to add a short sleep here because on RHEL6 the service takes a bit longer to init
      if fact('osfamily') == 'RedHat' && fact('operatingsystemmajrelease') =~ %r{(5|6)}
        sleep 5
      end
    end

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    describe package($package_name) do
      it { is_expected.to be_installed }
    end

    describe file("#{$mod_dir}/security.conf") do
      it { is_expected.to contain 'mod_security2.c' }
    end

    describe 'should be listening on port 80' do
      it 'returns index page #stdout' do
        shell('/usr/bin/curl -A beaker modsec.example.com:80') do |r|
          expect(r.stdout).to match(%r{Index page})
        end
      end
      it 'returns index page #exit_code' do
        shell('/usr/bin/curl -A beaker modsec.example.com:80') do |r|
          expect(r.exit_code).to eq(0)
        end
      end

      unless fact('operatingsystem') == 'SLES' ||
             (fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '9')
        it 'blocks query with SQL' do
          shell '/usr/bin/curl -A beaker -f modsec.example.com:80?SELECT%20*FROM%20mysql.users', acceptable_exit_codes: [22]
        end
      end
    end
  end # default mod_security config

  context 'mod_security should allow disabling by vhost' do
    pp_one = <<-MANIFEST
        host { 'modsec.example.com': ip => '127.0.0.1', }
        class { 'apache': }
        class { 'apache::mod::security': }
        apache::vhost { 'modsec.example.com':
          port    => '80',
          docroot => '#{$doc_root}/html',
        }
        file { '#{$doc_root}/html/index.html':
          ensure  => file,
          content => 'Index page',
        }
    MANIFEST
    it 'succeeds in puppeting mod_security' do
      apply_manifest(pp_one, catch_failures: true)
    end

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    describe file("#{$mod_dir}/security.conf") do
      it { is_expected.to contain 'mod_security2.c' }
    end

    unless fact('operatingsystem') == 'SLES' ||
           (fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '9')
      it 'blocks query with SQL' do
        shell '/usr/bin/curl -A beaker -f modsec.example.com:80?SELECT%20*FROM%20mysql.users', acceptable_exit_codes: [22]
      end
    end

    pp_two = <<-MANIFEST
        class { 'apache': }
        class { 'apache::mod::security': }
        apache::vhost { 'modsec.example.com':
          port                 => '80',
          docroot              => '#{$doc_root}/html',
          modsec_disable_vhost => true,
        }
    MANIFEST
    it 'disables mod_security per vhost' do
      apply_manifest(pp_two, catch_failures: true)
    end

    it 'returns index page #stdout' do
      shell('/usr/bin/curl -A beaker -f modsec.example.com:80?SELECT%20*FROM%20mysql.users') do |r|
        expect(r.stdout).to match(%r{Index page})
      end
    end
    it 'returns index page #exit_code' do
      shell('/usr/bin/curl -A beaker -f modsec.example.com:80?SELECT%20*FROM%20mysql.users') do |r|
        expect(r.exit_code).to eq(0)
      end
    end
  end # mod_security should allow disabling by vhost

  context 'mod_security should allow disabling by ip' do
    pp_one = <<-MANIFEST
        host { 'modsec.example.com': ip => '127.0.0.1', }
        class { 'apache': }
        class { 'apache::mod::security': }
        apache::vhost { 'modsec.example.com':
          port    => '80',
          docroot => '#{$doc_root}/html',
        }
        file { '#{$doc_root}/html/index.html':
          ensure  => file,
          content => 'Index page',
        }
    MANIFEST
    it 'succeeds in puppeting mod_security' do
      apply_manifest(pp_one, catch_failures: true)
    end

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    describe file("#{$mod_dir}/security.conf") do
      it { is_expected.to contain 'mod_security2.c' }
    end

    unless  fact('operatingsystem') == 'SLES' ||
            (fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '9')
      it 'blocks query with SQL' do
        shell '/usr/bin/curl -A beaker -f modsec.example.com:80?SELECT%20*FROM%20mysql.users', acceptable_exit_codes: [22]
      end
    end

    pp_two = <<-MANIFEST
        class { 'apache': }
        class { 'apache::mod::security': }
        apache::vhost { 'modsec.example.com':
          port               => '80',
          docroot            => '#{$doc_root}/html',
          modsec_disable_ips => [ '127.0.0.1' ],
        }
    MANIFEST
    it 'disables mod_security per vhost' do
      apply_manifest(pp_two, catch_failures: true)
    end

    it 'returns index page #stdout' do
      shell('/usr/bin/curl -A beaker modsec.example.com:80') do |r|
        expect(r.stdout).to match(%r{Index page})
      end
    end
    it 'returns index page #exit_code' do
      shell('/usr/bin/curl -A beaker modsec.example.com:80') do |r|
        expect(r.exit_code).to eq(0)
      end
    end
  end # mod_security should allow disabling by ip

  context 'mod_security should allow disabling by id' do
    pp_one = <<-MANIFEST
        host { 'modsec.example.com': ip => '127.0.0.1', }
        class { 'apache': }
        class { 'apache::mod::security': }
        apache::vhost { 'modsec.example.com':
          port    => '80',
          docroot => '#{$doc_root}/html',
        }
        file { '#{$doc_root}/html/index.html':
          ensure  => file,
          content => 'Index page',
        }
        file { '#{$doc_root}/html/index2.html':
          ensure  => file,
          content => 'Page 2',
        }
    MANIFEST
    it 'succeeds in puppeting mod_security' do
      apply_manifest(pp_one, catch_failures: true)
    end

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    describe file("#{$mod_dir}/security.conf") do
      it { is_expected.to contain 'mod_security2.c' }
    end

    unless  fact('operatingsystem') == 'SLES' ||
            (fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '9')
      it 'blocks query with SQL' do
        shell '/usr/bin/curl -A beaker -f modsec.example.com:80?SELECT%20*FROM%20mysql.users', acceptable_exit_codes: [22]
      end
    end

    pp_two = <<-MANIFEST
        class { 'apache': }
        class { 'apache::mod::security': }
        apache::vhost { 'modsec.example.com':
          port               => '80',
          docroot            => '#{$doc_root}/html',
          modsec_disable_ids => [ '950007' ],
        }
    MANIFEST
    it 'disables mod_security per vhost' do
      apply_manifest(pp_two, catch_failures: true)
    end

    it 'returns index page #stdout' do
      shell('/usr/bin/curl -A beaker -f modsec.example.com:80?SELECT%20*FROM%20mysql.users') do |r|
        expect(r.stdout).to match(%r{Index page})
      end
    end
    it 'returns index page #exit_code' do
      shell('/usr/bin/curl -A beaker -f modsec.example.com:80?SELECT%20*FROM%20mysql.users') do |r|
        expect(r.exit_code).to eq(0)
      end
    end
  end # mod_security should allow disabling by id

  context 'mod_security should allow disabling by msg' do
    pp_one = <<-MANIFEST
        host { 'modsec.example.com': ip => '127.0.0.1', }
        class { 'apache': }
        class { 'apache::mod::security': }
        apache::vhost { 'modsec.example.com':
          port    => '80',
          docroot => '#{$doc_root}/html',
        }
        file { '#{$doc_root}/html/index.html':
          ensure  => file,
          content => 'Index page',
        }
        file { '#{$doc_root}/html/index2.html':
          ensure  => file,
          content => 'Page 2',
        }
    MANIFEST
    it 'succeeds in puppeting mod_security' do
      apply_manifest(pp_one, catch_failures: true)
    end

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    describe file("#{$mod_dir}/security.conf") do
      it { is_expected.to contain 'mod_security2.c' }
    end

    unless  fact('operatingsystem') == 'SLES' ||
            (fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '9')
      it 'blocks query with SQL' do
        shell '/usr/bin/curl -A beaker -f modsec.example.com:80?SELECT%20*FROM%20mysql.users', acceptable_exit_codes: [22]
      end
    end

    pp_two = <<-MANIFEST
        class { 'apache': }
        class { 'apache::mod::security': }
        apache::vhost { 'modsec.example.com':
          port               => '80',
          docroot            => '#{$doc_root}/html',
          modsec_disable_msgs => [ 'Blind SQL Injection Attack' ],
        }
    MANIFEST
    it 'disables mod_security per vhost' do
      apply_manifest(pp_two, catch_failures: true)
    end

    it 'returns index page #stdout' do
      shell('/usr/bin/curl -A beaker -f modsec.example.com:80?SELECT%20*FROM%20mysql.users') do |r|
        expect(r.stdout).to match(%r{Index page})
      end
    end
    it 'returns index page #exit_code' do
      shell('/usr/bin/curl -A beaker -f modsec.example.com:80?SELECT%20*FROM%20mysql.users') do |r|
        expect(r.exit_code).to eq(0)
      end
    end
  end # mod_security should allow disabling by msg

  context 'mod_security should allow disabling by tag' do
    pp_one = <<-MANIFEST
        host { 'modsec.example.com': ip => '127.0.0.1', }
        class { 'apache': }
        class { 'apache::mod::security': }
        apache::vhost { 'modsec.example.com':
          port    => '80',
          docroot => '#{$doc_root}/html',
        }
        file { '#{$doc_root}/html/index.html':
          ensure  => file,
          content => 'Index page',
        }
        file { '#{$doc_root}/html/index2.html':
          ensure  => file,
          content => 'Page 2',
        }
    MANIFEST
    it 'succeeds in puppeting mod_security' do
      apply_manifest(pp_one, catch_failures: true)
    end

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    describe file("#{$mod_dir}/security.conf") do
      it { is_expected.to contain 'mod_security2.c' }
    end

    unless  fact('operatingsystem') == 'SLES' ||
            (fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '9')
      it 'blocks query with SQL' do
        shell '/usr/bin/curl -A beaker -f modsec.example.com:80?SELECT%20*FROM%20mysql.users', acceptable_exit_codes: [22]
      end
    end

    pp_two = <<-MANIFEST
        class { 'apache': }
        class { 'apache::mod::security': }
        apache::vhost { 'modsec.example.com':
          port                => '80',
          docroot             => '#{$doc_root}/html',
          modsec_disable_tags => [ 'WEB_ATTACK/SQL_INJECTION' ],
        }
    MANIFEST
    it 'disables mod_security per vhost' do
      apply_manifest(pp_two, catch_failures: true)
    end

    it 'returns index page #stdout' do
      shell('/usr/bin/curl -A beaker -f modsec.example.com:80?SELECT%20*FROM%20mysql.users') do |r|
        expect(r.stdout).to match(%r{Index page})
      end
    end
    it 'returns index page #exit_code' do
      shell('/usr/bin/curl -A beaker -f modsec.example.com:80?SELECT%20*FROM%20mysql.users') do |r|
        expect(r.exit_code).to eq(0)
      end
    end
  end # mod_security should allow disabling by tag
end # apache::mod::security class
