require 'spec_helper'

describe 'apache::balancer', :type => :define do
  let :pre_condition do
    'include apache'
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
  describe "accept a target parameter and use it" do
    let :title do
      'myapp'
    end
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
