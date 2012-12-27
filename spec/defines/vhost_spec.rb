require 'spec_helper'

describe 'apache::vhost', :type => :define do
  let :title do
    'my_vhost'
  end
  let :default_params do
    {
      :docroot  => '/path/to/docroot',
      :port     => '80',
      :priority => '25',
    }
  end
  let :default_facts do
    {
      :concat_basedir => '/dne',
      :osfamily       => 'RedHat',
    }
  end

  describe 'os-dependent items' do
    context "on a Debian OS" do
      let :facts do
        default_facts.merge({ :osfamily => 'Debian', })
      end
      [{
          :docroot     => 'path/to/docroot',
          :override    => ['Options', 'FileInfo'],
          :port        => '443',
          :priority    => '29',
          :serveradmin => 'serveradmin@puppetlabs.com',
          :ssl         => true,
          :access_log  => false,
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

    [true,false].each do |value|
      describe "when access_log is #{value}" do
        let :params do
          default_params.merge({:access_log => value})
        end
        let :facts do
          default_facts
        end

        it "#{value ? "should" : "should not"} contain access logs" do
          lines = subject.resource('file', "#{params[:priority]}-#{title}.conf").send(:parameters)[:content].split("\n")
          !!lines.grep('_access.log combined').should == value
        end
      end
    end
  end
end
