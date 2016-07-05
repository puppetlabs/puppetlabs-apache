require 'spec_helper'

describe 'apache::balancer', :type => :define do
  let :title do
    'myapp'
  end
  let :facts do
    {
      :osfamily               => 'Debian',
      :operatingsystem        => 'Debian',
      :operatingsystemrelease => '6',
      :lsbdistcodename        => 'squeeze',
      :id                     => 'root',
      :concat_basedir         => '/dne',
      :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      :kernel                 => 'Linux',
      :is_pe                  => false,
    }
  end
  describe 'apache pre_condition with defaults' do
    let :pre_condition do
      'include apache'
    end
    describe "accept a target parameter and use it" do
      let :params do
        {
          :target => '/tmp/myapp.conf'
        }
      end
      it { should contain_concat('apache_balancer_myapp').with({
        :path => "/tmp/myapp.conf",
      })}
    end
  end
  describe 'apache pre_condition with conf_dir set' do 
    let :pre_condition do
      'class{"apache":
          confd_dir => "/junk/path"
       }'
    end
    it { should contain_concat('apache_balancer_myapp').with({
      :path => "/junk/path/balancer_myapp.conf",
    })}
  end
end
