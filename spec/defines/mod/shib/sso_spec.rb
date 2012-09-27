describe 'apache::mod::shib::sso', :type => :define do
  let :pre_condition do
    'include apache'
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
      }
    end
    let(:title){ 'sso_name' }
    describe 'with a Discovery Service' do
      let(:params){ { :idpURL => 'http://example.org/IDP/' } }
      it { should contain_class('apache::mod::shib') }
      it { should contain_augeas('shib_sso_sso_name_attributes').with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults/Sessions',
        'changes' => [
          'set SSO/#attribute/entityID http://example.org/IDP/',
          'rm SSO/#attribute/discoveryURL',
          'set SSO/#attribute/discoveryProtocol SAMLDS',
          'set SSO/#attribute/ECP false'
        ],
        'notify'  => 'Service[httpd]'
      ) }
    end
    describe 'with an Identity Provider' do
      let(:params){ { :discoveryURL => 'http://example.org/DS/' } }
      it { should contain_class('apache::mod::shib') }
      it { should contain_augeas('shib_sso_sso_name_attributes').with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults/Sessions',
        'changes' => [
          'rm SSO/#attribute/entityID',
          'set SSO/#attribute/discoveryURL http://example.org/DS/',
          'set SSO/#attribute/discoveryProtocol SAMLDS',
          'set SSO/#attribute/ECP false'
        ],
        'notify'  => 'Service[httpd]'
      ) }
    end
    describe 'when choosing a protocol and enabling ECP' do
      let(:params){ {
        :idpURL             => 'http://example.org/IDP/',
        :discoveryProtocol  => 'PIDGEONS',
        :ecp_support        => true
      } }
      it { should contain_augeas('shib_sso_sso_name_attributes').with_changes(
        [
          'set SSO/#attribute/entityID http://example.org/IDP/',
          'rm SSO/#attribute/discoveryURL',
          'set SSO/#attribute/discoveryProtocol PIDGEONS',
          'set SSO/#attribute/ECP true'
        ]
      ) }
    end
    describe 'when both a Directory Service and an Identity Provider are given' do
      let(:params){ {
        :idpURL             => 'http://example.org/IDP/',
        :discoveryURL => 'http://example.org/DS/'
      } }
      # Can't test for error messages
      it { should_not contain_augeas('shib_sso_sso_name_attributes') }
    end
    describe 'with no parameters' do
      # Can't test for error messages
      it { should_not contain_augeas('shib_sso_sso_name_attributes') }
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
      }
    end
    let(:title){ 'sso_name' }
    describe 'with a Discovery Service' do
      let(:params){ { :idpURL => 'http://example.org/IDP/' } }
      it { should contain_class('apache::mod::shib') }
      it { should contain_augeas('shib_sso_sso_name_attributes').with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults/Sessions',
        'changes' => [
          'set SSO/#attribute/entityID http://example.org/IDP/',
          'rm SSO/#attribute/discoveryURL',
          'set SSO/#attribute/discoveryProtocol SAMLDS',
          'set SSO/#attribute/ECP false'
        ],
        'notify'  => 'Service[httpd]'
      ) }
    end
    describe 'with an Identity Provider' do
      let(:params){ { :discoveryURL => 'http://example.org/DS/' } }
      it { should contain_class('apache::mod::shib') }
      it { should contain_augeas('shib_sso_sso_name_attributes').with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults/Sessions',
        'changes' => [
          'rm SSO/#attribute/entityID',
          'set SSO/#attribute/discoveryURL http://example.org/DS/',
          'set SSO/#attribute/discoveryProtocol SAMLDS',
          'set SSO/#attribute/ECP false'
        ],
        'notify'  => 'Service[httpd]'
      ) }
    end
    describe 'when choosing a protocol and enabling ECP' do
      let(:params){ {
        :idpURL             => 'http://example.org/IDP/',
        :discoveryProtocol  => 'PIDGEONS',
        :ecp_support        => true
      } }
      it { should contain_augeas('shib_sso_sso_name_attributes').with_changes(
        [
          'set SSO/#attribute/entityID http://example.org/IDP/',
          'rm SSO/#attribute/discoveryURL',
          'set SSO/#attribute/discoveryProtocol PIDGEONS',
          'set SSO/#attribute/ECP true'
        ]
      ) }
    end
    describe 'when both a Directory Service and an Identity Provider are given' do
      let(:params){ {
        :idpURL             => 'http://example.org/IDP/',
        :discoveryURL => 'http://example.org/DS/'
      } }
      # Can't test for error messages
      it { should_not contain_augeas('shib_sso_sso_name_attributes') }
    end
    describe 'with no parameters' do
      # Can't test for error messages
      it { should_not contain_augeas('shib_sso_sso_name_attributes') }
    end
  end
end