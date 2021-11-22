# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::prefork', type: :class do
  let :pre_condition do
    'class { "apache": mpm_module => false, }'
  end

  context 'on a Debian OS' do
    include_examples 'Debian 11'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.not_to contain_apache__mod('prefork') }
    it { is_expected.to contain_file('/etc/apache2/mods-available/prefork.conf').with_ensure('file') }
    it { is_expected.to contain_file('/etc/apache2/mods-enabled/prefork.conf').with_ensure('link') }

    context 'with Apache version < 2.4' do
      let :params do
        {
          apache_version: '2.2',
        }
      end

      it { is_expected.not_to contain_file('/etc/apache2/mods-available/prefork.load') }
      it { is_expected.not_to contain_file('/etc/apache2/mods-enabled/prefork.load') }

      it { is_expected.to contain_package('apache2-mpm-prefork') }
    end

    context 'with Apache version >= 2.4' do
      let :params do
        {
          apache_version: '2.4',
        }
      end

      it {
        is_expected.to contain_file('/etc/apache2/mods-available/prefork.load').with('ensure' => 'file',
                                                                                     'content' => "LoadModule mpm_prefork_module /usr/lib/apache2/modules/mod_mpm_prefork.so\n")
      }
      it { is_expected.to contain_file('/etc/apache2/mods-enabled/prefork.load').with_ensure('link') }
    end
  end
  context 'on a RedHat OS' do
    include_examples 'RedHat 6'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.not_to contain_apache__mod('prefork') }
    it { is_expected.to contain_file('/etc/httpd/conf.d/prefork.conf').with_ensure('file') }

    context 'with Apache version < 2.4' do
      let :params do
        {
          apache_version: '2.2',
        }
      end

      it {
        is_expected.to contain_file_line('/etc/sysconfig/httpd prefork enable').with('require' => 'Package[httpd]')
      }
      it { is_expected.to contain_file('/etc/httpd/conf.d/prefork.conf').without('content' => %r{MaxRequestWorkers}) }
      it { is_expected.to contain_file('/etc/httpd/conf.d/prefork.conf').without('content' => %r{MaxConnectionsPerChild}) }
    end

    context 'with Apache version >= 2.4' do
      let :params do
        {
          apache_version: '2.4',
          maxrequestworkers: '512',
          maxconnectionsperchild: '4000',
        }
      end

      it { is_expected.not_to contain_apache__mod('event') }

      it {
        is_expected.to contain_file('/etc/httpd/conf.d/prefork.load').with('ensure' => 'file',
                                                                           'content' => "LoadModule mpm_prefork_module modules/mod_mpm_prefork.so\n")
      }
      it { is_expected.to contain_file('/etc/httpd/conf.d/prefork.conf').without('content' => %r{MaxClients}) }
      it { is_expected.to contain_file('/etc/httpd/conf.d/prefork.conf').without('content' => %r{MaxRequestsPerChild}) }
    end
  end
  context 'on a FreeBSD OS' do
    include_examples 'FreeBSD 9'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.not_to contain_apache__mod('prefork') }
    it { is_expected.to contain_file('/usr/local/etc/apache24/Modules/prefork.conf').with_ensure('file') }
  end
  context 'on a Gentoo OS' do
    include_examples 'Gentoo'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.not_to contain_apache__mod('prefork') }
    it { is_expected.to contain_file('/etc/apache2/modules.d/prefork.conf').with_ensure('file') }
  end
end
