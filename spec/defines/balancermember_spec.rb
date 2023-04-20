# frozen_string_literal: true

require 'spec_helper'

describe 'apache::balancermember', type: :define do
  let :pre_condition do
    'include apache'
  end

  include_examples 'Debian 11'

  describe 'allows multiple balancermembers with the same url' do
    let :pre_condition do
      'include apache
      apache::balancer {"balancer":}
      apache::balancer {"balancer-external":}
      apache::balancermember {"http://127.0.0.1:8080-external": url => "http://127.0.0.1:8080/", balancer_cluster => "balancer-external"}
      '
    end
    let :title do
      'http://127.0.0.1:8080/'
    end
    let :params do
      {
        options: [],
        url: 'http://127.0.0.1:8080/',
        balancer_cluster: 'balancer-internal'
      }
    end

    it { is_expected.to contain_concat__fragment('BalancerMember http://127.0.0.1:8080/') }
  end

  describe 'allows balancermember with a different target' do
    let :pre_condition do
      'include apache
      apache::balancer {"balancername": target => "/etc/apache/balancer.conf"}
      apache::balancermember {"http://127.0.0.1:8080-external": url => "http://127.0.0.1:8080/", balancer_cluster => "balancername"}
      '
    end
    let :title do
      'http://127.0.0.1:8080/'
    end
    let :params do
      {
        options: [],
        url: 'http://127.0.0.1:8080/',
        balancer_cluster: 'balancername'
      }
    end

    it {
      expect(subject).to contain_concat__fragment('BalancerMember http://127.0.0.1:8080/').with(target: 'apache_balancer_balancername')
    }
  end
end
