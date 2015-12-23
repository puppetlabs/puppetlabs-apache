require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'

if ! ENV["PUPPET_DEV_GIT"].nil?
  pr = ENV["PUPPET_DEV_GIT"]
  h = hosts[0]
  configure_foss_defaults_on(h)
  install_package h, 'git'
  if h['platform'] =~ /debian|ubuntu|cumulus/
    install_package h, 'ruby-dev'
    install_package h, 'bundler'
  else
    install_package h, 'ruby-devel'
    install_package h, 'rubygem-bundler'
  end
  on h, "git clone https://github.com/puppetlabs/hiera /tmp/hiera"
  on h, "sudo /tmp/hiera/install.rb --full"
  on h, "gem install facter"
  on h, "git clone https://github.com/puppetlabs/puppet /tmp/puppet"
  on h, "git --git-dir=/tmp/puppet/.git fetch origin pull/#{pr}/head:pr_#{pr}"
  on h, "git --git-dir=/tmp/puppet/.git checkout pr_#{pr}"
  on h, "cd /tmp/puppet; bundle install --path /tmp/puppet/.bundle/gems/"
  on h, "cd /tmp/puppet; bundle exec /tmp/puppet/install.rb --full"
else
  run_puppet_install_helper
end

RSpec.configure do |c|
  # apache on Ubuntu 10.04 and 12.04 doesn't like IPv6 VirtualHosts, so we skip ipv6 tests on those systems
  if fact('operatingsystem') == 'Ubuntu' and (fact('operatingsystemrelease') == '10.04' or fact('operatingsystemrelease') == '12.04')
    c.filter_run_excluding :ipv6 => true
  end

  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # net-tools required for netstat utility being used by be_listening
    if fact('osfamily') == 'RedHat' && fact('operatingsystemmajrelease') == '7'
      pp = <<-EOS
        package { 'net-tools': ensure => installed }
      EOS

      apply_manifest_on(agents, pp, :catch_failures => false)
    end

    if fact('osfamily') == 'Debian'
      # Make sure snake-oil certs are installed.
      shell 'apt-get install -y ssl-cert'
    end

    # Install module and dependencies
    hosts.each do |host|
      puppet_module_install(:source => proj_root, :module_name => 'apache', :target_module_path => '/etc/puppetlabs/code/modules')

      on host, puppet('module','install','puppetlabs-stdlib')
      on host, puppet('module','install','puppetlabs-concat', '--version 1.1.1', '--force')

      # Required for mod_passenger tests.
      if fact('osfamily') == 'RedHat'
        on host, puppet('module','install','stahnma/epel')
        on host, puppet('module','install','puppetlabs/inifile')
      end

      # Required for manifest to make mod_pagespeed repository available
      if fact('osfamily') == 'Debian'
        on host, puppet('module','install','puppetlabs-apt', '--version 1.8.0', '--force')
      end

      # Make sure selinux is disabled so the tests work.
      on host, puppet('apply', '-e',
                        %{"exec { 'setenforce 0': path   => '/bin:/sbin:/usr/bin:/usr/sbin', onlyif => 'which setenforce && getenforce | grep Enforcing', }"})
    end
  end
end
