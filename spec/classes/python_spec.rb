require 'spec_helper'

describe 'apache::python', :type => :class do
  context "On a Debian OS" do
    let :facts do
      { :osfamily => 'Debian' }
    end
    it { should include_class("apache::params") }
    it { should contain_package("libapache2-mod-python") }
  end
  context "On a RedHat OS" do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    it { should include_class("apache::params") }
    it { should contain_package("mod_python") }
    it { should contain_a2mod("python").with('ensure'=>'present') }
  end
end
