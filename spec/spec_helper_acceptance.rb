require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

hosts.each do |host|
  # Install Puppet
  install_package host, 'rubygems'
  on host, 'gem install puppet --no-ri --no-rdoc'
  on host, "mkdir -p #{host['distmoduledir']}"

  # host-specific repositories
  repos = {
    'centos-64-x64' => [
        [
          'http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm' ,
          nil
        ],
        [
          'http://passenger.stealthymonkeys.com/rhel/6/passenger-release.noarch.rpm',
          'http://passenger.stealthymonkeys.com/RPM-GPG-KEY-stealthymonkeys.asc'
        ]
      ]
  }

  host_repos = repos[host.to_s] || []
  host_repos.each do |repo_url,gpg_key|
    puts "configuring #{host}-specific repo #{repo_url.inspect}"
    unless gpg_key.nil?
      shell("rpm --import #{gpg_key}")
    end
    shell("rpm -Uvh #{repo_url}")
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'apache')
    hosts.each do |host|
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-concat'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
