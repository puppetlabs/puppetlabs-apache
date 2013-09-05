describe 'apache::mod::itk', :type => :class do
  let :pre_condition do
    'class { "apache": mpm_module => false, }'
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
    it { should_not contain_apache__mod('itk') }
    it { should contain_file("/etc/apache2/mods-available/itk.conf").with_ensure('file') }
    it { should contain_file("/etc/apache2/mods-enabled/itk.conf").with_ensure('link') }
    it { should contain_package("apache2-mpm-itk") }
  end
end
