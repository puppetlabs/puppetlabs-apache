# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::perl', type: :class do
  it_behaves_like 'a mod class, without including apache'
  context 'on a Debian OS' do
    include_examples 'Debian 8'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('perl') }
    it { is_expected.to contain_package('libapache2-mod-perl2') }
  end
  context 'on a RedHat OS' do
    include_examples 'RedHat 6'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('perl') }
    it { is_expected.to contain_package('mod_perl') }
  end
  context 'on a FreeBSD OS' do
    include_examples 'FreeBSD 9'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('perl') }
    it { is_expected.to contain_package('www/mod_perl2') }
  end
  context 'on a Gentoo OS' do
    include_examples 'Gentoo'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('perl') }
    it { is_expected.to contain_package('www-apache/mod_perl') }
  end
end
