describe 'apache::mod::shib::attribute_map', :type => :define do
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
    let(:title){ 'map_name' }
    let(:params){ { :attribute_map_uri => 'http://example.org/attribute_map.xml' } }
    it { should include_class("apache::params") }
    it { should include_class("apache::mod::shib") }
    it { should contain_exec("get_map_name_attribute_map")}
    it { should contain_augeas("shib_map_name_attribute_map") }
  end
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    let(:title){ 'map_name' }
    let(:params){ { :attribute_map_uri => 'http://example.org/attribute_map.xml' } }
    it { should include_class("apache::params") }
    it { should include_class("apache::mod::shib") }
    it { should contain_exec("get_map_name_attribute_map") }
    it { should contain_augeas("shib_map_name_attribute_map") }
  end
end