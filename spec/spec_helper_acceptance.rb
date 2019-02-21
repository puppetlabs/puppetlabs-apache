require 'beaker-pe'
require 'beaker-puppet'
require 'puppet'
require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'
require 'beaker-task_helper'

run_puppet_install_helper
configure_type_defaults_on(hosts)
install_bolt_on(hosts) unless pe_install?
install_module_on(hosts)
install_module_dependencies_on(hosts)

RSpec.configure do |c|
  c.filter_run focus: true
  c.run_all_when_everything_filtered = true
  # IPv6 is not enabled by default in the new travis-ci Trusty environment (see https://github.com/travis-ci/travis-ci/issues/8891 )
  if fact('network6_lo') != '::1'
    c.filter_run_excluding ipv6: true
  end

  # Readable test descriptions
  c.formatter = :documentation

  # detect the situation where PUP-5016 is triggered and skip the idempotency tests in that case
  # also note how fact('puppetversion') is not available because of PUP-4359
  if fact('osfamily') == 'Debian' && fact('operatingsystemmajrelease') == '8' && shell('puppet --version').stdout =~ %r{^4\.2}
    c.filter_run_excluding skip_pup_5016: true
  end

  # Configure all nodes in nodeset
  c.before :suite do
    run_puppet_access_login(user: 'admin') if pe_install? && (Gem::Version.new(puppet_version) >= Gem::Version.new('5.0.0'))
    # net-tools required for netstat utility being used by be_listening
    if (fact('osfamily') == 'RedHat' && fact('operatingsystemmajrelease') == '7') ||
       (fact('osfamily') == 'Debian' && fact('operatingsystemmajrelease') == '9') ||
       (fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemmajrelease') == '18.04')
      pp = <<-EOS
        package { 'net-tools': ensure => installed }
      EOS

      apply_manifest_on(agents, pp, catch_failures: false)
    elsif fact('operatingsystem') == 'SLES' && fact('operatingsystemmajrelease') == '15'
      pp = <<-EOS
        package { 'net-tools-deprecated': ensure => installed }
      EOS

      apply_manifest_on(agents, pp, catch_failures: false)
    end

    if fact('osfamily') == 'Debian'
      # Make sure snake-oil certs are installed.
      shell 'apt-get install -y ssl-cert'
    end

    # Install module and dependencies
    hosts.each do |host|
      # Required for mod_passenger tests.
      if fact('osfamily') == 'RedHat'
        on host, puppet('module', 'install', 'stahnma/epel')
        on host, puppet('module', 'install', 'puppetlabs/inifile')
        # we need epel installed, so we can get plugins, wsgi, mime ...
        pp = <<-EOS
          class { 'epel': }
        EOS

        apply_manifest_on(host, pp, catch_failures: true)
      end

      # Required for manifest to make mod_pagespeed repository available
      if fact('osfamily') == 'Debian'
        on host, puppet('module', 'install', 'puppetlabs-apt')
      end

      # Make sure selinux is disabled so the tests work.
      on host, puppet('apply', '-e',
                      %("exec { 'setenforce 0': path   => '/bin:/sbin:/usr/bin:/usr/sbin', onlyif => 'which setenforce && getenforce | grep Enforcing', }"))
    end
  end
end

shared_examples 'a idempotent resource' do
  it 'applies with no errors' do
    apply_manifest(pp, catch_failures: true)
  end

  it 'applies a second time without changes', :skip_pup_5016 do
    apply_manifest(pp, catch_changes: true)
  end
end
