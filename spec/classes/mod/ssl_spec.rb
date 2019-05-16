require 'spec_helper'

describe 'apache::mod::ssl', type: :class do
  it_behaves_like 'a mod class, without including apache'
  context 'on an unsupported OS' do
    let :facts do
      {
        osfamily: 'Magic',
        operatingsystemrelease: '0',
        operatingsystem: 'Magic',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    it { expect { catalogue }.to raise_error(Puppet::Error, %r{Unsupported osfamily:}) }
  end

  context 'on a RedHat' do
    context '6 OS' do
      let :facts do
        {
          osfamily: 'RedHat',
          operatingsystemrelease: '6',
          operatingsystem: 'RedHat',
          id: 'root',
          kernel: 'Linux',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('ssl') }
      it { is_expected.to contain_package('mod_ssl') }
      it { is_expected.to contain_file('ssl.conf').with_path('/etc/httpd/conf.d/ssl.conf') }
    end
    context '6 OS with a custom package_name parameter' do
      let :facts do
        {
          osfamily: 'RedHat',
          operatingsystemrelease: '6',
          operatingsystem: 'RedHat',
          id: 'root',
          kernel: 'Linux',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end
      let :params do
        { package_name: 'httpd24-mod_ssl' }
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('ssl') }
      it { is_expected.to contain_package('httpd24-mod_ssl') }
      it { is_expected.not_to contain_package('mod_ssl') }
      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLSessionCache "shmcb:/var/cache/mod_ssl/scache\(512000\)"$}) }
    end

    context '7 OS with custom directories for PR#1635' do
      let :facts do
        {
          osfamily: 'RedHat',
          operatingsystemrelease: '7',
          operatingsystem: 'RedHat',
          id: 'root',
          kernel: 'Linux',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end
      let :pre_condition do
        "class { 'apache':
          confd_dir           => '/etc/httpd/conf.puppet.d',
          default_mods        => false,
          default_vhost       => false,
          mod_dir             => '/etc/httpd/conf.modules.puppet.d',
          vhost_dir           => '/etc/httpd/conf.puppet.d',
        }"
      end

      it { is_expected.to contain_package('mod_ssl') }
      it { is_expected.to contain_file('ssl.conf').with_path('/etc/httpd/conf.puppet.d/ssl.conf') }
    end
  end

  context 'on a Debian OS' do
    let :facts do
      {
        osfamily: 'Debian',
        operatingsystemrelease: '8',
        lsbdistcodename: 'jessie',
        operatingsystem: 'Debian',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('ssl') }
    it { is_expected.not_to contain_package('libapache2-mod-ssl') }
  end

  context 'on a FreeBSD OS' do
    let :facts do
      {
        osfamily: 'FreeBSD',
        operatingsystemrelease: '9',
        operatingsystem: 'FreeBSD',
        id: 'root',
        kernel: 'FreeBSD',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('ssl') }
  end

  context 'on a Gentoo OS' do
    let :facts do
      {
        osfamily: 'Gentoo',
        operatingsystem: 'Gentoo',
        operatingsystemrelease: '3.16.1-gentoo',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('ssl') }
    it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLSessionCache "shmcb:/var/run/ssl_scache\(512000\)"$}) }
  end

  context 'on a Suse OS' do
    let :facts do
      {
        osfamily: 'Suse',
        operatingsystem: 'SLES',
        operatingsystemrelease: '12',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('ssl') }
    it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLSessionCache "shmcb:/var/lib/apache2/ssl_scache\(512000\)"$}) }
  end
  # Template config doesn't vary by distro
  context 'on all distros' do
    let :facts do
      {
        osfamily: 'RedHat',
        operatingsystem: 'CentOS',
        operatingsystemrelease: '6',
        kernel: 'Linux',
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    context 'not setting ssl_pass_phrase_dialog' do
      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLPassPhraseDialog builtin$}) }
    end

    context 'setting ssl_cert' do
      let :params do
        {
          ssl_cert: '/etc/pki/some/path/localhost.crt',
        }
      end

      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLCertificateFile}) }
    end

    context 'setting ssl_key' do
      let :params do
        {
          ssl_key: '/etc/pki/some/path/localhost.key',
        }
      end

      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLCertificateKeyFile}) }
    end

    context 'setting ssl_ca to a path' do
      let :params do
        {
          ssl_ca: '/etc/pki/some/path/ca.crt',
        }
      end

      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLCACertificateFile}) }
    end

    context 'with Apache version < 2.4 - ssl_compression with default value' do
      let :params do
        {
          apache_version: '2.2',
        }
      end

      it { is_expected.not_to contain_file('ssl.conf').with_content(%r{^  SSLCompression Off$}) }
    end
    context 'with Apache version < 2.4 - setting ssl_compression to true' do
      let :params do
        {
          apache_version: '2.2',
          ssl_compression: true,
        }
      end

      it { is_expected.not_to contain_file('ssl.conf').with_content(%r{^  SSLCompression On$}) }
    end
    context 'with Apache version < 2.4 - setting ssl_stapling to true' do
      let :params do
        {
          apache_version: '2.2',
          ssl_stapling: true,
        }
      end

      it { is_expected.not_to contain_file('ssl.conf').with_content(%r{^  SSLUseStapling}) }
    end

    context 'with Apache version >= 2.4 - ssl_compression with default value' do
      let :params do
        {
          apache_version: '2.4',
        }
      end

      it { is_expected.not_to contain_file('ssl.conf').with_content(%r{^  SSLCompression Off$}) }
    end
    context 'with Apache version >= 2.4' do
      let :params do
        {
          apache_version: '2.4',
          ssl_compression: true,
        }
      end

      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLCompression On$}) }
    end

    context 'with Apache version >= 2.4 - ssl_sessiontickets with default value' do
      let :params do
        {
          apache_version: '2.4',
        }
      end

      it { is_expected.not_to contain_file('ssl.conf').with_content(%r{^  SSLSessionTickets (Off|On)$}) }
    end
    context 'with Apache version >= 2.4 - setting ssl_sessiontickets to false' do
      let :params do
        {
          apache_version: '2.4',
          ssl_sessiontickets: false,
        }
      end

      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLSessionTickets Off$}) }
    end

    context 'with Apache version >= 2.4 - setting ssl_stapling to true' do
      let :params do
        {
          apache_version: '2.4',
          ssl_stapling: true,
        }
      end

      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLUseStapling On$}) }
    end
    context 'with Apache version >= 2.4 - setting ssl_stapling_return_errors to true' do
      let :params do
        {
          apache_version: '2.4',
          ssl_stapling_return_errors: true,
        }
      end

      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLStaplingReturnResponderErrors On$}) }
    end
    context 'with Apache version >= 2.4 - setting stapling_cache' do
      let :params do
        {
          apache_version: '2.4',
          stapling_cache: '/tmp/customstaplingcache(51200)',
        }
      end

      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLStaplingCache "shmcb:/tmp/customstaplingcache\(51200\)"$}) }
    end

    context 'setting ssl_pass_phrase_dialog' do
      let :params do
        {
          ssl_pass_phrase_dialog: 'exec:/path/to/program',
        }
      end

      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLPassPhraseDialog exec:\/path\/to\/program$}) }
    end

    context 'setting ssl_random_seed_bytes' do
      let :params do
        {
          ssl_random_seed_bytes: '1024',
        }
      end

      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLRandomSeed startup file:/dev/urandom 1024$}) }
    end

    context 'setting ssl_openssl_conf_cmd' do
      let :params do
        {
          ssl_openssl_conf_cmd: 'DHParameters "foo.pem"',
        }
      end

      it { is_expected.to contain_file('ssl.conf').with_content(%r{^\s+SSLOpenSSLConfCmd DHParameters "foo.pem"$}) }
    end

    context 'setting ssl_mutex' do
      let :params do
        {
          ssl_mutex: 'posixsem',
        }
      end

      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLMutex posixsem$}) }
    end
    context 'setting ssl_sessioncache' do
      let :params do
        {
          ssl_sessioncache: '/tmp/customsessioncache(51200)',
        }
      end

      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLSessionCache "shmcb:/tmp/customsessioncache\(51200\)"$}) }
    end
    context 'setting ssl_proxy_protocol' do
      let :params do
        {
          ssl_proxy_protocol: ['-ALL', '+TLSv1'],
        }
      end

      it { is_expected.to contain_file('ssl.conf').with_content(%r{^  SSLProxyProtocol -ALL \+TLSv1$}) }
    end
  end
end
