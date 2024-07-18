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
    it { is_expected.to contain_file('/etc/apache2/mods-available/mpm_prefork.conf').with_ensure('file') }
    it { is_expected.to contain_file('/etc/apache2/mods-enabled/mpm_prefork.conf').with_ensure('link') }

    it {
      expect(subject).to contain_file('/etc/apache2/mods-available/mpm_prefork.load').with('ensure' => 'file',
                                                                                       'content' => "# Conflicts: mpm_event mpm_worker\nLoadModule mpm_prefork_module /usr/lib/apache2/modules/mod_mpm_prefork.so\n")
    }

    it { is_expected.to contain_file('/etc/apache2/mods-enabled/mpm_prefork.load').with_ensure('link') }
  end

  context 'on a RedHat OS' do
    include_examples 'RedHat 8'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.not_to contain_apache__mod('prefork') }
    it { is_expected.not_to contain_apache__mod('event') }

    it {
      expect(subject).to contain_file('/etc/httpd/conf.modules.d/prefork.load').with('ensure' => 'file',
                                                                                     'content' => "LoadModule mpm_prefork_module modules/mod_mpm_prefork.so\n")
    }
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
