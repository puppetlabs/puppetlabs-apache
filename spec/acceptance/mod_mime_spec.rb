require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'apache::mod::mime class' do
  context 'default mime config' do
    pp = <<-MANIFEST
        class { 'apache': }
        include apache::mod::mime
    MANIFEST
    it 'succeeds in puppeting mime' do
      apply_manifest(pp, catch_failures: true)
    end

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      elsif fact('operatingsystem') == 'SLES' && fact('operatingsystemmajrelease') == '15'
        pending 'Should be enabled - MODULES-8379 `be_enabled` check does not currently work for apache2 on SLES 15'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    describe file("#{$mod_dir}/mime.conf") do
      it { is_expected.to contain 'AddType application/x-compress .Z' }
      it { is_expected.to contain "AddHandler type-map var\n" }
      it { is_expected.to contain "AddType text/html .shtml\n" }
      it { is_expected.to contain "AddOutputFilter INCLUDES .shtml\n" }
    end
  end
end
