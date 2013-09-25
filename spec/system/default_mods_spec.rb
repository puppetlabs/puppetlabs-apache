require 'spec_helper_system'

case node.facts['osfamily']
when 'RedHat'
  servicename = 'httpd'
when 'Debian'
  servicename = 'apache2'
else
  raise Error, "Unconfigured OS for apache service on #{node.facts['osfamily']}"
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
      puppet_apply(pp) do |r|
        [0,2].should include(r.exit_code)
        r.refresh
        r.exit_code.should be_zero
      end
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

      # Run it twice and test for idempotency
      puppet_apply(pp) do |r|
        [4,6].should include(r.exit_code)
      end
    end

    describe "service #{servicename}" do
      it 'should not be running' do
        shell("pidof #{servicename}") do |r|
          r.exit_code.should eq(1)
        end
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

      # Run it twice and test for idempotency
      puppet_apply(pp) do |r|
        [0,2].should include(r.exit_code)
        r.refresh
        r.exit_code.should be_zero
      end
    end

    describe service(servicename) do
      it { should be_running }
    end
  end
end
