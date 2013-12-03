require 'spec_helper_acceptance'

case fact('osfamily')
when 'RedHat'
  servicename = 'httpd'
when 'Debian'
  servicename = 'apache2'
when 'FreeBSD'
  servicename = 'apache22'
else
  raise "Unconfigured OS for apache service on #{fact('osfamily')}"
end

describe 'apache::default_mods class' do
  describe 'no default mods' do
    # Using puppet_apply as a helper
    it 'should apply with no errors' do
      pp = <<-EOS
        class { 'apache':
          default_mods => false,
        }
      EOS

      # Run it twice and test for idempotency
      expect([0,2]).to include (apply_manifest(pp).exit_code)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe service(servicename) do
      it { should be_running }
    end
  end

  describe 'no default mods and failing' do
    # Using puppet_apply as a helper
    it 'should apply with errors' do
      pp = <<-EOS
        class { 'apache':
          default_mods => false,
        }
        apache::vhost { 'defaults.example.com':
          docroot => '/var/www/defaults',
          aliases => {
            alias => '/css',
            path  => '/var/www/css',
          },
          setenv  => 'TEST1 one',
        }
      EOS

      apply_manifest(pp, { :acceptable_exit_codes => [4,6], :catch_failures => true })
    end

    describe "service #{servicename}" do
      it 'should not be running' do
        shell("pidof #{servicename}", {:acceptable_exit_codes => 1})
      end
    end
  end

  describe 'alternative default mods' do
    # Using puppet_apply as a helper
    it 'should apply with no errors' do
      pp = <<-EOS
        class { 'apache':
          default_mods => [
            'info',
            'alias',
            'mime',
            'env',
            'expires',
          ],
        }
        apache::vhost { 'defaults.example.com':
          docroot => '/var/www/defaults',
          aliases => {
            alias => '/css',
            path  => '/var/www/css',
          },
          setenv  => 'TEST1 one',
        }
      EOS

      expect([0,2]).to include (apply_manifest(pp).exit_code)
      shell('sleep 10')
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe service(servicename) do
      it { should be_running }
    end
  end
end
