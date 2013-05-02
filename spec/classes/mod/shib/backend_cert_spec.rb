describe 'apache::mod::shib::backend_cert', :type => :class do
  let :pre_condition do
    'include apache'
    'include apache::mod::shib'
  end
  context "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    it { should include_class("apache::params") }
    it { should include_class("apache::mod::shib") }
    it { should contain_exec("shib_keygen_test.example.org")}
  end
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    it { should include_class("apache::params") }
    it { should include_class("apache::mod::shib") }
    it { should contain_exec("shib_keygen_test.example.org")}
  end
end