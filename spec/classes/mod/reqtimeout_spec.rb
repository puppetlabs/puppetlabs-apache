# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::reqtimeout', type: :class do
  it_behaves_like 'a mod class, without including apache'
  context 'on a Debian OS' do
    include_examples 'Debian 11'

    context 'passing no parameters' do
      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('reqtimeout') }
      it { is_expected.to contain_file('reqtimeout.conf').with_content(%r{^RequestReadTimeout header=20-40,minrate=500\nRequestReadTimeout body=10,minrate=500$}) }
    end
    context "passing timeouts => ['header=20-60,minrate=600', 'body=60,minrate=600']" do
      let :params do
        { timeouts: ['header=20-60,minrate=600', 'body=60,minrate=600'] }
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('reqtimeout') }
      it { is_expected.to contain_file('reqtimeout.conf').with_content(%r{^RequestReadTimeout header=20-60,minrate=600\nRequestReadTimeout body=60,minrate=600$}) }
    end
    context "passing timeouts => 'header=20-60,minrate=600'" do
      let :params do
        { timeouts: 'header=20-60,minrate=600' }
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('reqtimeout') }
      it { is_expected.to contain_file('reqtimeout.conf').with_content(%r{^RequestReadTimeout header=20-60,minrate=600$}) }
    end
  end
  context 'on a RedHat OS' do
    include_examples 'RedHat 6'

    context 'passing no parameters' do
      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('reqtimeout') }
      it { is_expected.to contain_file('reqtimeout.conf').with_content(%r{^RequestReadTimeout header=20-40,minrate=500\nRequestReadTimeout body=10,minrate=500$}) }
    end
    context "passing timeouts => ['header=20-60,minrate=600', 'body=60,minrate=600']" do
      let :params do
        { timeouts: ['header=20-60,minrate=600', 'body=60,minrate=600'] }
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('reqtimeout') }
      it { is_expected.to contain_file('reqtimeout.conf').with_content(%r{^RequestReadTimeout header=20-60,minrate=600\nRequestReadTimeout body=60,minrate=600$}) }
    end
    context "passing timeouts => 'header=20-60,minrate=600'" do
      let :params do
        { timeouts: 'header=20-60,minrate=600' }
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('reqtimeout') }
      it { is_expected.to contain_file('reqtimeout.conf').with_content(%r{^RequestReadTimeout header=20-60,minrate=600$}) }
    end
  end
  context 'on a FreeBSD OS' do
    include_examples 'FreeBSD 9'

    context 'passing no parameters' do
      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('reqtimeout') }
      it { is_expected.to contain_file('reqtimeout.conf').with_content(%r{^RequestReadTimeout header=20-40,minrate=500\nRequestReadTimeout body=10,minrate=500$}) }
    end
    context "passing timeouts => ['header=20-60,minrate=600', 'body=60,minrate=600']" do
      let :params do
        { timeouts: ['header=20-60,minrate=600', 'body=60,minrate=600'] }
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('reqtimeout') }
      it { is_expected.to contain_file('reqtimeout.conf').with_content(%r{^RequestReadTimeout header=20-60,minrate=600\nRequestReadTimeout body=60,minrate=600$}) }
    end
    context "passing timeouts => 'header=20-60,minrate=600'" do
      let :params do
        { timeouts: 'header=20-60,minrate=600' }
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('reqtimeout') }
      it { is_expected.to contain_file('reqtimeout.conf').with_content(%r{^RequestReadTimeout header=20-60,minrate=600$}) }
    end
  end
  context 'on a Gentoo OS' do
    include_examples 'Gentoo'

    context 'passing no parameters' do
      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('reqtimeout') }
      it { is_expected.to contain_file('reqtimeout.conf').with_content(%r{^RequestReadTimeout header=20-40,minrate=500\nRequestReadTimeout body=10,minrate=500$}) }
    end
    context "passing timeouts => ['header=20-60,minrate=600', 'body=60,minrate=600']" do
      let :params do
        { timeouts: ['header=20-60,minrate=600', 'body=60,minrate=600'] }
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('reqtimeout') }
      it { is_expected.to contain_file('reqtimeout.conf').with_content(%r{^RequestReadTimeout header=20-60,minrate=600\nRequestReadTimeout body=60,minrate=600$}) }
    end
    context "passing timeouts => 'header=20-60,minrate=600'" do
      let :params do
        { timeouts: 'header=20-60,minrate=600' }
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('reqtimeout') }
      it { is_expected.to contain_file('reqtimeout.conf').with_content(%r{^RequestReadTimeout header=20-60,minrate=600$}) }
    end
  end
end
