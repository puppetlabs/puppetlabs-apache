require 'spec_helper'

describe 'apache::fastcgi::server', type: :define do
  let :pre_condition do
    'include apache'
  end
  let :title do
    'www'
  end

  describe 'os-dependent items' do
    context 'on RedHat based systems' do
      let :default_facts do
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
      let(:facts) { default_facts }

      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::fastcgi') }
      it {
        is_expected.to contain_file("fastcgi-pool-#{title}.conf").with(
          ensure: 'file',
          path: "/etc/httpd/conf.d/fastcgi-pool-#{title}.conf",
        )
      }
    end
    context 'on Debian based systems' do
      let :default_facts do
        {
          osfamily: 'Debian',
          operatingsystem: 'Debian',
          operatingsystemrelease: '8',
          lsbdistcodename: 'jessie',
          kernel: 'Linux',
          id: 'root',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end
      let(:facts) { default_facts }

      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::fastcgi') }
      it {
        is_expected.to contain_file("fastcgi-pool-#{title}.conf").with(
          ensure: 'file',
          path: "/etc/apache2/conf.d/fastcgi-pool-#{title}.conf",
        )
      }
    end
    context 'on FreeBSD systems' do
      let :default_facts do
        {
          osfamily: 'FreeBSD',
          operatingsystem: 'FreeBSD',
          operatingsystemrelease: '9',
          kernel: 'FreeBSD',
          id: 'root',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end
      let(:facts) { default_facts }

      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::fastcgi') }
      it {
        is_expected.to contain_file("fastcgi-pool-#{title}.conf").with(
          ensure: 'file',
          path: "/usr/local/etc/apache24/Includes/fastcgi-pool-#{title}.conf",
        )
      }
    end
    context 'on Gentoo systems' do
      let :default_facts do
        {
          osfamily: 'Gentoo',
          operatingsystem: 'Gentoo',
          operatingsystemrelease: '3.16.1-gentoo',
          kernel: 'Linux',
          id: 'root',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin',
          is_pe: false,
        }
      end
      let(:facts) { default_facts }

      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::fastcgi') }
      it {
        is_expected.to contain_file("fastcgi-pool-#{title}.conf").with(
          ensure: 'file',
          path: "/etc/apache2/conf.d/fastcgi-pool-#{title}.conf",
        )
      }
    end
  end
  describe 'os-independent items' do
    let :facts do
      {
        osfamily: 'Debian',
        operatingsystem: 'Debian',
        operatingsystemrelease: '8',
        lsbdistcodename: 'jessie',
        kernel: 'Linux',
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    describe '.conf content using TCP communication' do
      let :params do
        {
          host: '127.0.0.1:9001',
          timeout: 30,
          flush: true,
          faux_path: '/var/www/php-www.fcgi',
          fcgi_alias: '/php-www.fcgi',
          file_type: 'application/x-httpd-php',
          pass_header: 'Authorization',
        }
      end
      let :expected do
# rubocop:disable Layout/IndentationWidth : Changes to the indent causes test failures.
'FastCGIExternalServer /var/www/php-www.fcgi -idle-timeout 30 -flush -host 127.0.0.1:9001 -pass-header Authorization
Alias /php-www.fcgi /var/www/php-www.fcgi
Action application/x-httpd-php /php-www.fcgi
'
        # rubocop:enable Layout/IndentationWidth
      end

      it do
        is_expected.to contain_file('fastcgi-pool-www.conf').with_content(expected)
      end
    end
    describe '.conf content using socket communication' do
      let :params do
        {
          host: '/var/run/fcgi.sock',
          timeout: 30,
          flush: true,
          faux_path: '/var/www/php-www.fcgi',
          fcgi_alias: '/php-www.fcgi',
          file_type: 'application/x-httpd-php',
        }
      end
      let :expected do
# rubocop:disable Layout/IndentationWidth : Changes to the indent causes test failures.
'FastCGIExternalServer /var/www/php-www.fcgi -idle-timeout 30 -flush -socket /var/run/fcgi.sock
Alias /php-www.fcgi /var/www/php-www.fcgi
Action application/x-httpd-php /php-www.fcgi
'
        # rubocop:enable Layout/IndentationWidth
      end

      it do
        is_expected.to contain_file('fastcgi-pool-www.conf').with_content(expected)
      end
    end
  end
end
