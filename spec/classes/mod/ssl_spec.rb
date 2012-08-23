require 'spec_helper'

describe 'apache::mod::ssl', :type => :class do
  describe 'when running on an unsupported OS' do
    let(:facts) { {:operatingsystem => 'MagicUnicorn', :osfamily => 'Magic'} }
    it { expect { should raise_error(Puppet::Error, "Unsupported operatingsystem:") } }
  end

  describe 'when running on redhat' do
    let(:facts) { {:operatingsystem => 'redhat', :osfamily => 'redhat'} }
    it { should include_class('apache::params') }
    it { should contain_package('mod_ssl') }
    it { should contain_a2mod('ssl') }
  end

  describe 'when running on debian' do
    let(:facts) { {:operatingsystem => 'debian', :osfamily => 'debian'} }
    it { should include_class('apache::params') }
    it { should_not contain_package('libapache2-mod-ssl') }
    it { should contain_a2mod('ssl') }
  end
end
