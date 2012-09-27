describe 'apache::mod::shib::attribute_map', :type => :define do
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
    let(:title){ 'map_name' }
    describe 'with minimum parameters' do
      let(:params){ { :attribute_map_uri => 'http://example.org/attribute_map.xml' } }
      it { should contain_class("apache::mod::shib") }
      it { should contain_exec("get_map_name_attribute_map").with(
        'path'    => ['/usr/bin'],
        'command' => 'wget http://example.org/attribute_map.xml -O /etc/shibboleth/attribute_map.xml',
        'unless'  => 'test `find /etc/shibboleth/attribute_map.xml -mtime +21`',
        'notify'  => 'Service[httpd]'
      ) }
      it { should contain_augeas("shib_map_name_attribute_map").with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => [
          'set AttributeExtractor/#attribute/path attribute_map.xml',
        ],
        'notify'  => 'Service[httpd]',
        'require' => 'Exec[get_map_name_attribute_map]'
      ) }
    end
    describe 'with all parameters' do
      let(:params){ {
        :attribute_map_uri  => 'http://bob.org/bobs_attribute_map.xml',
        :attribute_map_dir  => '/some/path/to',
        :attribute_map_name => 'bob.xml',
        :max_age            => '5'
      } }
      it { should contain_exec("get_map_name_attribute_map").with(
        'command' => 'wget http://bob.org/bobs_attribute_map.xml -O /some/path/to/bob.xml',
        'unless'  => 'test `find /some/path/to/bob.xml -mtime +5`'
      ) }
      it { should contain_augeas("shib_map_name_attribute_map").with(
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => [
          'set AttributeExtractor/#attribute/path bob.xml',
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
    let(:title){ 'map_name' }
    describe 'with minimum parameters' do
      let(:params){ { :attribute_map_uri => 'http://example.org/attribute_map.xml' } }
      it { should contain_class("apache::mod::shib") }
      it { should contain_exec("get_map_name_attribute_map").with(
        'path'    => ['/usr/bin'],
        'command' => 'wget http://example.org/attribute_map.xml -O /etc/shibboleth/attribute_map.xml',
        'unless'  => 'test `find /etc/shibboleth/attribute_map.xml -mtime +21`',
        'notify'  => 'Service[httpd]'
      ) }
      it { should contain_augeas("shib_map_name_attribute_map").with(
        'lens'    => 'Xml.lns',
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => [
          'set AttributeExtractor/#attribute/path attribute_map.xml',
        ],
        'notify'  => 'Service[httpd]',
        'require' => 'Exec[get_map_name_attribute_map]'
      ) }
    end
    describe 'with all parameters' do
      let(:params){ {
        :attribute_map_uri  => 'http://bob.org/bobs_attribute_map.xml',
        :attribute_map_dir  => '/some/path/to',
        :attribute_map_name => 'bob.xml',
        :max_age            => '5'
      } }
      it { should contain_exec("get_map_name_attribute_map").with(
        'command' => 'wget http://bob.org/bobs_attribute_map.xml -O /some/path/to/bob.xml',
        'unless'  => 'test `find /some/path/to/bob.xml -mtime +5`'
      ) }
      it { should contain_augeas("shib_map_name_attribute_map").with(
        'incl'    => '/etc/shibboleth/shibboleth2.xml',
        'context' => '/files/etc/shibboleth/shibboleth2.xml/SPConfig/ApplicationDefaults',
        'changes' => [
          'set AttributeExtractor/#attribute/path bob.xml',
        ]
      ) }
    end
  end
end