require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'apache::balancers class' do
  context 'custom balancers defined via class apache::balancers' do
    it 'should create custom vhost config files' do
      pp = <<-EOS
        class { 'apache::balancers':
          balancers => {
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
        }

        class { 'apache::balancermembers':
	  balancermembers => {  
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
      EOS
      apply_manifest(pp, :catch_failures => true)
    end

    describe file("#{$vhost_dir}/25-custom_vhost_1.conf") do
      it { is_expected.to contain 'puppet00' }
    end

    describe file("#{$vhost_dir}/25-custom_vhost_2.conf") do
      it { is_expected.to contain 'spechost01-puppet01' }
    end
  end
end
