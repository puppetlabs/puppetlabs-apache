#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'

def service(action, service_name)
  if service_name.nil?
    stdout, _stderr, _status = Open3.capture3('facter', '-p', 'osfamily')
    osfamily = stdout.strip
    service_name = if osfamily == 'RedHat'
                     'httpd'
                   elsif osfamily == 'FreeBSD'
                     'apache24'
                   else
                     'apache2'
                   end
  end
  _stdout, stderr, status = Open3.capture3('service', service_name, action)
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
