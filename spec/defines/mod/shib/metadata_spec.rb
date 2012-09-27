describe 'apache::mod::shib::metadata', :type => :define do
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
      }
    end
    let(:title){ 'metadata_name' }
    describe 'with minimum parameters' do
      let(:params){ {
        :provider_uri => 'http://example.org/provider',
        :cert_uri     => 'http://example.org/cert.crt'
      } }
      it { should contain_class('apache::mod::shib') }
      it { should contain_exec('get_metadata_name_metadata_cert').with(
        'path'    => ['/usr/bin'],
        'command' => 'wget http://example.org/cert.crt -O /etc/shibboleth/cert.crt',
        'creates' => '/etc/shibboleth/cert.crt',
        'notify'  => 'Service[httpd]'
      ) }
      it { should contain_augeas('shib_metadata_name_create_metadata_provider').with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => [
          'ins MetadataProvider after Errors',
        ],
        'onlyif'  => 'match MetadataProvider/#attribute/uri size == 0',
        'notify'  => 'Service[httpd]',
        'require' => 'Exec[get_metadata_name_metadata_cert]'
      ) }
      it { should contain_augeas("shib_metadata_name_metadata_provider").with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => [
          'set MetadataProvider/#attribute/type XML',
          'set MetadataProvider/#attribute/uri http://example.org/provider',
          'set MetadataProvider/#attribute/backingFilePath /etc/shibboleth/provider',
          'set MetadataProvider/#attribute/reloadInterval 7200',
          'set MetadataProvider/MetadataFilter[1]/#attribute/type RequireValidUntil',
          'set MetadataProvider/MetadataFilter[1]/#attribute/maxValidityInterval 2419200',
          'set MetadataProvider/MetadataFilter[2]/#attribute/type Signature',
          'set MetadataProvider/MetadataFilter[2]/#attribute/certificate /etc/shibboleth/cert.crt',
        ],
        'notify'  => 'Service[httpd]',
        'require' => ['Exec[get_metadata_name_metadata_cert]','Augeas[shib_metadata_name_create_metadata_provider]']
      ) }
    end
    describe 'with all parameters' do
      let(:params){ {
        :provider_uri => 'http://example.org/provider',
        :cert_uri     => 'http://example.org/cert.crt',
        :backing_file_dir         => '/path/to',
        :backing_file_name        => 'bob.xml',
        :cert_dir                 => '/path/to/certs',
        :cert_file_name           => 'bobs_cert.crt',
        :provider_type            => 'JSON',
        :provider_reload_interval => '1000',
        :metadata_filter_max_validity_interval  => '100000'
      } }
      it { should contain_exec('get_metadata_name_metadata_cert').with(
        'command' => 'wget http://example.org/cert.crt -O /path/to/certs/bobs_cert.crt',
        'creates' => '/path/to/certs/bobs_cert.crt'
      ) }
      it { should contain_augeas("shib_metadata_name_metadata_provider").with(
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => [
          'set MetadataProvider/#attribute/type JSON',
          'set MetadataProvider/#attribute/uri http://example.org/provider',
          'set MetadataProvider/#attribute/backingFilePath /path/to/bob.xml',
          'set MetadataProvider/#attribute/reloadInterval 1000',
          'set MetadataProvider/MetadataFilter[1]/#attribute/type RequireValidUntil',
          'set MetadataProvider/MetadataFilter[1]/#attribute/maxValidityInterval 100000',
          'set MetadataProvider/MetadataFilter[2]/#attribute/type Signature',
          'set MetadataProvider/MetadataFilter[2]/#attribute/certificate /path/to/certs/bobs_cert.crt'
        ]
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
      }
    end
    let(:title){ 'metadata_name' }
    describe 'with minimum parameters' do
      let(:params){ {
        :provider_uri => 'http://example.org/provider',
        :cert_uri     => 'http://example.org/cert.crt'
      } }
      it { should contain_class('apache::mod::shib') }
      it { should contain_exec('get_metadata_name_metadata_cert').with(
        'path'    => ['/usr/bin'],
        'command' => 'wget http://example.org/cert.crt -O /etc/shibboleth/cert.crt',
        'creates' => '/etc/shibboleth/cert.crt',
        'notify'  => 'Service[httpd]'
      ) }
      it { should contain_augeas('shib_metadata_name_create_metadata_provider').with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => [
          'ins MetadataProvider after Errors',
        ],
        'onlyif'  => 'match MetadataProvider/#attribute/uri size == 0',
        'notify'  => 'Service[httpd]',
        'require' => 'Exec[get_metadata_name_metadata_cert]'
      ) }
      it { should contain_augeas("shib_metadata_name_metadata_provider").with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => [
          'set MetadataProvider/#attribute/type XML',
          'set MetadataProvider/#attribute/uri http://example.org/provider',
          'set MetadataProvider/#attribute/backingFilePath /etc/shibboleth/provider',
          'set MetadataProvider/#attribute/reloadInterval 7200',
          'set MetadataProvider/MetadataFilter[1]/#attribute/type RequireValidUntil',
          'set MetadataProvider/MetadataFilter[1]/#attribute/maxValidityInterval 2419200',
          'set MetadataProvider/MetadataFilter[2]/#attribute/type Signature',
          'set MetadataProvider/MetadataFilter[2]/#attribute/certificate /etc/shibboleth/cert.crt',
        ],
        'notify'  => 'Service[httpd]',
        'require' => ['Exec[get_metadata_name_metadata_cert]','Augeas[shib_metadata_name_create_metadata_provider]']
      ) }
    end
    describe 'with all parameters' do
      let(:params){ {
        :provider_uri => 'http://example.org/provider',
        :cert_uri     => 'http://example.org/cert.crt',
        :backing_file_dir         => '/path/to',
        :backing_file_name        => 'bob.xml',
        :cert_dir                 => '/path/to/certs',
        :cert_file_name           => 'bobs_cert.crt',
        :provider_type            => 'JSON',
        :provider_reload_interval => '1000',
        :metadata_filter_max_validity_interval  => '100000'
      } }
      it { should contain_exec('get_metadata_name_metadata_cert').with(
        'command' => 'wget http://example.org/cert.crt -O /path/to/certs/bobs_cert.crt',
        'creates' => '/path/to/certs/bobs_cert.crt'
      ) }
      it { should contain_augeas("shib_metadata_name_metadata_provider").with(
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => [
          'set MetadataProvider/#attribute/type JSON',
          'set MetadataProvider/#attribute/uri http://example.org/provider',
          'set MetadataProvider/#attribute/backingFilePath /path/to/bob.xml',
          'set MetadataProvider/#attribute/reloadInterval 1000',
          'set MetadataProvider/MetadataFilter[1]/#attribute/type RequireValidUntil',
          'set MetadataProvider/MetadataFilter[1]/#attribute/maxValidityInterval 100000',
          'set MetadataProvider/MetadataFilter[2]/#attribute/type Signature',
          'set MetadataProvider/MetadataFilter[2]/#attribute/certificate /path/to/certs/bobs_cert.crt'
        ]
      ) }
    end
  end
end