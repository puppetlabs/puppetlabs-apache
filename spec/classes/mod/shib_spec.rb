describe 'apache::mod::shib', :type => :class do
  let :pre_condition do
    'include apache'
  end
  context "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    it { should include_class("apache::params") }
    it { should contain_apache__mod('shib2') }
    it { should contain_package('libapache2-mod-shib2')}
    it { should contain_file("/etc/shibboleth") }
    it { should contain_file("/etc/shibboleth/shibboleth2.xml") }
    it { should contain_augeas("shib_SPconfig_errors") }
    it { should contain_augeas("shib_SPconfig_hostname") }
    it { should contain_augeas("shib_SPconfig_handlerSSL") }
  end
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    it { should include_class("apache::params") }
    # Missing tests for apache__mod and package
    it { should contain_file("/etc/shibboleth") }
    it { should contain_file("/etc/shibboleth/shibboleth2.xml") }
    it { should contain_augeas("shib_SPconfig_errors") }
    it { should contain_augeas("shib_SPconfig_hostname") }
    it { should contain_augeas("shib_SPconfig_handlerSSL") }
  end
end