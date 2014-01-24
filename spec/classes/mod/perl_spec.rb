describe 'apache::mod::perl', :type => :class do
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
    it { should contain_class("apache::params") }
    it { should contain_apache__mod('perl') }
    it { should contain_package("libapache2-mod-perl2") }
  end
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    it { should contain_class("apache::params") }
    it { should contain_apache__mod('perl') }
    it { should contain_package("mod_perl") }
    describe "with custom perl_switches" do
      let :params do
        { :perl_switches => '-I' }
      end
      it { should contain_file('perl.conf').with_content(/^  PerlSwitches -I/)}
    end
    describe "with custom perl_load_module" do
      let :params do
        { :perl_load_module => 'SOME::Perl::Module' }
      end
      it { should contain_file('perl.conf').with_content(/^  PerlLoadModule SOME::Perl::Module/)}
    end
    describe "with custom perl_set_var" do
      let :params do
        { :perl_set_var => 'MasonMultipleConfig 1' }
      end
      it { should contain_file('perl.conf').with_content(/^  PerlSetVar MasonMultipleConfig 1/)}
    end
  end
  context "on a FreeBSD OS" do
    let :facts do
      {
        :osfamily               => 'FreeBSD',
        :operatingsystemrelease => '9',
        :concat_basedir         => '/dne',
      }
    end
    it { should contain_class("apache::params") }
    it { should contain_apache__mod('perl') }
    it { should contain_package("www/mod_perl2") }
  end
end
