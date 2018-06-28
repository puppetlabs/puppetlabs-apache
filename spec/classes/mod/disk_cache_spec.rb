require 'spec_helper'

describe 'apache::mod::disk_cache', type: :class do
  context 'on a Debian OS' do
    let :facts do
      {
        id: 'root',
        kernel: 'Linux',
        lsbdistcodename: 'jessie',
        osfamily: 'Debian',
        operatingsystem: 'Debian',
        operatingsystemrelease: '8',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        concat_basedir: '/dne',
        is_pe: false,
      }
    end

    let(:params) do
      {
        cache_ignore_headers: 'Set-Cookie',
      }
    end

    context 'with Apache version < 2.4' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.2",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('apache::mod::disk_cache') }
      it { is_expected.to contain_apache__mod('disk_cache') }
      it {
        is_expected.to contain_file('disk_cache.conf')
          .with(content: %r{CacheEnable disk \/\nCacheRoot \"\/var\/cache\/apache2\/mod_disk_cache\"\nCacheDirLevels 2\nCacheDirLength 1\nCacheIgnoreHeaders Set-Cookie})
      }
    end
    context 'with Apache version >= 2.4' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.4",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('apache::mod::disk_cache') }
      it { is_expected.to contain_class('apache::mod::cache').that_comes_before('Class[Apache::Mod::Disk_cache]') }
      it { is_expected.to contain_apache__mod('cache_disk') }
      it {
        is_expected.to contain_file('disk_cache.conf')
          .with(content: %r{CacheEnable disk \/\nCacheRoot \"\/var\/cache\/apache2\/mod_cache_disk\"\nCacheDirLevels 2\nCacheDirLength 1\nCacheIgnoreHeaders Set-Cookie})
      }
    end
  end

  context 'on a RedHat 6-based OS' do
    let :facts do
      {
        id: 'root',
        kernel: 'Linux',
        osfamily: 'RedHat',
        operatingsystem: 'RedHat',
        operatingsystemrelease: '6',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        concat_basedir: '/dne',
        is_pe: false,
      }
    end

    let(:params) do
      {
        cache_ignore_headers: 'Set-Cookie',
      }
    end

    context 'with Apache version < 2.4' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.2",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      it { is_expected.to contain_apache__mod('disk_cache') }
      it {
        is_expected.to contain_file('disk_cache.conf')
          .with(content: %r{CacheEnable disk \/\nCacheRoot \"\/var\/cache\/mod_proxy\"\nCacheDirLevels 2\nCacheDirLength 1\nCacheIgnoreHeaders Set-Cookie})
      }
    end
    context 'with Apache version >= 2.4' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.4",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      it { is_expected.to contain_apache__mod('cache_disk') }
      it {
        is_expected.to contain_file('disk_cache.conf')
          .with(content: %r{CacheEnable disk \/\nCacheRoot \"\/var\/cache\/httpd\/proxy\"\nCacheDirLevels 2\nCacheDirLength 1\nCacheIgnoreHeaders Set-Cookie})
      }
    end
  end
  context 'on a FreeBSD OS' do
    let :facts do
      {
        id: 'root',
        kernel: 'FreeBSD',
        osfamily: 'FreeBSD',
        operatingsystem: 'FreeBSD',
        operatingsystemrelease: '10',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        concat_basedir: '/dne',
        is_pe: false,
      }
    end

    let(:params) do
      {
        cache_ignore_headers: 'Set-Cookie',
      }
    end

    context 'with Apache version < 2.4' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.2",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('apache::mod::disk_cache') }
      it { is_expected.to contain_class('apache::mod::cache').that_comes_before('Class[Apache::Mod::Disk_cache]') }
      it { is_expected.to contain_apache__mod('disk_cache') }
      it {
        is_expected.to contain_file('disk_cache.conf')
          .with(content: %r{CacheEnable disk \/\nCacheRoot \"\/var\/cache\/mod_disk_cache\"\nCacheDirLevels 2\nCacheDirLength 1\nCacheIgnoreHeaders Set-Cookie})
      }
    end
    context 'with Apache version >= 2.4' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.4",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('apache::mod::disk_cache') }
      it { is_expected.to contain_class('apache::mod::cache').that_comes_before('Class[Apache::Mod::Disk_cache]') }
      it { is_expected.to contain_apache__mod('cache_disk') }
      it {
        is_expected.to contain_file('disk_cache.conf')
          .with(content: %r{CacheEnable disk \/\nCacheRoot \"\/var\/cache\/mod_cache_disk\"\nCacheDirLevels 2\nCacheDirLength 1\nCacheIgnoreHeaders Set-Cookie})
      }
    end
  end
end
