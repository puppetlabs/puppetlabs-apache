describe 'apache::mod::fcgid', :type => :class do
  context "on a Debian OS" do
    let :facts do
      {
        :osfamily       => 'Debian',
        :concat_basedir => '/dne',
      }
    end
    it { should include_class("apache::params") }
    it { should contain_apache__mod('fcgid') }
    it { should contain_package("libapache2-mod-fcgid") }
  end
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily       => 'RedHat',
        :concat_basedir => '/dne',
      }
    end
    it { should include_class("apache::params") }
    it { should contain_apache__mod('fcgid') }
    it { should contain_package("mod_fcgid") }
  end
end
