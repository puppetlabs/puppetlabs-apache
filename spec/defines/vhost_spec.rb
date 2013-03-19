require 'spec_helper'

describe 'apache::vhost', :type => :define do
  context "On a RedHat OS" do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    let :title do
      'my_vhost'
    end

    let :default_params do
      {
      :apache_name   => 'apache2',
      :auth          => false,
      :docroot       => 'path/to/docroot',
      :options       => 'Indexes FollowSymLinks MultiViews',
      :override      => 'None',
      :port          => '80',
      :priority      => '25',
      :redirect_ssl  => false,
      :serveraliases => '',
      :servername    => '',
      :ssl           => true,
      :template      => 'apache/vhost-default.conf.erb',
      :vhost_name    => '*',
      :ensure        => 'present'
      }
    end

    [{
        :apache_name => 'httpd',
        :docroot     => 'path/to/docroot',
        :override    => ['Options', 'FileInfo'],
        :port        => '80',
        :priority    => '25',
        :serveradmin => 'serveradmin@puppet',
        :ssl         => false,
        :access_log  => false,
        :template    => 'apache/vhost-default.conf.erb',
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

    [true,false].each do |value|
      describe "when access_log is #{value}" do
        let :params do
          default_params.merge({:access_log => value})
        end

        it "#{value ? "should" : "should not"} contain access logs" do
          lines = subject.resource('file', "#{params[:priority]}-#{title}.conf").send(:parameters)[:content].split("\n")
          !!lines.grep('_access.log combined').should == value
        end
      end
    end
  end
end
