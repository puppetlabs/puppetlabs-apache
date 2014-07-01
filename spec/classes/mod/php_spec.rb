describe 'apache::mod::php', :type => :class do
  describe "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    context "with mpm_module => prefork" do
      let :pre_condition do
        'class { "apache": mpm_module => prefork, }'
      end
      it { should contain_class("apache::params") }
      it { should contain_apache__mod('php5') }
      it { should contain_package("libapache2-mod-php5") }
      it { should contain_file("php5.load").with(
        :content => "LoadModule php5_module /usr/lib/apache2/modules/libphp5.so\n"
      ) }
    end
    context 'with mpm_module => worker' do
      let :pre_condition do
        'class { "apache": mpm_module => worker, }'
      end
      it 'should raise an error' do
        expect { subject }.to raise_error Puppet::Error, /mpm_module => 'prefork'/
      end
    end
  end
  describe "on a RedHat OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    context "with default params" do
      let :pre_condition do
        'class { "apache": }'
      end
      it { should contain_class("apache::params") }
      it { should contain_apache__mod('php5') }
      it { should contain_package("php") }
      it { should contain_file("php5.load").with(
        :content => "LoadModule php5_module modules/libphp5.so\n"
      ) }
    end
    context "with specific version" do
      let :pre_condition do
        'class { "apache": }'
      end
      let :params do
        { :package_ensure => '5.3.13'}
      end
      it { should contain_package("php").with(
        :ensure => '5.3.13'
      ) }
    end
    context "with mpm_module => prefork" do
      let :pre_condition do
        'class { "apache": mpm_module => prefork, }'
      end
      it { should contain_class("apache::params") }
      it { should contain_apache__mod('php5') }
      it { should contain_package("php") }
      it { should contain_file("php5.load").with(
        :content => "LoadModule php5_module modules/libphp5.so\n"
      ) }
    end
  end
  describe "on a FreeBSD OS" do
    let :facts do
      {
        :osfamily               => 'FreeBSD',
        :operatingsystemrelease => '9',
        :concat_basedir         => '/dne',
      }
    end
    context "with mpm_module => prefork" do
      let :pre_condition do
        'class { "apache": mpm_module => prefork, }'
      end
      it { should contain_class('apache::params') }
      it { should contain_apache__mod('php5') }
      it { should contain_package("lang/php5") }
      it { should contain_file('php5.load') }
    end
    # FIXME: not sure about the following context
    context 'with mpm_module => worker' do
      let :pre_condition do
        'class { "apache": mpm_module => worker, }'
      end
      it 'should raise an error' do
        expect { subject.should contain_apache__mod('php5') }.to raise_error Puppet::Error, /mpm_module => 'prefork'/
      end
    end
  end
end
