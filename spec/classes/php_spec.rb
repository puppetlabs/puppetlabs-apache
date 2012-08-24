require 'spec_helper'

describe 'apache::php', :type => :class do
  context "On a Debian OS" do
    let :facts do
      { :osfamily => 'Debian' }
    end
    it { should include_class("apache::params") }
    it { should contain_apache__mod("php5") }
    it { should contain_package("libapache2-mod-php5") }
  end

  context "On a RedHat OS" do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    it { should include_class("apache::params") }
    it { should contain_apache__mod("php5") }
    it { should contain_package("php") }
  end

  context "On undefined OS" do
    it { expect { should raise_error(Puppet::Error) } }
  end
end
