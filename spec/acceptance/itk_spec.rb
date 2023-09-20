# frozen_string_literal: true

require 'spec_helper_acceptance'

case os[:family]
when 'debian', 'ubuntu'
  service_name = 'apache2'
when 'redhat'
  service_name = 'httpd'
when 'freebsd'
  service_name = 'apache24'
end

# IAC-787: The http-itk mod package is not available in any of the standard RHEL/CentOS 8.x repos. Disable this test
# on those platforms until we can find a suitable source for this package.
describe 'apache::mod::itk class', if: service_name && mod_supported_on_platform?('apache::mod::itk') do
  describe 'running puppet code' do
    pp = <<-MANIFEST
            class { 'apache':
              mpm_module => 'prefork',
            }
            class { 'apache::mod::itk': }
    MANIFEST

    it 'behaves idempotently' do
      idempotent_apply(pp)
    end
  end

  describe service(service_name) do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end
end
