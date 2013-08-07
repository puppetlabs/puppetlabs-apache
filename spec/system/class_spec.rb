require 'spec_helper_system'

describe 'apache class' do
  case node.facts['osfamily']
  when 'RedHat'
    package_name = 'httpd'
    service_name = 'httpd'
  when 'Debian'
    package_name = 'apache2'
    service_name = 'apache2'
  end

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'apache': }
      EOS

      # Run it twice and test for idempotency
      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
        r.refresh
        r.exit_code.should be_zero
      end
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
      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
        r.refresh
        r.exit_code.should be_zero
      end
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
