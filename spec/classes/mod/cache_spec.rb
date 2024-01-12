# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::cache', type: :class do
  context 'on a Debian OS' do
    include_examples 'Debian 11'

    it { is_expected.to compile }
    it { is_expected.to contain_class('apache::mod::cache') }
    it { is_expected.to contain_apache__mod('cache') }

    it {
      expect(subject).to contain_file('cache.conf')
                           .with(content: '')
    }

    describe 'with cache_ignore_headers' do
      let(:params) do
        {
          cache_ignore_headers: 'Set-Cookie',
        }
      end

      it {
        expect(subject).to contain_file('cache.conf')
                             .with(content: %r{CacheIgnoreHeaders Set-Cookie})
      }
    end

    describe 'with cache_default_expire' do
      let(:params) do
        {
          cache_default_expire: 2000,
        }
      end

      it {
        expect(subject).to contain_file('cache.conf')
                             .with(content: %r{CacheDefaultExpire 2000})
      }
    end

    describe 'with cache_max_expire' do
      let(:params) do
        {
          cache_max_expire: 2000,
        }
      end

      it {
        expect(subject).to contain_file('cache.conf')
                             .with(content: %r{CacheMaxExpire 2000})
      }
    end

    describe 'with cache_ignore_no_lastmod' do
      let(:params) do
        {
          cache_ignore_no_lastmod: 'On',
        }
      end

      it {
        expect(subject).to contain_file('cache.conf')
                             .with(content: %r{CacheIgnoreNoLastMod On})
      }
    end

    describe 'with cache_header' do
      let(:params) do
        {
          cache_header: 'On',
        }
      end

      it {
        expect(subject).to contain_file('cache.conf')
                             .with(content: %r{CacheHeader On})
      }
    end

    describe 'with cache_lock' do
      let(:params) do
        {
          cache_lock: 'On',
        }
      end

      it {
        expect(subject).to contain_file('cache.conf')
                             .with(content: %r{CacheLock On})
      }
    end

    describe 'with cache_ignore_cache_control' do
      let(:params) do
        {
          cache_ignore_cache_control: 'On',
        }
      end

      it {
        expect(subject).to contain_file('cache.conf')
                             .with(content: %r{CacheIgnoreCacheControl On})
      }
    end

  end
end
