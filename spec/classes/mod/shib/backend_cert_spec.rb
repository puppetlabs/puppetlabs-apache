describe 'apache::mod::shib::backend_cert', :type => :class do
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
    let(:params){ { :sp_hostname => 'test.example.org' } }
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
      }
    end
    let(:params){ { :sp_hostname => 'test.example.org' } }
    it { should include_class("apache::params") }
    it { should include_class("apache::mod::shib") }
    it { should contain_exec("shib_keygen_test.example.org")}
  end
end