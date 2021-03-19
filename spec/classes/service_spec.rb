# frozen_string_literal: true

require 'spec_helper'

describe 'apache::service', type: :class do
  let :pre_condition do
    'include apache::params'
  end

  context 'on a Debian OS' do
    include_examples 'Debian 8'

    it {
      is_expected.to contain_service('httpd').with(
        'name'      => 'apache2',
        'ensure'    => 'running',
        'enable'    => 'true',
      )
    }

    context "with $service_name => 'foo'" do
      let(:params) { { service_name: 'foo' } }

      it {
        is_expected.to contain_service('httpd').with(
          'name' => 'foo',
        )
      }
    end

    context 'with $service_enable => true' do
      let(:params) { { service_enable: true } }

      it {
        is_expected.to contain_service('httpd').with(
          'name'      => 'apache2',
          'ensure'    => 'running',
          'enable'    => 'true',
        )
      }
    end

    context 'with $service_enable => false' do
      let(:params) { { service_enable: false } }

      it {
        is_expected.to contain_service('httpd').with(
          'name'      => 'apache2',
          'ensure'    => 'running',
          'enable'    => 'false',
        )
      }
    end

    context "with $service_ensure => 'running'" do
      let(:params) { { service_ensure: 'running' } }

      it {
        is_expected.to contain_service('httpd').with(
          'ensure'    => 'running',
          'enable'    => 'true',
        )
      }
    end

    context "with $service_ensure => 'stopped'" do
      let(:params) { { service_ensure: 'stopped' } }

      it {
        is_expected.to contain_service('httpd').with(
          'ensure'    => 'stopped',
          'enable'    => 'true',
        )
      }
    end

    context "with $service_ensure => 'UNDEF'" do
      let(:params) { { service_ensure: 'UNDEF' } }

      it { is_expected.to contain_service('httpd').without_ensure }
    end

    context 'with $service_restart unset' do
      it { is_expected.to contain_service('httpd').without_restart }
    end

    context "with $service_restart => '/usr/sbin/apachectl graceful'" do
      let(:params) { { service_restart: '/usr/sbin/apachectl graceful' } }

      it {
        is_expected.to contain_service('httpd').with(
          'restart' => '/usr/sbin/apachectl graceful',
        )
      }
    end
  end

  context 'on a RedHat 8 OS, do not manage service' do
    include_examples 'RedHat 8'
    let(:params) do
      {
        'service_ensure' => 'running',
        'service_name'   => 'httpd',
        'service_manage' => false,
      }
    end

    it { is_expected.not_to contain_service('httpd') }
  end

  context 'on a FreeBSD 9 OS' do
    include_examples 'FreeBSD 9'

    it {
      is_expected.to contain_service('httpd').with(
        'name'      => 'apache24',
        'ensure'    => 'running',
        'enable'    => 'true',
      )
    }
  end

  context 'on a Gentoo OS' do
    include_examples 'Gentoo'

    it {
      is_expected.to contain_service('httpd').with(
        'name'      => 'apache2',
        'ensure'    => 'running',
        'enable'    => 'true',
      )
    }
  end
end
