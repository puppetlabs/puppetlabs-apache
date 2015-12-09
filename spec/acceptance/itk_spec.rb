require 'spec_helper_acceptance'

case fact('osfamily')
when 'Debian'
  service_name = 'apache2'
  majrelease = fact('operatingsystemmajrelease')
  if [ '6', '7', '10.04', '12.04'].include?(majrelease)
    variant = :itk_only
  else
    variant = :prefork
  end
when 'FreeBSD'
  service_name = 'apache24'
  majrelease = fact('operatingsystemmajrelease')
  variant = :prefork
end

describe 'apache::mod::itk class', :if => service_name do
  describe 'running puppet code' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = case variant
           when :prefork
             <<-EOS
               class { 'apache':
                 mpm_module => 'prefork',
               }
               class { 'apache::mod::itk': }
             EOS
           when :itk_only
             <<-EOS
               class { 'apache':
                 mpm_module => 'itk',
               }
             EOS
           end

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  describe service(service_name) do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end
end
