require 'spec_helper_acceptance'

case host_inventory['facter']['os']['family']
when 'Debian'
  service_name = 'apache2'
  variant = :prefork
when 'RedHat'
  unless host_inventory['facter']['os']['release']['major'] == '5'
    variant = (os[:release].to_i >= 7) ? :prefork : :itk_only
    service_name = 'httpd'
  end
when 'FreeBSD'
  service_name = 'apache24'
  variant = :prefork
end

describe 'apache::mod::itk class', if: service_name do
  describe 'running puppet code' do
    # Using puppet_apply as a helper
    let(:pp) do
      case variant
      when :prefork
        <<-MANIFEST
            class { 'apache':
              mpm_module => 'prefork',
            }
            class { 'apache::mod::itk': }
          MANIFEST
      when :itk_only
        <<-MANIFEST
            class { 'apache':
              mpm_module => 'itk',
            }
          MANIFEST
      end
    end

    # Run it twice and test for idempotency
    it_behaves_like 'a idempotent resource'
  end

  describe service(service_name) do
    it { is_expected.to be_running }
    if host_inventory['facter']['os']['name'] == 'Debian' && host_inventory['facter']['os']['release']['major'] == '8'
      pending 'Should be enabled - Bug 760616 on Debian 8'
    elsif host_inventory['facter']['os']['name'] == 'SLES' && host_inventory['facter']['os']['release']['major'] == '15'
      pending 'Should be enabled - MODULES-8379 `be_enabled` check does not currently work for apache2 on SLES 15'
    else
      it { is_expected.to be_enabled }
    end
  end
end
