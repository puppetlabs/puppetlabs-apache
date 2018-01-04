require 'spec_helper'

describe 'apache::balancers', :type => :class do
  context 'on all OSes' do
    let :facts do
      {
          :id                     => 'root',
          :kernel                 => 'Linux',
          :osfamily               => 'RedHat',
          :operatingsystem        => 'RedHat',
          :operatingsystemrelease => '6',
          :concat_basedir         => '/dne',
          :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          :is_pe                  => false,
      }
    end
    context 'with custom balancers parameter' do
      let :params do {
          :balancers => {
              'puppet00' => {
		  'proxy_set' => {
                      'stickysession' => 'JSESSIONID',
                      'lbmethod' => 'bytraffic',
                  },
	      },
              'puppet01' => {
                  'proxy_set' => {
                      'stickysession' => 'JSESSIONID',
                      'lbmethod' => 'bytraffic',
                  },
              },
          },
	  :balancermembers => {
              'spechost00-puppet00' => {
                   'balancer_cluster' => 'puppet00',
                   'url' => 'ajp://spechost00:8009',
              },
              'spechost01-puppet01' => {
                   'balancer_cluster' => 'puppet01',
                   'url' => 'ajp://spechost01:8009',
              },
          },
      }
      end
      it { is_expected.to contain_apache__balancer('puppet00') }
      it { is_expected.to contain_apache__balancer('puppet01') }
      it { is_expected.to contain_apache__balancermember('spechost00') }
      it { is_expected.to contain_apache__balancermember('spechost01') }
    end
  end
end
