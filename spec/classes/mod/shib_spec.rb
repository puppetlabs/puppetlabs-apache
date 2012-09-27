describe 'apache::mod::shib', :type => :class do
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
        :fqdn                   => 'test.example.com',
      }
    end
    describe 'with no parameters' do
      it { should contain_apache__mod('shib2') }
      it { should contain_file('/etc/shibboleth').with(
        'ensure'  => 'directory',
        'require' => 'Apache::Mod[shib2]'
      ) }
      it { should contain_file('/etc/shibboleth/shibboleth2.xml').with(
        'ensure'  => 'file',
        'replace' => false,
        'require' => ['Apache::Mod[shib2]','File[/etc/shibboleth]']
      ) }
      it { should contain_augeas('shib_SPconfig_errors').with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => [
          'set Errors/#attribute/supportContact root@localhost',
          'set Errors/#attribute/logoLocation /shibboleth-sp/logo.jpg',
          'set Errors/#attribute/styleSheet /shibboleth-sp/main.css',
        ],
        'notify'  => 'Service[httpd]'
      ) }
      it { should contain_augeas('shib_SPconfig_hostname').with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => [
          'set #attribute/entityID https://test.example.com/shibboleth',
          'set Sessions/#attribute/handlerURL https://test.example.com/Shibboleth.sso',
        ],
        'notify'  => 'Service[httpd]'
      ) }
      it { should contain_augeas('shib_SPconfig_handlerSSL').with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => ['set Sessions/#attribute/handlerSSL true',],
        'notify'  => 'Service[httpd]'
      ) }
      # The apache module isn't set up for testing the changes augeas makes.
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
      it { should contain_apache__mod('shib2') }
      it { should contain_file('/etc/shibboleth').with(
        'ensure'  => 'directory',
        'require' => 'Apache::Mod[shib2]'
      ) }
      it { should contain_file('/etc/shibboleth/shibboleth2.xml').with(
        'ensure'  => 'file',
        'replace' => false,
        'require' => ['Apache::Mod[shib2]','File[/etc/shibboleth]']
      ) }
      it { should contain_augeas('shib_SPconfig_errors').with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => [
          'set Errors/#attribute/supportContact root@localhost',
          'set Errors/#attribute/logoLocation /shibboleth-sp/logo.jpg',
          'set Errors/#attribute/styleSheet /shibboleth-sp/main.css',
        ],
        'notify'  => 'Service[httpd]'
      ) }
      it { should contain_augeas('shib_SPconfig_hostname').with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => [
          'set #attribute/entityID https://test.example.com/shibboleth',
          'set Sessions/#attribute/handlerURL https://test.example.com/Shibboleth.sso',
        ],
        'notify'  => 'Service[httpd]'
      ) }
      it { should contain_augeas('shib_SPconfig_handlerSSL').with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => ['set Sessions/#attribute/handlerSSL true',],
        'notify'  => 'Service[httpd]'
      ) }
      # The apache module isn't set up for testing the changes augeas makes.
    end
  end
end