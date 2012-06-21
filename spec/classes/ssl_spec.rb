require 'spec_helper'

describe 'apache::ssl', :type => :class do

  describe 'when running on an unsupported OS' do
    let(:facts) { {:osfamily=> 'MagicUnicorn'} }
    it {
      expect {
        should raise_error(Puppet::Error, /not defined in apache::ssl/ )
      }
    }
  end

  describe 'when running on a supported OS' do
    let(:facts) { {:osfamily => 'redhat'} }
    it { should include_class('apache') }
    it { should include_class('apache::params') }
  end

  describe 'when running on redhat' do
    let(:facts) { {:osfamily => 'redhat'} }
    it {
      should contain_package('apache_ssl_package').with(
        'ensure'  => 'installed'
      )
    }
  end

  describe 'when running on debian' do
    let(:facts) { {:osfamily => 'debian'} }
    it {
      should contain_a2mod('ssl').with('ensure'  => 'present')
    }
  end

end
