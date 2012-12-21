require 'spec_helper'

describe 'apache::mod', :type => :define do
  context "on a RedHat osfamily" do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    describe "for non-special modules" do
      let :title do
        'spec_m'
      end
      it { should include_class("apache::params") }
      it "should manage the module load file" do
        should contain_file('spec_m.load').with({
          :path    => '/etc/httpd/mod.d/spec_m.load',
          :content => "LoadModule spec_m_module modules/mod_spec_m.so\n",
        } )
      end
    end

    describe "with shibboleth module and package param passed" do
      # name/title for the apache::mod define
      let :title do
        'xsendfile'
      end
      # parameters
      let(:params) { {:package => 'mod_xsendfile'} }

      it { should include_class("apache::params") }
      it { should contain_package('mod_xsendfile') }
    end
  end

  context "on a Debian osfamily" do
    let :facts do
      { :osfamily => 'Debian' }
    end

    describe "for non-special modules" do
      let :title do
        'spec_m'
      end
      it { should include_class("apache::params") }
      it "should manage the module load file" do
        should contain_file('spec_m.load').with({
          :path    => '/etc/apache2/mods-enabled/spec_m.load',
          :content => "LoadModule spec_m_module /usr/lib/apache2/modules/mod_spec_m.so\n"
        } )
      end
    end
  end
end
