describe 'apache::mod::rpaf', :type => :class do
  let :pre_condition do
    [
      'include apache',
    ]
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
    it { should contain_apache__mod('rpaf') }
    it { should contain_package("libapache2-mod-rpaf") }
    it { should contain_file('rpaf.conf').with({
      'path' => '/etc/apache2/mods-available/rpaf.conf',
    }) }
    it { should contain_file('rpaf.conf').with_content(/^RPAFenable On$/) }

    describe "with sethostname => true" do
      let :params do
        { :sethostname => 'true' }
      end
      it { should contain_file('rpaf.conf').with_content(/^RPAFsethostname On$/) }
    end
    describe "with proxy_ips => [ 10.42.17.8, 10.42.18.99 ]" do
      let :params do
        { :proxy_ips => [ '10.42.17.8', '10.42.18.99' ] }
      end
      it { should contain_file('rpaf.conf').with_content(/^RPAFproxy_ips 10.42.17.8 10.42.18.99$/) }
    end
    describe "with header => X-Real-IP" do
      let :params do
        { :header => 'X-Real-IP' }
      end
      it { should contain_file('rpaf.conf').with_content(/^RPAFheader X-Real-IP$/) }
    end
  end
end
