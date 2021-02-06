# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::cluster', type: :class do
  context 'on a RedHat OS Release 7 with mod version = 1.3.0' do
    include_examples 'RedHat 7'

    let(:params) do
      {
        allowed_network: '172.17.0',
        balancer_name: 'mycluster',
        ip: '172.17.0.1',
        version: '1.3.0',
      }
    end

    it { is_expected.to contain_class('apache') }
    it { is_expected.to contain_apache__mod('proxy') }
    it { is_expected.to contain_apache__mod('proxy_ajp') }
    it { is_expected.to contain_apache__mod('manager') }
    it { is_expected.to contain_apache__mod('proxy_cluster') }
    it { is_expected.to contain_apache__mod('advertise') }
    it { is_expected.to contain_apache__mod('cluster_slotmem') }

    it { is_expected.to contain_file('cluster.conf') }
  end

  context 'on a RedHat OS Release 7 with mod version > 1.3.0' do
    include_examples 'RedHat 7'

    let(:params) do
      {
        allowed_network: '172.17.0',
        balancer_name: 'mycluster',
        ip: '172.17.0.1',
        version: '1.3.1',
      }
    end

    it { is_expected.to contain_class('apache') }
    it { is_expected.to contain_apache__mod('proxy') }
    it { is_expected.to contain_apache__mod('proxy_ajp') }
    it { is_expected.to contain_apache__mod('manager') }
    it { is_expected.to contain_apache__mod('proxy_cluster') }
    it { is_expected.to contain_apache__mod('advertise') }
    it { is_expected.to contain_apache__mod('cluster_slotmem') }

    it { is_expected.to contain_file('cluster.conf') }
  end

  context 'on a RedHat OS Release 6 with mod version < 1.3.0' do
    include_examples 'RedHat 6'

    let(:params) do
      {
        allowed_network: '172.17.0',
        balancer_name: 'mycluster',
        ip: '172.17.0.1',
        version: '1.2.0',
      }
    end

    it { is_expected.to contain_class('apache') }
    it { is_expected.to contain_apache__mod('proxy') }
    it { is_expected.to contain_apache__mod('proxy_ajp') }
    it { is_expected.to contain_apache__mod('manager') }
    it { is_expected.to contain_apache__mod('proxy_cluster') }
    it { is_expected.to contain_apache__mod('advertise') }
    it { is_expected.to contain_apache__mod('slotmem') }

    it { is_expected.to contain_file('cluster.conf') }
  end
end
