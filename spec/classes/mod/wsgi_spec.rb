# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::wsgi', type: :class do
  it_behaves_like 'a mod class, without including apache'
  context 'on a Debian OS' do
    include_examples 'Debian 11'

    it { is_expected.to contain_class('apache::params') }
    it {
      is_expected.to contain_class('apache::mod::wsgi').with(
        'wsgi_socket_prefix' => nil,
      )
    }
    it { is_expected.to contain_package('libapache2-mod-wsgi-py3') }
  end
  context 'on a RedHat OS' do
    include_examples 'RedHat 6'

    it { is_expected.to contain_class('apache::params') }
    it {
      is_expected.to contain_class('apache::mod::wsgi').with(
        'wsgi_socket_prefix' => '/var/run/wsgi',
      )
    }
    it { is_expected.to contain_package('mod_wsgi') }

    context 'on RHEL8' do
      include_examples 'RedHat 8'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_file('wsgi.load').with_content(%r{LoadModule wsgi_module modules/mod_wsgi_python3.so}) }
      it { is_expected.to contain_package('python3-mod_wsgi') }
    end

    describe 'with WSGIRestrictEmbedded enabled' do
      let :params do
        { wsgi_restrict_embedded: 'On' }
      end

      it { is_expected.to contain_file('wsgi.conf').with_content(%r{^  WSGIRestrictEmbedded On$}) }
    end
    describe 'with custom WSGISocketPrefix' do
      let :params do
        { wsgi_socket_prefix: 'run/wsgi' }
      end

      it { is_expected.to contain_file('wsgi.conf').with_content(%r{^  WSGISocketPrefix run\/wsgi$}) }
    end
    describe 'with custom WSGIPythonHome' do
      let :params do
        { wsgi_python_home: '/path/to/virtenv' }
      end

      it { is_expected.to contain_file('wsgi.conf').with_content(%r{^  WSGIPythonHome "\/path\/to\/virtenv"$}) }
    end
    describe 'with custom WSGIApplicationGroup' do
      let :params do
        { wsgi_application_group: '%{GLOBAL}' }
      end

      it { is_expected.to contain_file('wsgi.conf').with_content(%r{^  WSGIApplicationGroup "%{GLOBAL}"$}) }
    end
    describe 'with custom WSGIPythonOptimize' do
      let :params do
        { wsgi_python_optimize: 1 }
      end

      it { is_expected.to contain_file('wsgi.conf').with_content(%r{^  WSGIPythonOptimize 1$}) }
    end
    describe 'with custom package_name and mod_path' do
      let :params do
        {
          package_name: 'mod_wsgi_package',
          mod_path: '/foo/bar/baz',
        }
      end

      it {
        is_expected.to contain_apache__mod('wsgi').with('package' => 'mod_wsgi_package',
                                                        'path' => '/foo/bar/baz')
      }
      it { is_expected.to contain_package('mod_wsgi_package') }
      it { is_expected.to contain_file('wsgi.load').with_content(%r{LoadModule wsgi_module /foo/bar/baz}) }
    end
    describe 'with custom mod_path not containing /' do
      let :params do
        {
          package_name: 'mod_wsgi_package',
          mod_path: 'wsgi_mod_name.so',
        }
      end

      it {
        is_expected.to contain_apache__mod('wsgi').with('path' => 'modules/wsgi_mod_name.so',
                                                        'package' => 'mod_wsgi_package')
      }
      it { is_expected.to contain_file('wsgi.load').with_content(%r{LoadModule wsgi_module modules/wsgi_mod_name.so}) }
    end
    describe 'with package_name but no mod_path' do
      let :params do
        {
          mod_path: '/foo/bar/baz',
        }
      end

      it { is_expected.to compile.and_raise_error(%r{apache::mod::wsgi - both package_name and mod_path must be specified!}) }
    end
    describe 'with mod_path but no package_name' do
      let :params do
        {
          package_name: '/foo/bar/baz',
        }
      end

      it { is_expected.to compile.and_raise_error(%r{apache::mod::wsgi - both package_name and mod_path must be specified!}) }
    end
  end
  context 'on a FreeBSD OS' do
    include_examples 'FreeBSD 9'

    it { is_expected.to contain_class('apache::params') }
    it {
      is_expected.to contain_class('apache::mod::wsgi').with(
        'wsgi_socket_prefix' => nil,
      )
    }
    it { is_expected.to contain_package('www/mod_wsgi') }
  end
  context 'on a Gentoo OS' do
    include_examples 'Gentoo'

    it { is_expected.to contain_class('apache::params') }
    it {
      is_expected.to contain_class('apache::mod::wsgi').with(
        'wsgi_socket_prefix' => nil,
      )
    }
    it { is_expected.to contain_package('www-apache/mod_wsgi') }
  end
  context 'overriding mod_libs' do
    context 'on a RedHat OS', :compile do
      include_examples 'Fedora 28'
      let :pre_condition do
        <<-MANIFEST
        include apache::params
        class { 'apache':
          mod_packages => merge($::apache::params::mod_packages, {
            'wsgi' => 'python3-mod_wsgi',
          }),
          mod_libs => merge($::apache::params::mod_libs, {
            'wsgi' => 'mod_wsgi_python3.so',
          })
        }
        MANIFEST
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_file('wsgi.load').with_content(%r{LoadModule wsgi_module modules/mod_wsgi_python3.so}) }
      it { is_expected.to contain_package('python3-mod_wsgi') }
    end
  end
end
