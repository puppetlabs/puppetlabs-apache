# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::worker', type: :class do
  let :pre_condition do
    'class { "apache": mpm_module => false, }'
  end

  context 'on a Debian OS' do
    include_examples 'Debian 11'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.not_to contain_apache__mod('worker') }
    it { is_expected.to contain_file('/etc/apache2/mods-available/worker.conf').with_ensure('file') }
    it { is_expected.to contain_file('/etc/apache2/mods-enabled/worker.conf').with_ensure('link') }

    context 'with Apache version >= 2.4' do
      let :params do
        {
          apache_version: '2.4',
        }
      end

      it {
        is_expected.to contain_file('/etc/apache2/mods-available/worker.load').with('ensure' => 'file',
                                                                                    'content' => "LoadModule mpm_worker_module /usr/lib/apache2/modules/mod_mpm_worker.so\n")
      }
      it { is_expected.to contain_file('/etc/apache2/mods-enabled/worker.load').with_ensure('link') }
    end
  end
  context 'on a RedHat OS' do
    include_examples 'RedHat 8'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.not_to contain_apache__mod('worker') }
    it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with_ensure('file') }

    context 'with Apache version >= 2.4' do
      let :params do
        {
          apache_version: '2.4',
        }
      end

      it { is_expected.not_to contain_apache__mod('event') }

      it {
        is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.load').with('ensure' => 'file',
                                                                          'content' => "LoadModule mpm_worker_module modules/mod_mpm_worker.so\n")
      }
    end
  end
  context 'on a FreeBSD OS' do
    include_examples 'FreeBSD 9'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.not_to contain_apache__mod('worker') }
    it { is_expected.to contain_file('/usr/local/etc/apache24/Modules/worker.conf').with_ensure('file') }
  end
  context 'on a Gentoo OS' do
    include_examples 'Gentoo'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.not_to contain_apache__mod('worker') }
    it { is_expected.to contain_file('/etc/apache2/modules.d/worker.conf').with_ensure('file') }
  end

  # Template config doesn't vary by distro
  context 'on all distros' do
    include_examples 'RedHat 8'

    context 'defaults' do
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^<IfModule mpm_worker_module>$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+ServerLimit\s+25$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+StartServers\s+2$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+MaxClients\s+150$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+MinSpareThreads\s+25$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+MaxSpareThreads\s+75$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+ThreadsPerChild\s+25$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+MaxRequestsPerChild\s+0$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+ThreadLimit\s+64$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s*ListenBacklog\s*511}) }
    end

    context 'setting params' do
      let :params do
        {
          serverlimit: 10,
          startservers: 11,
          maxrequestworkers: 12,
          minsparethreads: 13,
          maxsparethreads: 14,
          threadsperchild: 15,
          maxrequestsperchild: 16,
          threadlimit: 17,
          listenbacklog: 8,
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^<IfModule mpm_worker_module>$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+ServerLimit\s+10$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+StartServers\s+11$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').without(content: %r{^\s+MaxClients}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+MaxRequestWorkers\s+12$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+MinSpareThreads\s+13$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+MaxSpareThreads\s+14$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+ThreadsPerChild\s+15$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+MaxRequestsPerChild\s+16$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s+ThreadLimit\s+17$}) }
      it { is_expected.to contain_file('/etc/httpd/conf.modules.d/worker.conf').with(content: %r{^\s*ListenBacklog\s*8}) }
    end
  end
end
