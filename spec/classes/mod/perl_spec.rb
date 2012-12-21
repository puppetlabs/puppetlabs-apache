describe 'apache::mod::perl', :type => :class do
  context "on a Debian OS" do
    let :facts do
      {
        :osfamily       => 'Debian',
        :concat_basedir => '/dne',
      }
    end
    it { should include_class("apache::params") }
    it { should contain_apache__mod('perl') }
    it { should contain_package("libapache2-mod-perl2") }
  end
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily       => 'RedHat',
        :concat_basedir => '/dne',
      }
    end
    it { should include_class("apache::params") }
    it { should contain_apache__mod('perl') }
    it { should contain_package("mod_perl") }
  end
end
