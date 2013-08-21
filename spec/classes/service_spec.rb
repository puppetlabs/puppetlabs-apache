require 'spec_helper'

describe 'apache::service', :type => :class do
  context "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    it { should contain_service("httpd").with(
      'ensure'    => 'true',
      'enable'    => 'true'
      )
    }

    context "with $service_enable => true" do
      let (:params) {{ :service_enable => true }}
      it { should contain_service("httpd").with(
        'ensure'    => 'true',
        'enable'    => 'true'
        )
      }
    end

    context "with $service_enable => false" do
      let (:params) {{ :service_enable => false }}
      it { should contain_service("httpd").with(
        'ensure'    => 'false',
        'enable'    => 'false'
        )
      }
    end

    context "$service_enable must be a bool" do
      let (:params) {{ :service_enable => 'not-a-boolean' }}

      it 'should fail' do
        expect {
          should include_class('apache::service')
        }.to raise_error(Puppet::Error, /is not a boolean/)
      end
    end
  end


  context "on a RedHat 5 OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '5',
        :concat_basedir         => '/dne',
      }
    end
    it { should contain_service("httpd").with(
      'ensure'    => 'true',
      'enable'    => 'true'
      )
    }
  end
end
