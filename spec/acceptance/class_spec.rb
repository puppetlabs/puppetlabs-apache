require 'spec_helper_acceptance'

describe 'apache class' do
  case fact('osfamily')
  when 'RedHat'
    package_name = 'httpd'
    service_name = 'httpd'
  when 'Debian'
    package_name = 'apache2'
    service_name = 'apache2'
  when 'FreeBSD'
    package_name = 'apache22'
    service_name = 'apache22'
  end

  context 'default parameters' do
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'apache': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

    describe package(package_name) do
      it { should be_installed }
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end
  end

  context 'custom site/mod dir parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      file { '/apache': ensure => directory, }
      class { 'apache':
        mod_dir   => '/apache/mods',
        vhost_dir => '/apache/vhosts',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
