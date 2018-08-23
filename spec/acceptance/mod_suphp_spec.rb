require 'spec_helper_acceptance'

describe 'apache::mod::suphp class', if: (fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemmajrelease') != '16.04') do
  context 'default suphp config' do
    pp = <<-MANIFEST
class { 'apache':
  mpm_module => 'prefork',
}
host { 'suphp.example.com': ip => '127.0.0.1', }
apache::vhost { 'suphp.example.com':
  port    => '80',
  docroot => '/var/www/suphp',
}
file { '/var/www/suphp/index.php':
  ensure  => file,
  owner   => 'daemon',
  group   => 'daemon',
  content => "<?php echo get_current_user(); ?>\\n",
  require => File['/var/www/suphp'],
  before  => Class['apache::mod::php'],
}
class { 'apache::mod::php': }
class { 'apache::mod::suphp': }
    MANIFEST
    # rubocop:enable Layout/IndentHeredoc
    it 'succeeds in puppeting suphp' do
      apply_manifest(pp, catch_failures: true)
    end

    describe service('apache2') do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    it 'answers to suphp.example.com #timeout' do
      timeout = 0
      loop do
        r = shell('curl suphp.example.com:80')
        timeout += 1
        break if r.stdout =~ %r{^daemon$}
        break expect(timeout < 40).to be true if timeout > 40
        sleep(1)
      end
    end
    it 'answers to suphp.example.com #stdout' do
      shell('/usr/bin/curl suphp.example.com:80') do |r|
        expect(r.stdout).to match(%r{^daemon$})
      end
    end
    it 'answers to suphp.example.com #exit_code' do
      shell('/usr/bin/curl suphp.example.com:80') do |r|
        expect(r.exit_code).to eq(0)
      end
    end
  end
end
