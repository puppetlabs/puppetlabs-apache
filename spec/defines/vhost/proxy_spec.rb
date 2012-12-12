require 'spec_helper'

describe 'apache::vhost::proxy', :type => :define do

  let :title do
    'my_proxy_vhost'
  end

  let :facts do
    {
      :operatingsystem => 'redhat',
      :osfamily        => 'redhat'
    }
  end

  let :default_params do
    {
      :port          => '80',
      :dest          => 'example.com',
      :priority      => '10',
      :template      => "apache/vhost-proxy.conf.erb",
      :servername    => '',
      :serveraliases => '',
      :ssl           => false,
      :vhost_name    => '*'
    }
  end

  [{
      :dest       => 'example2.com',
      :servername => 'example3.com',
      :port       => '80',
      :ssl        => true,
      :access_log => false,
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
          should contain_apache__mod__ssl
        else
          should_not contain_apache__mod__ssl
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

      it 'should accept $servername' do
        verify_contents(subject, "#{param_hash[:priority]}-#{title}.conf", [
          '  ServerName example3.com'
        ] )
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
