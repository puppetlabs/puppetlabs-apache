require 'spec_helper'

describe 'apache::mod', :type => :define do
  context "On a Red Hat OS with shibboleth module and package param passed" do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    # name/title for the apache::mod define
    let :title do
      'xsendfile'
    end
    # parameters
    let(:params) { {:package => 'mod_xsendfile'} }

    it { should include_class("apache::params") }
    it { should contain_package('mod_xsendfile') }
  end

  context "On a Red Hat OS with shibboleth module" do
    let :facts do
      { :osfamily => 'redhat' }
    end
    let :title do
      'shibboleth'
    end
    it { should include_class("apache::params") }
    it { should contain_package('shibboleth') }
    it do
      should contain_a2mod(title).with({
        'ensure'     => 'present',
        'identifier' => 'mod_shib',
      })
    end
  end
end
