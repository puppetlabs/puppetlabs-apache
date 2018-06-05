require 'spec_helper'

describe 'apache::mod::auth_mellon', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters on a Debian OS' do
    let :facts do
      {
        osfamily: 'Debian',
        operatingsystemrelease: '8',
        concat_basedir: '/dne',
        lsbdistcodename: 'jessie',
        operatingsystem: 'Debian',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        fqdn: 'test.example.com',
        is_pe: false,
      }
    end

    describe 'with no parameters' do
      it { is_expected.to contain_apache__mod('auth_mellon') }
      it { is_expected.to contain_package('libapache2-mod-auth-mellon') }
      it { is_expected.to contain_file('auth_mellon.conf').with_path('/etc/apache2/mods-available/auth_mellon.conf') }
      it { is_expected.to contain_file('auth_mellon.conf').with_content("MellonPostDirectory \"\/var\/cache\/apache2\/mod_auth_mellon\/\"\n") }
    end
    describe 'with parameters' do
      let :params do
        { mellon_cache_size: '200',
          mellon_cache_entry_size: '2010',
          mellon_lock_file: '/tmp/junk',
          mellon_post_directory: '/tmp/post',
          mellon_post_ttl: '5',
          mellon_post_size: '8',
          mellon_post_count: '10' }
      end

      it { is_expected.to contain_file('auth_mellon.conf').with_content(%r{^MellonCacheSize\s+200$}) }
      it { is_expected.to contain_file('auth_mellon.conf').with_content(%r{^MellonCacheEntrySize\s+2010$}) }
      it { is_expected.to contain_file('auth_mellon.conf').with_content(%r{^MellonLockFile\s+"\/tmp\/junk"$}) }
      it { is_expected.to contain_file('auth_mellon.conf').with_content(%r{^MellonPostDirectory\s+"\/tmp\/post"$}) }
      it { is_expected.to contain_file('auth_mellon.conf').with_content(%r{^MellonPostTTL\s+5$}) }
      it { is_expected.to contain_file('auth_mellon.conf').with_content(%r{^MellonPostSize\s+8$}) }
      it { is_expected.to contain_file('auth_mellon.conf').with_content(%r{^MellonPostCount\s+10$}) }
    end
  end
  context 'default configuration with parameters on a RedHat OS' do
    let :facts do
      {
        osfamily: 'RedHat',
        operatingsystemrelease: '6',
        concat_basedir: '/dne',
        operatingsystem: 'RedHat',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        fqdn: 'test.example.com',
        is_pe: false,
      }
    end

    describe 'with no parameters' do
      it { is_expected.to contain_apache__mod('auth_mellon') }
      it { is_expected.to contain_package('mod_auth_mellon') }
      it { is_expected.to contain_file('auth_mellon.conf').with_path('/etc/httpd/conf.d/auth_mellon.conf') }
      it { is_expected.to contain_file('auth_mellon.conf').with_content("MellonCacheSize 100\nMellonLockFile \"/run/mod_auth_mellon/lock\"\n") }
    end
    describe 'with parameters' do
      let :params do
        { mellon_cache_size: '200',
          mellon_cache_entry_size: '2010',
          mellon_lock_file: '/tmp/junk',
          mellon_post_directory: '/tmp/post',
          mellon_post_ttl: '5',
          mellon_post_size: '8',
          mellon_post_count: '10' }
      end

      it { is_expected.to contain_file('auth_mellon.conf').with_content(%r{^MellonCacheSize\s+200$}) }
      it { is_expected.to contain_file('auth_mellon.conf').with_content(%r{^MellonCacheEntrySize\s+2010$}) }
      it { is_expected.to contain_file('auth_mellon.conf').with_content(%r{^MellonLockFile\s+"\/tmp\/junk"$}) }
      it { is_expected.to contain_file('auth_mellon.conf').with_content(%r{^MellonPostDirectory\s+"\/tmp\/post"$}) }
      it { is_expected.to contain_file('auth_mellon.conf').with_content(%r{^MellonPostTTL\s+5$}) }
      it { is_expected.to contain_file('auth_mellon.conf').with_content(%r{^MellonPostSize\s+8$}) }
      it { is_expected.to contain_file('auth_mellon.conf').with_content(%r{^MellonPostCount\s+10$}) }
    end
  end
end
