# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::cache_disk', type: :class do
  context 'on a Debian OS' do
    include_examples 'Debian 11'

    let(:params) do
      {
        cache_enable: ['/'],
      }
    end

    let :pre_condition do
      'class{ "apache":
        default_mods   => ["cache"],
        mod_dir        => "/tmp/junk",
       }'
    end

    it { is_expected.to compile }
    it { is_expected.to contain_class('apache::mod::cache_disk') }
    it { is_expected.to contain_class('apache::mod::cache').that_comes_before('Class[Apache::Mod::Cache_disk]') }
    it { is_expected.to contain_apache__mod('cache_disk') }

    default_config = %r{CacheEnable disk /\nCacheRoot "/var/cache/apache2/mod_cache_disk"}

    it {
      expect(subject).to contain_file('cache_disk.conf')
                           .with(content: default_config)
    }

    describe 'with multiple cache_enable parameters' do
      let(:params) do
        {
          cache_enable: %w[/ /something],
        }
      end

      it {
        expect(subject).to contain_file('cache_disk.conf')
                             .with(content: %r{CacheEnable disk /\nCacheEnable disk /something\nCacheRoot "/var/cache/apache2/mod_cache_disk"})
      }
    end

    describe 'with cache_dir_length' do
      let(:params) do
        {
          cache_dir_length: 2,
          cache_enable: ['/'],
        }
      end

      it {
        expect(subject).to contain_file('cache_disk.conf')
                             .with(content: %r{#{default_config}\nCacheDirLength 2})
      }
    end

    describe 'with cache_dir_levels' do
      let(:params) do
        {
          cache_dir_levels: 2,
          cache_enable: ['/'],
        }
      end

      it {
        expect(subject).to contain_file('cache_disk.conf')
                             .with(content: %r{#{default_config}\nCacheDirLevels 2})
      }
    end
  end

  context 'on a RedHat 8-based OS' do
    include_examples 'RedHat 8'

    let(:params) do
      {
        cache_enable: ['/'],
      }
    end

    let :pre_condition do
      'class{ "apache":
        default_mods   => ["cache"],
        mod_dir        => "/tmp/junk",
       }'
    end

    it { is_expected.to compile }

    it {
      expect(subject).to contain_file('cache_disk.conf')
                           .with(content: %r{CacheEnable disk /\nCacheRoot "/var/cache/httpd/proxy"})
    }
  end

  context 'on a FreeBSD OS' do
    include_examples 'FreeBSD 10'

    let(:params) do
      {
        cache_enable: ['/'],
      }
    end

    let :pre_condition do
      'class{ "apache":
        default_mods   => ["cache"],
        mod_dir        => "/tmp/junk",
       }'
    end

    it { is_expected.to compile }

    it {
      expect(subject).to contain_file('cache_disk.conf')
                           .with(content: %r{CacheEnable disk /\nCacheRoot "/var/cache/mod_cache_disk"})
    }
  end
end
