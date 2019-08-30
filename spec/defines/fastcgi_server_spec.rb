require 'spec_helper'

describe 'apache::fastcgi::server', type: :define do
  let :pre_condition do
    'include apache'
  end
  let :title do
    'www'
  end

  on_supported_os.each do |os, facts|
    next if facts[:os]['release']['major'] == '18.04'
    next if (facts[:os]['release']['major'] == '7' || facts[:os]['release']['major'] == '8') && facts[:os]['family']['RedHat']
    context "on #{os} " do
      let :facts do
        facts
      end

      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::fastcgi') }
      case facts[:os]['family']
      when 'RedHat'
        it {
          is_expected.to contain_file("fastcgi-pool-#{title}.conf").with(
            ensure: 'file',
            path: "/etc/httpd/conf.d/fastcgi-pool-#{title}.conf",
          )
        }
      when 'Debian'
        it {
          is_expected.to contain_file("fastcgi-pool-#{title}.conf").with(
            ensure: 'file',
            path: "/etc/apache2/conf.d/fastcgi-pool-#{title}.conf",
          )
        }
      when 'FreeBSD'
        it {
          is_expected.to contain_file("fastcgi-pool-#{title}.conf").with(
            ensure: 'file',
            path: "/usr/local/etc/apache24/Includes/fastcgi-pool-#{title}.conf",
          )
        }
      when 'Gentoo'
        it {
          is_expected.to contain_file("fastcgi-pool-#{title}.conf").with(
            ensure: 'file',
            path: "/etc/apache2/conf.d/fastcgi-pool-#{title}.conf",
          )
        }
      end

      describe 'os-independent items' do
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
  end
end
