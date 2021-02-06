# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::python', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'on a Debian OS' do
    include_examples 'Debian 8'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('python') }
    it { is_expected.to contain_package('libapache2-mod-python') }
  end
  context 'on a RedHat OS' do
    include_examples 'RedHat 6'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('python') }
    it { is_expected.to contain_package('mod_python') }
    it { is_expected.to contain_file('python.load').with_path('/etc/httpd/conf.d/python.load') }

    describe 'with loadfile_name specified' do
      let :params do
        { loadfile_name: 'FooBar' }
      end

      it { is_expected.to contain_file('FooBar').with_path('/etc/httpd/conf.d/FooBar') }
    end
  end
  context 'on a FreeBSD OS' do
    include_examples 'FreeBSD 9'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('python') }
    it { is_expected.to contain_package('www/mod_python3') }
  end
  context 'on a Gentoo OS' do
    include_examples 'Gentoo'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('python') }
    it { is_expected.to contain_package('www-apache/mod_python') }
  end
end
