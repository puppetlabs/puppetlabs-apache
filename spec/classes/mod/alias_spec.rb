# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::alias', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    context 'on a Debian OS', :compile do
      include_examples 'Debian 11'

      it { is_expected.to contain_apache__mod('alias') }
      it { is_expected.to contain_file('alias.conf').with(content: %r{Alias \/icons\/ "\/usr\/share\/apache2\/icons\/"}) }
    end

    context 'on a RedHat 7-based OS', :compile do
      include_examples 'RedHat 7'

      it { is_expected.to contain_apache__mod('alias') }
      it { is_expected.to contain_file('alias.conf').with(content: %r{Alias \/icons\/ "\/usr\/share\/httpd\/icons\/"}) }
    end

    context 'on a RedHat 8-based OS', :compile do
      include_examples 'RedHat 8'

      it { is_expected.to contain_apache__mod('alias') }
      it { is_expected.to contain_file('alias.conf').with(content: %r{Alias \/icons\/ "\/usr\/share\/httpd\/icons\/"}) }
    end

    context 'with icons options', :compile do
      let :pre_condition do
        'class { apache: default_mods => false }'
      end
      let :params do
        {
          'icons_options' => 'foo'
        }
      end

      include_examples 'RedHat 7'

      it { is_expected.to contain_apache__mod('alias') }
      it { is_expected.to contain_file('alias.conf').with(content: %r{Options foo}) }
    end

    context 'with icons path change', :compile do
      let :pre_condition do
        'class { apache: default_mods => false }'
      end
      let :params do
        {
          'icons_prefix' => 'apache-icons'
        }
      end

      include_examples 'RedHat 7'

      it { is_expected.to contain_apache__mod('alias') }
      it { is_expected.to contain_file('alias.conf').with(content: %r{Alias \/apache-icons\/ "\/usr\/share\/httpd\/icons\/"}) }
    end

    context 'with icons path as false', :compile do
      let :pre_condition do
        'class { apache: default_mods => false }'
      end
      let :params do
        {
          'icons_path' => false
        }
      end

      include_examples 'RedHat 7'

      it { is_expected.to contain_apache__mod('alias') }
      it { is_expected.not_to contain_file('alias.conf') }
    end

    context 'on a FreeBSD OS', :compile do
      include_examples 'FreeBSD 10'

      it { is_expected.to contain_apache__mod('alias') }
      it { is_expected.to contain_file('alias.conf').with(content: %r{Alias \/icons\/ "\/usr\/local\/www\/apache24\/icons\/"}) }
    end
  end
end
