describe 'apache::mod::shib::metadata', :type => :define do
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
    let(:title){ 'metadata_name' }
    let(:params){ {
      :provider_uri => 'http://example.org/provider',
      :cert_uri     => 'http://example.org/cert.crt'
    } }
    it { should include_class("apache::params") }
    it { should include_class("apache::mod::shib") }
    it { should contain_exec("get_metadata_name_metadata_cert")}
    it { should contain_augeas("shib_metadata_name_create_metadata_provider") }
    it { should contain_augeas("shib_metadata_name_metadata_provider") }
  end
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    let(:title){ 'metadata_name' }
    let(:params){ {
      :provider_uri => 'http://example.org/provider',
      :cert_uri     => 'http://example.org/cert.crt'
    } }
    it { should include_class("apache::params") }
    it { should include_class("apache::mod::shib") }
    it { should contain_exec("get_metadata_name_metadata_cert") }
    it { should contain_augeas("shib_metadata_name_create_metadata_provider") }
    it { should contain_augeas("shib_metadata_name_metadata_provider") }
  end
end