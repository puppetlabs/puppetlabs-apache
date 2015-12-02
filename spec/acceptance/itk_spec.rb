require 'spec_helper_acceptance'

case fact('osfamily')
when 'Debian'
  service_name = 'apache2'
when 'FreeBSD'
  service_name = 'apache24'
end

describe 'apache::mod::itk class', :if => service_name do
  describe 'running puppet code' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
        class { 'apache':
          mpm_module => 'prefork',
        }
        class { 'apache::mod::itk': }
      EOS

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
