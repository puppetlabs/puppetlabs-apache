describe 'apache::mod::python', :type => :class do
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
    it { should contain_apache__mod("python") }
    it { should contain_package("libapache2-mod-python") }
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
    it { should contain_apache__mod("python") }
    it { should contain_package("mod_python") }
  end
  context "on a FreeBSD OS" do
    let :facts do
      {
        :osfamily               => 'FreeBSD',
        :operatingsystemrelease => '9',
        :concat_basedir         => '/dne',
      }
    end
    it { should include_class("apache::params") }
    it { should contain_apache__mod("python") }
    # FIXME:
    #it { should contain_package("libapache2-mod-python") }
  end
end
