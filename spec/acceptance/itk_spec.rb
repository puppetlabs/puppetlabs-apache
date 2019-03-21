require 'spec_helper_acceptance'

case os[:family]
when 'debian'
  service_name = 'apache2'
  majrelease = fact('operatingsystemmajrelease')
  variant = if ['6', '7', '10.04', '12.04'].include?(majrelease)
              :itk_only
            else
              :prefork
            end
when 'redhat'
  unless os[:release].to_i == 5
    service_name = 'httpd'
    majrelease = os[:release].to_i
    variant = if [6].include?(majrelease)
                :itk_only
              else
                :prefork
              end
  end
when 'freebsd'
  service_name = 'apache24'
  # majrelease = fact('operatingsystemmajrelease')
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
end
