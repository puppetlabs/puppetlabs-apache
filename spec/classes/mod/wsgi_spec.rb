describe 'apache::mod::wsgi', :type => :class do
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
    it { should contain_apache__mod('wsgi') }
    it { should contain_package("libapache2-mod-wsgi") }
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
    it { should contain_apache__mod('wsgi') }
    it { should contain_package("mod_wsgi") }

    describe "with custom WSGISocketPrefix" do
      let :params do
        { :wsgi_socket_prefix => 'run/wsgi' }
      end
      it {should contain_file('wsgi.conf').with_content(/^  WSGISocketPrefix run\/wsgi$/)}
    end
    describe "with custom WSGIPythonHome" do
      let :params do
        { :wsgi_python_home => '/path/to/virtenv' }
      end
      it {should contain_file('wsgi.conf').with_content(/^  WSGIPythonHome \/path\/to\/virtenv$/)}
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
    it { should include_class("apache::params") }
    it { should contain_apache__mod('wsgi') }
    it { should contain_package("www/mod_wsgi") }
  end
end
