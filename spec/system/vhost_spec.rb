require 'spec_helper_system'

describe 'apache::vhost define' do
  let(:distro_commands) {
    YAML.load(File.read(File.dirname(__FILE__) + '/../fixtures/system/distro_commands.yaml'))
  }
  let(:os) {
    node.facts['osfamily']
  }
  let(:vhost_dir) {
    case node.facts['osfamily']
    when 'Debian'
      '/etc/apache2/sites-enabled'
    when 'RedHat'
      '/etc/httpd/conf.d'
    end
  }

  context "default vhost without ssl" do
    it 'should create a default vhost config' do
      puppet_apply(%{
        class { 'apache': }
      }) { |r| r.exit_code.should_not == 1 }
    end

    it 'should have a default config file' do
      shell("/bin/cat #{vhost_dir}/15-default.conf") do |r|
        r.stdout.should =~ /^<VirtualHost \*:80>$/
        r.exit_code.should == 0
      end
    end

    it 'should not have a default ssl config file' do
      shell("/bin/cat #{vhost_dir}/15-default-ssl.conf") do |r|
        r.exit_code.should == 1
      end
    end
  end

  context 'default vhost with ssl' do
    it 'should create default vhost configs' do
      puppet_apply(%{
        class { 'apache':
          default_ssl_vhost => true,
        }
      }) { |r| r.exit_code.should_not == 1 }
    end

    it 'should have a default config file' do
      shell("/bin/cat #{vhost_dir}/15-default.conf") do |r|
        r.stdout.should =~ /^<VirtualHost \*:80>$/
        r.exit_code.should == 0
      end
    end

    it 'should have a default ssl config file' do
      shell("/bin/cat #{vhost_dir}/15-default-ssl.conf") do |r|
        r.stdout.should =~ /^<VirtualHost \*:443>$/
        r.stdout.should =~ /SSLEngine on/
        r.exit_code.should == 0
      end
    end
  end

  context 'new vhost on port 80' do
    it 'should configure an apache vhost' do
      puppet_apply(%{
        class { 'apache': }
        apache::vhost { 'first.example.com':
          port    => '80',
          docroot => '/var/www/first',
        }
      }) { |r| r.exit_code.should_not == 1 }

      shell("/bin/cat #{vhost_dir}/25-first.example.com.conf") do |r|
        r.stdout.should =~ /^<VirtualHost \*:80>$/
        r.stdout.should =~ /ServerName first\.example\.com$/
        r.exit_code.should == 0
      end
    end
  end

  it 'should still be running the apache service' do
    if distro_commands.has_key?(os)
      shell(distro_commands[os]["service_check"]["command"]) do |r|
        r.exit_code.should == 0
      end
    end
  end
end
