# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::disk_cache', type: :class do
  context 'on a Debian OS' do
    include_examples 'Debian 11'

    let(:params) do
      {
        cache_ignore_headers: 'Set-Cookie',
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
    context 'with $default_cache_enable = false' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.4",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      let(:params) { { 'default_cache_enable' => false } }

      it { is_expected.to compile }
      it { is_expected.to contain_class('apache::mod::disk_cache') }
      it { is_expected.to contain_class('apache::mod::cache').that_comes_before('Class[Apache::Mod::Disk_cache]') }
      it { is_expected.to contain_apache__mod('cache_disk') }
      it {
        is_expected.to contain_file('disk_cache.conf')
          .with(content: %r{CacheRoot \"\/var\/cache\/apache2\/mod_cache_disk\"\nCacheDirLevels 2\nCacheDirLength 1\n})
      }
    end
    context 'with $default_cache_enable = true' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.4",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      let(:params) { { 'default_cache_enable' => true } }

      it { is_expected.to compile }
      it { is_expected.to contain_class('apache::mod::disk_cache') }
      it { is_expected.to contain_class('apache::mod::cache').that_comes_before('Class[Apache::Mod::Disk_cache]') }
      it { is_expected.to contain_apache__mod('cache_disk') }
      it {
        is_expected.to contain_file('disk_cache.conf')
          .with(content: %r{CacheEnable disk \/\nCacheRoot \"\/var\/cache\/apache2\/mod_cache_disk\"\nCacheDirLevels 2\nCacheDirLength 1\n})
      }
    end
    context 'with $default_cache_enable = foo' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.4",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      let(:params) { { 'default_cache_enable' => 'foo' } }

      it { is_expected.not_to compile }
    end
  end

  context 'on a RedHat 8-based OS' do
    include_examples 'RedHat 8'

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
          .with(content: %r{CacheEnable disk \/\nCacheRoot \"\/var\/cache\/httpd\/proxy\"\nCacheDirLevels 2\nCacheDirLength 1})
      }
    end
    context 'with $default_cache_enable = false' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.4",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      let(:params) { { 'default_cache_enable' => false } }

      it { is_expected.to compile }
      it { is_expected.to contain_class('apache::mod::disk_cache') }
      it { is_expected.to contain_class('apache::mod::cache').that_comes_before('Class[Apache::Mod::Disk_cache]') }
      it { is_expected.to contain_apache__mod('cache_disk') }
      it {
        is_expected.to contain_file('disk_cache.conf')
          .with(content: %r{CacheRoot \"\/var\/cache\/httpd\/proxy\"\nCacheDirLevels 2\nCacheDirLength 1\n})
      }
    end
    context 'with $default_cache_enable = true' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.4",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      let(:params) { { 'default_cache_enable' => true } }

      it { is_expected.to compile }
      it { is_expected.to contain_class('apache::mod::disk_cache') }
      it { is_expected.to contain_class('apache::mod::cache').that_comes_before('Class[Apache::Mod::Disk_cache]') }
      it { is_expected.to contain_apache__mod('cache_disk') }
      it {
        is_expected.to contain_file('disk_cache.conf')
          .with(content: %r{CacheEnable disk \/\nCacheRoot \"\/var\/cache\/httpd\/proxy\"\nCacheDirLevels 2\nCacheDirLength 1\n})
      }
    end
    context 'with $default_cache_enable = foo' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.4",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      let(:params) { { 'default_cache_enable' => 'foo' } }

      it { is_expected.not_to compile }
    end
  end
  context 'on a FreeBSD OS' do
    include_examples 'FreeBSD 10'

    let(:params) do
      {
        cache_ignore_headers: 'Set-Cookie',
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
    context 'with $default_cache_enable = false' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.4",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      let(:params) { { 'default_cache_enable' => false } }

      it { is_expected.to compile }
      it { is_expected.to contain_class('apache::mod::disk_cache') }
      it { is_expected.to contain_class('apache::mod::cache').that_comes_before('Class[Apache::Mod::Disk_cache]') }
      it { is_expected.to contain_apache__mod('cache_disk') }
      it {
        is_expected.to contain_file('disk_cache.conf')
          .with(content: %r{CacheRoot \"\/var\/cache\/mod_cache_disk\"\nCacheDirLevels 2\nCacheDirLength 1\n})
      }
    end
    context 'with $default_cache_enable = true' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.4",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      let(:params) { { 'default_cache_enable' => true } }

      it { is_expected.to compile }
      it { is_expected.to contain_class('apache::mod::disk_cache') }
      it { is_expected.to contain_class('apache::mod::cache').that_comes_before('Class[Apache::Mod::Disk_cache]') }
      it { is_expected.to contain_apache__mod('cache_disk') }
      it {
        is_expected.to contain_file('disk_cache.conf')
          .with(content: %r{CacheEnable disk \/\nCacheRoot \"\/var\/cache\/mod_cache_disk\"\nCacheDirLevels 2\nCacheDirLength 1\n})
      }
    end
    context 'with $default_cache_enable = foo' do
      let :pre_condition do
        'class{ "apache":
          apache_version => "2.4",
          default_mods   => ["cache"],
          mod_dir        => "/tmp/junk",
         }'
      end

      let(:params) { { 'default_cache_enable' => 'foo' } }

      it { is_expected.not_to compile }
    end
  end
end
