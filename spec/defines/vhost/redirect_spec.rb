require 'spec_helper'

describe 'apache::vhost::redirect', :type => :define do
  context "On a Debian OS" do
    let :facts do
      { :osfamily => 'Debian' }
    end
    let :title do
      'my_vhost_redirect'
    end
    let :default_params do
      {
        :port          => '80',
        :dest          => 'example.com',
        :priority      => '10',
        :template      => "apache/vhost-redirect.conf.erb",
        :vhost_name    => '*'
      }
    end
    [{
        :dest          => 'example2.com',
        :port          => '80',
     },
    ].each do |param_set|
      describe "when #{param_set == {} ? "using default" : "specifying"} class parameters" do
        let :param_hash do
          default_params.merge(param_set)
        end
        let :params do
          param_set
        end
        it { should include_class("apache") }
        it { should contain_apache__params }
        it { should contain_file("#{param_hash[:priority]}-#{title}.conf").with({
            'owner'     => 'root',
            'group'     => 'root',
            'mode'      => '0755',
            'require'   => 'Package[httpd]',
            'notify'    => 'Service[httpd]'
          })
        }
        # FIXME: Firewall is not actually realized anywhere
        #it { should contain_firewall("0100-INPUT ACCEPT #{param_hash[:port]}").with( {
        #    'jump' => 'Accept',
        #    'dport'  => "#{param_hash[:port]}",
        #    'proto'  => 'tcp'
        #  })
        #}
      end
    end
  end
end
