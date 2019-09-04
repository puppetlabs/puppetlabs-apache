require 'spec_helper_acceptance'

case os[:family]
when 'debian', 'ubuntu'
  service_name = 'apache2'
  variant = :prefork
when 'redhat'
  unless os[:release] =~ %r{^5}
    variant = (os[:release].to_i >= 7) ? :prefork : :itk_only
    service_name = 'httpd'
  end
when 'freebsd'
  service_name = 'apache24'
  variant = :prefork
end

describe 'apache::mod::itk class', if: service_name do
  describe 'running puppet code' do
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

    it 'behaves idempotently' do
      idempotent_apply(pp)
    end
  end

  describe service(service_name), skip: 'FM-8483' do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end
end
