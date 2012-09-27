describe 'apache::mod::shib::backend_cert', :type => :class do
  let :pre_condition do
    "include apache\ninclude apache::mod::shib"
  end
  context "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :lsbdistcodename        => 'squeeze',
        :operatingsystem        => 'Debian',
        :id                     => 'root',
        :kernel                 => 'Linux',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :fqdn                   => 'test.example.com',
      }
    end
    describe 'with no parameters' do
      it { should contain_class('apache::mod::shib') }
      it { should contain_exec('shib_keygen_test.example.com').with(
        'path'    => ['/usr/sbin','/usr/bin','/bin'],
        'command' => 'shib-keygen -f -h test.example.com -e https://test.example.com/shibbloeth',
        'unless'  => 'openssl x509 -noout -in /etc/shibboleth/sp-cert.pem -issuer|grep test.example.com'
      ) }
    end
    describe 'when given a hostname' do
      let(:params){ { :sp_hostname => 'test.example.org' } }
      it { should contain_exec('shib_keygen_test.example.org').with(
        'command' => 'shib-keygen -f -h test.example.org -e https://test.example.org/shibbloeth',
        'unless'  => 'openssl x509 -noout -in /etc/shibboleth/sp-cert.pem -issuer|grep test.example.org'
      ) }
    end
  end
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :operatingsystem        => 'RedHat',
        :id                     => 'root',
        :kernel                 => 'Linux',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :fqdn                   => 'test.example.com',
      }
    end
    describe 'with no parameters' do
      it { should contain_class('apache::mod::shib') }
      it { should contain_exec('shib_keygen_test.example.com').with(
        'path'    => ['/usr/sbin','/usr/bin','/bin'],
        'command' => 'shib-keygen -f -h test.example.com -e https://test.example.com/shibbloeth',
        'unless'  => 'openssl x509 -noout -in /etc/shibboleth/sp-cert.pem -issuer|grep test.example.com'
      ) }
    end
    describe 'when given a hostname' do
      let(:params){ { :sp_hostname => 'test.example.org' } }
      it { should contain_exec('shib_keygen_test.example.org').with(
        'command' => 'shib-keygen -f -h test.example.org -e https://test.example.org/shibbloeth',
        'unless'  => 'openssl x509 -noout -in /etc/shibboleth/sp-cert.pem -issuer|grep test.example.org'
      ) }
    end
  end
end