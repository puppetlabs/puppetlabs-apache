# This function is called inside the OS specific contexts
def general_status_specs
  it { should contain_apache__mod("status") }

  it do
    should contain_file("status.conf").with_content(
      "<Location /server-status>\n"\
      "    SetHandler server-status\n"\
      "    Order deny,allow\n"\
      "    Deny from all\n"\
      "    Allow from 127.0.0.1 ::1\n"\
      "</Location>\n"\
      "ExtendedStatus On\n"\
      "\n"\
      "<IfModule mod_proxy.c>\n"\
      "    # Show Proxy LoadBalancer status in mod_status\n"\
      "    ProxyStatus On\n"\
      "</IfModule>\n"
    )
  end
end

describe 'apache::mod::status', :type => :class do
  let :pre_condition do
    'include apache'
  end

  context "on a Debian OS with default params" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end

    # Load the more generic tests for this context
    general_status_specs()

    it { should contain_file("status.conf").with({
      :ensure => 'file',
      :path   => '/etc/apache2/mods-available/status.conf',
    } ) }
    it { should contain_file("status.conf symlink").with({
      :ensure => 'link',
      :path   => '/etc/apache2/mods-enabled/status.conf',
    } ) }
  end

  context "on a RedHat OS with default params" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end

    # Load the more generic tests for this context
    general_status_specs()

    it { should contain_file("status.conf").with_path("/etc/httpd/conf.d/status.conf") }
  end

  context "with $allow_from => ['10.10.10.10','11.11.11.11'], $extended_status => 'Off'" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    let :params do
      {
        :allow_from => ['10.10.10.10','11.11.11.11'],
        :extended_status => 'Off',
      }
    end
    it do
      should contain_file("status.conf").with_content(
        "<Location /server-status>\n"\
        "    SetHandler server-status\n"\
        "    Order deny,allow\n"\
        "    Deny from all\n"\
        "    Allow from 10.10.10.10 11.11.11.11\n"\
        "</Location>\n"\
        "ExtendedStatus Off\n"\
        "\n"\
        "<IfModule mod_proxy.c>\n"\
        "    # Show Proxy LoadBalancer status in mod_status\n"\
        "    ProxyStatus On\n"\
        "</IfModule>\n"
      )
    end
  end

  context "with $allow_from => '10.10.10.10'" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    let :params do
      { :allow_from => '10.10.10.10' }
    end
    it 'should expect to fail array validation' do
      expect {
        should contain_file("status.conf")
      }.to raise_error(Puppet::Error)
    end
  end

  context "with $extended_status => 'Yes'" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    let :params do
      { :extended_status => 'Yes' }
    end
    it 'should expect to fail regular expression validation' do
      expect {
        should contain_file("status.conf")
      }.to raise_error(Puppet::Error)
    end
  end

end
