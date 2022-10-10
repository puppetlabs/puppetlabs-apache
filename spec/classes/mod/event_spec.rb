# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::event', type: :class do
  let :pre_condition do
    'class { "apache": mpm_module => false, }'
  end

  context 'on a FreeBSD OS' do
    include_examples 'FreeBSD 9'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.not_to contain_apache__mod('event') }
    it { is_expected.to contain_file('/usr/local/etc/apache24/Modules/event.conf').with_ensure('file') }
  end
  context 'on a Gentoo OS' do
    include_examples 'Gentoo'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.not_to contain_apache__mod('event') }
    it { is_expected.to contain_file('/etc/apache2/modules.d/event.conf').with_ensure('file') }
  end
  context 'on a Debian OS' do
    include_examples 'Debian 11'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.not_to contain_apache__mod('event') }
    it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file') }
    it { is_expected.to contain_file('/etc/apache2/mods-enabled/event.conf').with_ensure('link') }

    context 'Test mpm_event new params' do
      let :params do
        {
          serverlimit: 0,
          startservers: 1,
          minsparethreads: 3,
          maxsparethreads: 4,
          threadsperchild: 5,
          threadlimit: 7,
          listenbacklog: 8,
          maxrequestworkers: 9,
          maxconnectionsperchild: 10,
        }
      end

      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*ServerLimit\s*0}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*StartServers\s*1}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*MinSpareThreads\s*3}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*MaxSpareThreads\s*4}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*ThreadsPerChild\s*5}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*ThreadLimit\s*7}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*ListenBacklog\s*8}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*MaxRequestWorkers\s*9}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*MaxConnectionsPerChild\s*10}) }
    end

    context 'Test mpm_event old style params' do
      let :params do
        {
          serverlimit: 0,
          startservers: 1,
          minsparethreads: 3,
          maxsparethreads: 4,
          threadsperchild: 5,
          threadlimit: 7,
          listenbacklog: 8,
          maxrequestworkers: :undef,
          maxconnectionsperchild: :undef,
        }
      end

      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*ServerLimit\s*0}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*StartServers\s*1}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*MinSpareThreads\s*3}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*MaxSpareThreads\s*4}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*ThreadsPerChild\s*5}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*ThreadLimit\s*7}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').with_content(%r{^\s*ListenBacklog\s*8}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').without_content(%r{^\s*MaxRequestWorkers}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').without_content(%r{^\s*MaxConnectionsPerChild}) }
    end

    context 'Test mpm_event false params' do
      let :params do
        {
          serverlimit: false,
          startservers: false,
          minsparethreads: false,
          maxsparethreads: false,
          threadsperchild: false,
          threadlimit: false,
          listenbacklog: false,
          maxrequestworkers: false,
          maxconnectionsperchild: false,
        }
      end

      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').without_content(%r{^\s*ServerLimit}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').without_content(%r{^\s*StartServers}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').without_content(%r{^\s*MinSpareThreads}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').without_content(%r{^\s*MaxSpareThreads}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').without_content(%r{^\s*ThreadsPerChild}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').without_content(%r{^\s*ThreadLimit}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').without_content(%r{^\s*ListenBacklog}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').without_content(%r{^\s*MaxRequestWorkers}) }
      it { is_expected.to contain_file('/etc/apache2/mods-available/event.conf').with_ensure('file').without_content(%r{^\s*MaxConnectionsPerChild}) }
    end

    it {
      is_expected.to contain_file('/etc/apache2/mods-available/event.load').with('ensure' => 'file',
                                                                                 'content' => "LoadModule mpm_event_module /usr/lib/apache2/modules/mod_mpm_event.so\n")
    }
    it { is_expected.to contain_file('/etc/apache2/mods-enabled/event.load').with_ensure('link') }
  end
  context 'on a RedHat OS' do
    include_examples 'RedHat 8'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.not_to contain_apache__mod('worker') }
    it { is_expected.not_to contain_apache__mod('prefork') }

    it { is_expected.to contain_file('/etc/httpd/conf.modules.d/event.conf').with_ensure('file') }

    it {
      is_expected.to contain_file('/etc/httpd/conf.modules.d/event.load').with('ensure' => 'file',
                                                                       'content' => "LoadModule mpm_event_module modules/mod_mpm_event.so\n")
    }
  end
end
