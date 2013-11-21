require 'spec_helper_acceptance'

describe 'apache::mod::suphp class' do
  case fact('osfamily')
  when 'Debian'
    context "default suphp config" do
      it 'succeeds in puppeting suphp' do
        pp = <<-EOS
          class { 'apache':
            mpm_module => 'prefork',
          }
          class { 'apache::mod::php': }
          class { 'apache::mod::suphp': }
          apache::vhost { 'suphp.example.com':
            port    => '80',
            docroot => '/var/www/suphp',
          }
          host { 'suphp.example.com': ip => '127.0.0.1', }
          file { '/var/www/suphp/index.php':
            ensure  => file,
            owner   => 'puppet',
            group   => 'puppet',
            content => "<?php echo get_current_user(); ?>\\n",
          }
        EOS
        expect([0,2]).to include (apply_manifest(pp).exit_code)
      end

      describe service('apache2') do
        it { should be_enabled }
        it { should be_running }
      end

      it 'should answer to suphp.example.com' do
        shell("/usr/bin/curl suphp.example.com:80") do |r|
          r.stdout.should =~ /^puppet$/
          r.exit_code.should == 0
        end
      end
    end
  when 'RedHat'
    # Not implemented yet
  end
end
