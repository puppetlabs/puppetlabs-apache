require 'spec_helper_acceptance'

case os[:family]
when 'debian'
  service_name = 'apache2'
  variant = :prefork
when 'redhat'
  unless os[:release].to_i == 5
    service_name = 'httpd'
    variant = if [6].include?(os[:release].to_i)
                :itk_only
              else
                :prefork
              end
  end
when 'freebsd'
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
    require 'pry'
    binding.pry
    if host_inventory['facter']['os']['name'] == 'Debian' && host_inventory['facter']['os']['release']['major'] == '8'
      pending 'Should be enabled - Bug 760616 on Debian 8'
    elsif host_inventory['facter']['os']['name'] == 'SLES' && host_inventory['facter']['os']['release']['major'] == '15'
      pending 'Should be enabled - MODULES-8379 `be_enabled` check does not currently work for apache2 on SLES 15'
    else
      it { is_expected.to be_enabled }
    end
  end
end
