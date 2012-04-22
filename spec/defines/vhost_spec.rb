require 'spec_helper'

describe 'apache::vhost', :type => :define do

  let :title do
    'my_vhost'
  end

  let :default_params do
    {
    :apache_name   => 'apache2',
    :auth          => false,
    :docroot       => 'path/to/docroot',
    :options       => 'Indexes FollowSymLinks MultiViews',
    :port          => '80',
    :priority      => '25',
    :redirect_ssl  => false,
    :serveraliases => '',
    :servername    => '',
    :ssl           => true,
    :template      => 'apache/vhost-default.conf.erb',
    :vhost_name    => '*'
    }
  end

  [{
      :apache_name   => 'httpd',
      :docroot       => 'path/to/docroot',
      :port          => '80',
      :priority      => '25',
      :ssl           => false,
      :template      => 'apache/vhost-default.conf.erb',
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

      it {
        if param_hash[:ssl]
          should contain_apache__ssl
        else
          should_not contain_apache__ssl
        end
      }

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
      #    'action' => 'accept',
      #    'dport'  => "#{param_hash[:port]}",
      #    'proto'  => 'tcp'
      #  })
      #}


    end
  end
end
