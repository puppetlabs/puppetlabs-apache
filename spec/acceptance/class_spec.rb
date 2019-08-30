require 'spec_helper_acceptance'
apache_hash = apache_settings_hash
describe 'apache class' do
  context 'default parameters' do
    let(:pp) { "class { 'apache': }" }

    it 'behaves idempotently' do
      idempotent_apply(pp)
    end

    describe 'apache_version fact' do
      let(:result) do
        apply_manifest('include apache', catch_failures: true)
        version_check_pp = <<-MANIFEST
        notice("apache_version = >${apache_version}<")
        MANIFEST
        apply_manifest(version_check_pp, catch_failures: true)
      end

      it {
        expect(result.stdout).to match(%r{apache_version = >#{apache_hash['version']}.*<})
      }
    end

    describe package(apache_hash['package_name']) do
      it { is_expected.to be_installed }
    end

    describe service(apache_hash['service_name']), skip: 'FM-8483' do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(80) do
      it { is_expected.to be_listening }
    end
  end

  context 'custom site/mod dir parameters' do
    let(:pp) do
      <<-MANIFEST
        if $::osfamily == 'RedHat' and "$::selinux" == "true" {
          $semanage_package = $::operatingsystemmajrelease ? {
            '5'     => 'policycoreutils',
            default => 'policycoreutils-python',
          }

          package { $semanage_package: ensure => installed }
          exec { 'set_apache_defaults':
            command     => 'semanage fcontext -a -t httpd_sys_content_t "/apache_spec(/.*)?"',
            path        => '/bin:/usr/bin/:/sbin:/usr/sbin',
            subscribe   => Package[$semanage_package],
            refreshonly => true,
          }
          exec { 'restorecon_apache':
            command     => 'restorecon -Rv /apache_spec',
            path        => '/bin:/usr/bin/:/sbin:/usr/sbin',
            before      => Service['httpd'],
            require     => Class['apache'],
            subscribe   => Exec['set_apache_defaults'],
            refreshonly => true,
          }
        }
        file { '/apache_spec': ensure => directory, }
        file { '/apache_spec/apache_custom': ensure => directory, }
        class { 'apache':
          mod_dir   => '/apache_spec/apache_custom/mods',
          vhost_dir => '/apache_spec/apache_custom/vhosts',
        }
      MANIFEST
    end

    it 'behaves idempotently' do
      idempotent_apply(pp)
    end

    describe service(apache_hash['service_name']), skip: 'FM-8483' do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
