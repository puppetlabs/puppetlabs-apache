#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'

def service(action, service_name)
  if service_name.nil?
    cmd_string = "facter -p osfamily"
    stdout, stderr, status = Open3.capture3(cmd_string)
    osfamily = stdout.strip
    if osfamily == 'RedHat'
      service_name = 'httpd'
    elsif osfamily == 'FreeBSD'
      service_name = 'apache24'
    else
      service_name = 'apache2'
    end
  end
  stdout, stderr, status = Open3.capture3('service', service_name, action)
  raise Puppet::Error, stderr if status != 0
  { status: "#{action} successful" }
end

params = JSON.parse(STDIN.read)
action = params['action']
service_name = params['service_name']

begin
  result = service(action, service_name)
  puts result.to_json
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e.message }.to_json)
  exit 1
end
