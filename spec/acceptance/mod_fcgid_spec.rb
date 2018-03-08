require 'spec_helper_acceptance'

describe 'apache::mod::fcgid class', if: ((fact('osfamily') == 'RedHat' && fact('operatingsystemmajrelease') != '5') &&
                                         !(fact('operatingsystem') == 'OracleLinux' && fact('operatingsystemmajrelease') == '7')) do
  context 'default fcgid config' do
    pp = <<-MANIFEST
        class { 'epel': } # mod_fcgid lives in epel
        class { 'apache': }
        class { 'apache::mod::php': } # For /usr/bin/php-cgi
        class { 'apache::mod::fcgid':
          options => {
            'FcgidIPCDir'  => '/var/run/fcgidsock',
          },
        }
        apache::vhost { 'fcgid.example.com':
          port        => '80',
          docroot     => '/var/www/fcgid',
          directories => {
            path        => '/var/www/fcgid',
            options     => '+ExecCGI',
            addhandlers => {
              handler    => 'fcgid-script',
              extensions => '.php',
            },
            fcgiwrapper => {
              command => '/usr/bin/php-cgi',
              suffix  => '.php',
            }
          },
        }
        file { '/var/www/fcgid/index.php':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          content => "<?php echo 'Hello world'; ?>\\n",
        }
    MANIFEST
    it 'succeeds in puppeting fcgid' do
      apply_manifest(pp, catch_failures: true)
    end

    describe service('httpd') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    it 'answers to fcgid.example.com' do
      shell("/usr/bin/curl -H 'Host: fcgid.example.com' 127.0.0.1:80") do |r|
        expect(r.stdout).to match(%r{^Hello world$})
        expect(r.exit_code).to eq(0)
      end
    end

    it 'runs a php-cgi process' do
      shell('pgrep -u apache php-cgi', acceptable_exit_codes: [0])
    end
  end
end
