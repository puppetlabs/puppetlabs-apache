describe 'apache::mod::shib::sso', :type => :define do
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
    let(:title){ 'sso_name' }
    let(:params){ { :discoveryURL => 'http://example.org/DS/' } }
    it { should include_class("apache::params") }
    it { should include_class("apache::mod::shib") }
    it { should contain_augeas("shib_sso_sso_name_attributes") }
  end
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    let(:title){ 'sso_name' }
    let(:params){ { :discoveryURL => 'http://example.org/DS/' } }
    it { should include_class("apache::params") }
    it { should include_class("apache::mod::shib") }
    it { should contain_augeas("shib_sso_sso_name_attributes") }
  end
end