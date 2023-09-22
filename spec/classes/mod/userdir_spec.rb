# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::userdir', type: :class do
  context 'on a Debian OS' do
    let :pre_condition do
      'class { "apache":
         default_mods => false,
         mod_dir      => "/tmp/junk",
       }'
    end

    include_examples 'Debian 11'

    context 'default parameters' do
      it { is_expected.to compile }
    end

    context 'with path set to something' do
      let :params do
        {
          path: '/home/*/*/public_html'
        }
      end

      it { is_expected.to contain_file('userdir.conf').with_content(%r{^\s*UserDir\s+/home/\*/\*/public_html$}) }
      it { is_expected.to contain_file('userdir.conf').with_content(%r{^\s*<Directory\s+"/home/\*/\*/public_html">$}) }
    end

    context 'with userdir set to something' do
      let :params do
        {
          path: '/home/*/*/public_html',
          userdir: 'public_html'
        }
      end

      it { is_expected.to contain_file('userdir.conf').with_content(%r{^\s*UserDir\s+public_html$}) }
      it { is_expected.to contain_file('userdir.conf').with_content(%r{^\s*<Directory\s+"/home/\*/\*/public_html">$}) }
    end

    context 'with unmanaged_path set to true' do
      let :params do
        {
          unmanaged_path: true
        }
      end

      it { is_expected.to contain_file('userdir.conf').with_content(%r{^\s*UserDir\s+/home/\*/public_html$}) }
      it { is_expected.not_to contain_file('userdir.conf').with_content(%r{^\s*<Directory }) }
    end

    context 'with custom_fragment set to something' do
      let :params do
        {
          custom_fragment: 'custom_test_string'
        }
      end

      it { is_expected.to contain_file('userdir.conf').with_content(%r{custom_test_string}) }
    end
  end
end
