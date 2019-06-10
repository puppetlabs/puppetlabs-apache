require 'spec_helper'

describe 'apache', type: :class do
  context 'on a Debian OS' do
    let :facts do
      {
        id: 'root',
        kernel: 'Linux',
        lsbdistcodename: 'squeeze',
        osfamily: 'Debian',
        operatingsystem: 'Debian',
        operatingsystemrelease: '6',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it {
      is_expected.to contain_package('httpd').with(
        'notify' => 'Class[Apache::Service]',
        'ensure' => 'installed',
      )
    }
    it { is_expected.to contain_user('www-data') }
    it { is_expected.to contain_group('www-data') }
    it { is_expected.to contain_class('apache::service') }
    it {
      is_expected.to contain_file('/var/www').with(
        'ensure' => 'directory',
      )
    }
    it {
      is_expected.to contain_file('/etc/apache2/sites-enabled').with(
        'ensure' => 'directory', 'recurse' => 'true',
        'purge' => 'true', 'notify' => 'Class[Apache::Service]',
        'require' => 'Package[httpd]'
      )
    }
    it {
      is_expected.to contain_file('/etc/apache2/mods-enabled').with(
        'ensure' => 'directory', 'recurse' => 'true',
        'purge' => 'true', 'notify' => 'Class[Apache::Service]',
        'require' => 'Package[httpd]'
      )
    }
    it {
      is_expected.to contain_file('/etc/apache2/mods-available').with(
        'ensure' => 'directory', 'recurse' => 'true',
        'purge' => 'false', 'notify' => 'Class[Apache::Service]',
        'require' => 'Package[httpd]'
      )
    }
    it {
      is_expected.to contain_concat('/etc/apache2/ports.conf').with(
        'owner' => 'root', 'group' => 'root',
        'mode' => '0644', 'notify' => 'Class[Apache::Service]'
      )
    }
    # Assert that load files are placed and symlinked for these mods, but no conf file.
    ['auth_basic', 'authn_file', 'authz_default', 'authz_groupfile', 'authz_host', 'authz_user', 'dav', 'env'].each do |modname|
      it {
        is_expected.to contain_file("#{modname}.load").with(
          'path'   => "/etc/apache2/mods-available/#{modname}.load",
          'ensure' => 'file',
        )
      }
      it {
        is_expected.to contain_file("#{modname}.load symlink").with(
          'path'   => "/etc/apache2/mods-enabled/#{modname}.load",
          'ensure' => 'link',
          'target' => "/etc/apache2/mods-available/#{modname}.load",
        )
      }
      it { is_expected.not_to contain_file("#{modname}.conf") }
      it { is_expected.not_to contain_file("#{modname}.conf symlink") }
    end

    context 'with Apache version < 2.4' do
      let :params do
        { apache_version: '2.2' }
      end

      it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{^Include "/etc/apache2/conf\.d/\*\.conf"$} }
    end

    context 'with Apache version >= 2.4' do
      let :params do
        {
          apache_version: '2.4',
          use_optional_includes: true,
        }
      end

      it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{^IncludeOptional "/etc/apache2/conf\.d/\*\.conf"$} }
    end

    context 'when specifying slash encoding behaviour' do
      let :params do
        { allow_encoded_slashes: 'nodecode' }
      end

      it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{^AllowEncodedSlashes nodecode$} }
    end

    context 'when specifying fileETag behaviour' do
      let :params do
        { file_e_tag: 'None' }
      end

      it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{^FileETag None$} }
    end

    context 'when specifying canonical name behaviour' do
      let :params do
        { use_canonical_name: 'dns' }
      end

      it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{^UseCanonicalName dns$} }
    end

    context 'when specifying default character set' do
      let :params do
        { default_charset: 'none' }
      end

      it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{^AddDefaultCharset none$} }
    end

    # Assert that both load files and conf files are placed and symlinked for these mods
    ['alias', 'autoindex', 'dav_fs', 'deflate', 'dir', 'mime', 'negotiation', 'setenvif'].each do |modname|
      it {
        is_expected.to contain_file("#{modname}.load").with(
          'path'   => "/etc/apache2/mods-available/#{modname}.load",
          'ensure' => 'file',
        )
      }
      it {
        is_expected.to contain_file("#{modname}.load symlink").with(
          'path'   => "/etc/apache2/mods-enabled/#{modname}.load",
          'ensure' => 'link',
          'target' => "/etc/apache2/mods-available/#{modname}.load",
        )
      }
      it {
        is_expected.to contain_file("#{modname}.conf").with(
          'path'   => "/etc/apache2/mods-available/#{modname}.conf",
          'ensure' => 'file',
        )
      }
      it {
        is_expected.to contain_file("#{modname}.conf symlink").with(
          'path'   => "/etc/apache2/mods-enabled/#{modname}.conf",
          'ensure' => 'link',
          'target' => "/etc/apache2/mods-available/#{modname}.conf",
        )
      }
    end

    describe "Check default type with Apache version < 2.2 when default_type => 'none'" do
      let :params do
        {
          apache_version: '2.2',
          default_type: 'none',
        }
      end

      it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{^DefaultType none$} }
    end
    describe "Check default type with Apache version < 2.2 when default_type => 'text/plain'" do
      let :params do
        {
          apache_version: '2.2',
          default_type: 'text/plain',
        }
      end

      it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{^DefaultType text/plain$} }
    end

    describe 'Check default type with Apache version >= 2.4' do
      let :params do
        { apache_version: '2.4' }
      end

      it { is_expected.to contain_file('/etc/apache2/apache2.conf').without_content %r{^DefaultType [.]*$} }
    end

    describe "Don't create user resource when parameter manage_user is false" do
      let :params do
        { manage_user: false }
      end

      it { is_expected.not_to contain_user('www-data') }
      it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{^User www-data\n} }
    end
    describe "Don't create group resource when parameter manage_group is false" do
      let :params do
        { manage_group: false }
      end

      it { is_expected.not_to contain_group('www-data') }
      it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{^Group www-data\n} }
    end

    describe 'Add extra LogFormats When parameter log_formats is a hash' do
      let :params do
        { log_formats: {
          'vhost_common'   => '%v %h %l %u %t "%r" %>s %b',
          'vhost_combined' => '%v %h %l %u %t "%r" %>s %b "%{Referer}i" "%{User-agent}i"',
        } }
      end

      it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{^LogFormat "%v %h %l %u %t \"%r\" %>s %b" vhost_common\n} }
      it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{^LogFormat "%v %h %l %u %t \"%r\" %>s %b \"%\{Referer\}i\" \"%\{User-agent\}i\"" vhost_combined\n} }
    end

    describe 'Override existing LogFormats When parameter log_formats is a hash' do
      let :params do
        { log_formats: {
          'common'   => '%v %h %l %u %t "%r" %>s %b',
          'combined' => '%v %h %l %u %t "%r" %>s %b "%{Referer}i" "%{User-agent}i"',
        } }
      end

      expected = [
        %r{^LogFormat "%v %h %l %u %t \"%r\" %>s %b" common\n},
        %r{^LogFormat "%v %h %l %u %t \"%r\" %>s %b" common\n},
        %r{^LogFormat "%v %h %l %u %t \"%r\" %>s %b \"%\{Referer\}i\" \"%\{User-agent\}i\"" combined\n},
      ]
      unexpected = [
        %r{^LogFormat "%h %l %u %t \"%r\" %>s %b \"%\{Referer\}i\" \"%\{User-agent\}i\"" combined\n},
        %r{^LogFormat "%h %l %u %t \"%r\" %>s %b \"%\{Referer\}i\" \"%\{User-agent\}i\"" combined\n},
      ]
      it 'Expected to contain' do
        expected.each do |reg|
          is_expected.to contain_file('/etc/apache2/apache2.conf').with_content reg
        end
      end
      it 'Not expected to contain' do
        unexpected.each do |reg|
          is_expected.to contain_file('/etc/apache2/apache2.conf').without_content reg
        end
      end
    end

    context '8' do
      let :facts do
        super().merge(lsbdistcodename: 'jessie',
                      operatingsystemrelease: '8.0.0')
      end

      it {
        is_expected.to contain_file('/var/www/html').with(
          'ensure' => 'directory',
        )
      }
      describe 'Alternate mpm_modules when declaring mpm_module => prefork' do
        let :params do
          { mpm_module: 'worker' }
        end

        it { is_expected.to contain_exec('/usr/sbin/a2dismod mpm_event') }
      end
    end

    context 'on Ubuntu 14.04' do
      let :facts do
        super().merge(operatingsystem: 'Ubuntu',
                      lsbdistrelease: '14.04',
                      operatingsystemrelease: '14.04')
      end

      it {
        is_expected.to contain_file('/var/www/html').with(
          'ensure' => 'directory',
        )
      }
    end
  end

  context 'on a RedHat 5 OS' do
    let :facts do
      {
        id: 'root',
        kernel: 'Linux',
        osfamily: 'RedHat',
        operatingsystem: 'RedHat',
        operatingsystemrelease: '5',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it {
      is_expected.to contain_package('httpd').with(
        'notify' => 'Class[Apache::Service]',
        'ensure' => 'installed',
      )
    }
    it { is_expected.to contain_user('apache') }
    it { is_expected.to contain_group('apache') }
    it { is_expected.to contain_class('apache::service') }
    it {
      is_expected.to contain_file('/var/www/html').with(
        'ensure' => 'directory',
      )
    }
    it {
      is_expected.to contain_file('/etc/httpd/conf.d').with(
        'ensure' => 'directory', 'recurse' => 'true',
        'purge' => 'true', 'notify' => 'Class[Apache::Service]',
        'require' => 'Package[httpd]'
      )
    }
    it {
      is_expected.to contain_concat('/etc/httpd/conf/ports.conf').with(
        'owner' => 'root', 'group' => 'root',
        'mode' => '0644', 'notify' => 'Class[Apache::Service]'
      )
    }
    describe 'Alternate confd/mod/vhosts directory' do
      let :params do
        {
          vhost_dir: '/etc/httpd/site.d',
          confd_dir: '/etc/httpd/conf.d',
          mod_dir: '/etc/httpd/mod.d',
        }
      end

      ['mod.d', 'site.d', 'conf.d'].each do |dir|
        it {
          is_expected.to contain_file("/etc/httpd/#{dir}").with(
            'ensure' => 'directory', 'recurse' => 'true',
            'purge' => 'true', 'notify' => 'Class[Apache::Service]',
            'require' => 'Package[httpd]'
          )
        }
      end

      # Assert that load files are placed for these mods, but no conf file.
      ['auth_basic', 'authn_file', 'authz_default', 'authz_groupfile', 'authz_host', 'authz_user', 'dav', 'env'].each do |modname|
        it {
          is_expected.to contain_file("#{modname}.load").with_path(
            "/etc/httpd/mod.d/#{modname}.load",
          )
        }
        it {
          is_expected.not_to contain_file("#{modname}.conf").with_path(
            "/etc/httpd/mod.d/#{modname}.conf",
          )
        }
      end

      # Assert that both load files and conf files are placed for these mods
      ['alias', 'autoindex', 'dav_fs', 'deflate', 'dir', 'mime', 'negotiation', 'setenvif'].each do |modname|
        it {
          is_expected.to contain_file("#{modname}.load").with_path(
            "/etc/httpd/mod.d/#{modname}.load",
          )
        }
        it {
          is_expected.to contain_file("#{modname}.conf").with_path(
            "/etc/httpd/mod.d/#{modname}.conf",
          )
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^Include "/etc/httpd/site\.d/\*"$} }
      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^Include "/etc/httpd/mod\.d/\*\.conf"$} }
      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^Include "/etc/httpd/mod\.d/\*\.load"$} }
    end
    describe 'Alternate confd/mod/vhosts directory with Apache version < 2.4' do
      let :params do
        {
          vhost_dir: '/etc/httpd/site.d',
          confd_dir: '/etc/httpd/conf.d',
          mod_dir: '/etc/httpd/mod.d',
          apache_version: '2.2',
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^Include "/etc/httpd/conf\.d/\*\.conf"$} }
    end
    describe 'Alternate confd/mod/vhosts directory with Apache version >= 2.4' do
      let :params do
        {
          vhost_dir: '/etc/httpd/site.d',
          confd_dir: '/etc/httpd/conf.d',
          mod_dir: '/etc/httpd/mod.d',
          apache_version: '2.4',
          use_optional_includes: true,
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^IncludeOptional "/etc/httpd/conf\.d/\*\.conf"$} }
    end
    describe 'Alternate confd/mod/vhosts directory with Apache version < 2.4' do
      let :params do
        {
          vhost_dir: '/etc/httpd/site.d',
          confd_dir: '/etc/httpd/conf.d',
          mod_dir: '/etc/httpd/mod.d',
          apache_version: '2.2',
          rewrite_lock: '/var/lock/subsys/rewrite-lock',
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^RewriteLock /var/lock/subsys/rewrite-lock$} }
    end
    describe 'Alternate confd/mod/vhosts directory with Apache version < 2.4' do
      let :params do
        {
          vhost_dir: '/etc/httpd/site.d',
          confd_dir: '/etc/httpd/conf.d',
          mod_dir: '/etc/httpd/mod.d',
          apache_version: '2.2',
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').without_content %r{^RewriteLock [.]*$} }
    end
    describe 'Alternate confd/mod/vhosts directory with Apache version >= 2.4' do
      let :params do
        {
          vhost_dir: '/etc/httpd/site.d',
          confd_dir: '/etc/httpd/conf.d',
          mod_dir: '/etc/httpd/mod.d',
          apache_version: '2.4',
          rewrite_lock: '/var/lock/subsys/rewrite-lock',
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').without_content %r{^RewriteLock [.]*$} }
    end
    describe 'Alternate confd/mod/vhosts directory when specifying slash encoding behaviour' do
      let :params do
        {
          vhost_dir: '/etc/httpd/site.d',
          confd_dir: '/etc/httpd/conf.d',
          mod_dir: '/etc/httpd/mod.d',
          allow_encoded_slashes: 'nodecode',
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^AllowEncodedSlashes nodecode$} }
    end

    describe 'Alternate confd/mod/vhosts directory when specifying default character set' do
      let :params do
        {
          vhost_dir: '/etc/httpd/site.d',
          confd_dir: '/etc/httpd/conf.d',
          mod_dir: '/etc/httpd/mod.d',
          default_charset: 'none',
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^AddDefaultCharset none$} }
    end
    describe "Alternate confd/mod/vhosts directory with Apache version < 2.4 when default_type => 'none'" do
      let :params do
        {
          vhost_dir: '/etc/httpd/site.d',
          confd_dir: '/etc/httpd/conf.d',
          mod_dir: '/etc/httpd/mod.d',
          apache_version: '2.2',
          default_type: 'none',
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^DefaultType none$} }
    end
    describe "Alternate confd/mod/vhosts directory with Apache version < 2.4 when default_type => 'text/plain'" do
      let :params do
        {
          vhost_dir: '/etc/httpd/site.d',
          confd_dir: '/etc/httpd/conf.d',
          mod_dir: '/etc/httpd/mod.d',
          apache_version: '2.2',
          default_type: 'text/plain',
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^DefaultType text/plain$} }
    end
    describe 'Alternate confd/mod/vhosts directory with Apache version >= 2.4' do
      let :params do
        {
          vhost_dir: '/etc/httpd/site.d',
          confd_dir: '/etc/httpd/conf.d',
          mod_dir: '/etc/httpd/mod.d',
          apache_version: '2.4',
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').without_content %r{^DefaultType [.]*$} }
    end

    describe 'Alternate conf directory' do
      let :params do
        { conf_dir: '/opt/rh/root/etc/httpd/conf' }
      end

      it {
        is_expected.to contain_file('/opt/rh/root/etc/httpd/conf/httpd.conf').with(
          'ensure'  => 'file',
          'notify'  => 'Class[Apache::Service]',
          'require' => ['Package[httpd]', 'Concat[/etc/httpd/conf/ports.conf]'],
        )
      }
    end

    describe 'Alternate conf.d directory' do
      let :params do
        { confd_dir: '/etc/httpd/special_conf.d' }
      end

      it {
        is_expected.to contain_file('/etc/httpd/special_conf.d').with(
          'ensure' => 'directory', 'recurse' => 'true',
          'purge' => 'true', 'notify' => 'Class[Apache::Service]',
          'require' => 'Package[httpd]'
        )
      }
    end

    describe 'Alternate mpm_modules when declaring mpm_module is false' do
      let :params do
        { mpm_module: false }
      end

      unexpected = ['apache::mod::event', 'apache::mod::itk', 'apache::mod::peruser', 'apache::mod::prefork', 'apache::mod::worker']
      it 'does not declare mpm modules' do
        unexpected.each do |not_expect|
          is_expected.not_to contain_class(not_expect)
        end
      end
    end
    describe 'Alternate mpm_modules when declaring mpm_module => prefork' do
      let :params do
        { mpm_module: 'prefork' }
      end

      it { is_expected.to contain_class('apache::mod::prefork') }
      it { is_expected.not_to contain_class('apache::mod::event') }
      it { is_expected.not_to contain_class('apache::mod::itk') }
      it { is_expected.not_to contain_class('apache::mod::peruser') }
      it { is_expected.not_to contain_class('apache::mod::worker') }
    end
    describe 'Alternate mpm_modules when declaring mpm_module => worker' do
      let :params do
        { mpm_module: 'worker' }
      end

      it { is_expected.to contain_class('apache::mod::worker') }
      it { is_expected.not_to contain_class('apache::mod::event') }
      it { is_expected.not_to contain_class('apache::mod::itk') }
      it { is_expected.not_to contain_class('apache::mod::peruser') }
      it { is_expected.not_to contain_class('apache::mod::prefork') }
    end

    describe 'different templates for httpd.conf with default' do
      let :params do
        { conf_template: 'apache/httpd.conf.erb' }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^# Security\n} }
    end
    describe 'different templates for httpd.conf with non-default' do
      let :params do
        { conf_template: 'site_apache/fake.conf.erb' }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^Fake template for rspec.$} }
    end

    describe 'default mods without' do
      let :params do
        { default_mods: false }
      end

      it { is_expected.to contain_apache__mod('authz_host') }
      it { is_expected.not_to contain_apache__mod('env') }
    end
    describe 'default mods custom' do
      let :params do
        { default_mods: ['info', 'alias', 'mime', 'env', 'setenv', 'expires'] }
      end

      it { is_expected.to contain_apache__mod('authz_host') }
      it { is_expected.to contain_apache__mod('env') }
      it { is_expected.to contain_class('apache::mod::info') }
      it { is_expected.to contain_class('apache::mod::mime') }
    end
    describe "Don't create user resource when parameter manage_user is false" do
      let :params do
        { manage_user: false }
      end

      it { is_expected.not_to contain_user('apache') }
      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^User apache\n} }
    end
    describe "Don't create group resource when parameter manage_group is false" do
      let :params do
        { manage_group: false }
      end

      it { is_expected.not_to contain_group('apache') }
      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^Group apache\n} }
    end

    describe 'sendfile with invalid value' do
      let :params do
        { sendfile: 'foo' }
      end

      it 'fails' do
        expect {
          catalogue
        }.to raise_error(Puppet::PreformattedError, %r{Evaluation Error: Error while evaluating a Resource Statement, Class\[Apache\]: parameter 'sendfile' expects a match for Enum\['Off', 'On', 'off', 'on'\]}) # rubocop:disable Metrics/LineLength
      end
    end
    describe 'sendfile On' do
      let :params do
        { sendfile: 'On' }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^EnableSendfile On\n} }
    end
    describe 'sendfile Off' do
      let :params do
        { sendfile: 'Off' }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^EnableSendfile Off\n} }
    end

    describe 'hostname lookup with invalid value' do
      let :params do
        { hostname_lookups: 'foo' }
      end

      it 'fails' do
        expect {
          catalogue
        }.to raise_error(Puppet::Error, %r{Evaluation Error})
      end
    end
    describe 'hostname_lookups On' do
      let :params do
        { hostname_lookups: 'On' }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^HostnameLookups On\n} }
    end
    describe 'hostname_lookups Off' do
      let :params do
        { hostname_lookups: 'Off' }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^HostnameLookups Off\n} }
    end

    describe 'hostname_lookups Double' do
      let :params do
        { hostname_lookups: 'Double' }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{^HostnameLookups Double\n} }
    end

    context 'on Fedora 21' do
      let :facts do
        super().merge(operatingsystem: 'Fedora',
                      lsbdistrelease: '21',
                      operatingsystemrelease: '21')
      end

      it { is_expected.to contain_class('apache').with_apache_version('2.4') }
    end
    context 'on Fedora Rawhide' do
      let :facts do
        super().merge(operatingsystem: 'Fedora',
                      lsbdistrelease: 'Rawhide',
                      operatingsystemrelease: 'Rawhide')
      end

      it { is_expected.to contain_class('apache').with_apache_version('2.4') }
    end
    # kinda obsolete
    context 'on Fedora 17' do
      let :facts do
        super().merge(operatingsystem: 'Fedora',
                      lsbdistrelease: '17',
                      operatingsystemrelease: '17')
      end

      it { is_expected.to contain_class('apache').with_apache_version('2.2') }
    end
  end
  context 'on a FreeBSD OS' do
    let :facts do
      {
        id: 'root',
        kernel: 'FreeBSD',
        osfamily: 'FreeBSD',
        operatingsystem: 'FreeBSD',
        operatingsystemrelease: '10',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_class('apache::package').with('ensure' => 'present') }
    it { is_expected.to contain_user('www') }
    it { is_expected.to contain_group('www') }
    it { is_expected.to contain_class('apache::service') }
    it {
      is_expected.to contain_file('/usr/local/www/apache24/data').with(
        'ensure' => 'directory',
      )
    }
    it {
      is_expected.to contain_file('/usr/local/etc/apache24/Vhosts').with(
        'ensure' => 'directory', 'recurse' => 'true',
        'purge' => 'true', 'notify' => 'Class[Apache::Service]',
        'require' => 'Package[httpd]'
      )
    }
    it {
      is_expected.to contain_file('/usr/local/etc/apache24/Modules').with(
        'ensure' => 'directory', 'recurse' => 'true',
        'purge' => 'true', 'notify' => 'Class[Apache::Service]',
        'require' => 'Package[httpd]'
      )
    }
    it {
      is_expected.to contain_concat('/usr/local/etc/apache24/ports.conf').with(
        'owner' => 'root', 'group' => 'wheel',
        'mode' => '0644', 'notify' => 'Class[Apache::Service]'
      )
    }
    # Assert that load files are placed for these mods, but no conf file.
    ['auth_basic', 'authn_core', 'authn_file', 'authz_groupfile', 'authz_host', 'authz_user', 'dav', 'env'].each do |modname|
      it {
        is_expected.to contain_file("#{modname}.load").with(
          'path'   => "/usr/local/etc/apache24/Modules/#{modname}.load",
          'ensure' => 'file',
        )
      }
      it { is_expected.not_to contain_file("#{modname}.conf") }
    end

    # Assert that both load files and conf files are placed for these mods
    ['alias', 'autoindex', 'dav_fs', 'deflate', 'dir', 'mime', 'negotiation', 'setenvif'].each do |modname|
      it {
        is_expected.to contain_file("#{modname}.load").with(
          'path'   => "/usr/local/etc/apache24/Modules/#{modname}.load",
          'ensure' => 'file',
        )
      }
      it {
        is_expected.to contain_file("#{modname}.conf").with(
          'path'   => "/usr/local/etc/apache24/Modules/#{modname}.conf",
          'ensure' => 'file',
        )
      }
    end
  end
  context 'on a Gentoo OS' do
    let :facts do
      {
        id: 'root',
        kernel: 'Linux',
        osfamily: 'Gentoo',
        operatingsystem: 'Gentoo',
        operatingsystemrelease: '3.16.1-gentoo',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_user('apache') }
    it { is_expected.to contain_group('apache') }
    it { is_expected.to contain_class('apache::service') }
    it {
      is_expected.to contain_file('/var/www/localhost/htdocs').with(
        'ensure' => 'directory',
      )
    }
    it {
      is_expected.to contain_file('/etc/apache2/vhosts.d').with(
        'ensure' => 'directory', 'recurse' => 'true',
        'purge' => 'true', 'notify' => 'Class[Apache::Service]',
        'require' => 'Package[httpd]'
      )
    }
    it {
      is_expected.to contain_file('/etc/apache2/modules.d').with(
        'ensure' => 'directory', 'recurse' => 'true',
        'purge' => 'true', 'notify' => 'Class[Apache::Service]',
        'require' => 'Package[httpd]'
      )
    }
    it {
      is_expected.to contain_concat('/etc/apache2/ports.conf').with(
        'owner' => 'root', 'group' => 'wheel',
        'mode' => '0644', 'notify' => 'Class[Apache::Service]'
      )
    }
  end
  context 'on all OSes' do
    let :facts do
      {
        id: 'root',
        kernel: 'Linux',
        osfamily: 'RedHat',
        operatingsystem: 'RedHat',
        operatingsystemrelease: '6',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    context 'with a custom apache_name parameter' do
      let :params do
        {
          apache_name: 'httpd24-httpd',
        }
      end

      it {
        is_expected.to contain_package('httpd').with(
          'notify' => 'Class[Apache::Service]',
          'ensure' => 'installed',
          'name'   => 'httpd24-httpd',
        )
      }
    end
    context 'with a custom file_mode parameter' do
      let :params do
        {
          file_mode: '0640',
        }
      end

      it {
        is_expected.to contain_concat('/etc/httpd/conf/ports.conf').with(
          'mode' => '0640',
        )
      }
    end
    context 'with a custom root_directory_options parameter' do
      let :params do
        {
          root_directory_options: ['-Indexes', '-FollowSymLinks'],
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{Options -Indexes -FollowSymLinks} }
    end
    context 'with a custom root_directory_secured parameter and Apache < 2.4' do
      let :params do
        {
          apache_version: '2.2',
          root_directory_secured: true,
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{Options FollowSymLinks\n\s+AllowOverride None\n\s+Order deny,allow\n\s+Deny from all} }
    end
    context 'with a custom root_directory_secured parameter and Apache >= 2.4' do
      let :params do
        {
          apache_version: '2.4',
          root_directory_secured: true,
        }
      end

      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{Options FollowSymLinks\n\s+AllowOverride None\n\s+Require all denied} }
    end
    context 'default vhost defaults' do
      it { is_expected.to contain_apache__vhost('default').with_ensure('present') }
      it { is_expected.to contain_apache__vhost('default-ssl').with_ensure('absent') }
      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{Options FollowSymLinks} }
    end
    context 'without default non-ssl vhost' do
      let :params do
        {
          default_vhost: false,
        }
      end

      it { is_expected.to contain_apache__vhost('default').with_ensure('absent') }
      it { is_expected.not_to contain_file('/var/www/html') }
    end
    context 'with default ssl vhost' do
      let :params do
        {
          default_ssl_vhost: true,
        }
      end

      it { is_expected.to contain_apache__vhost('default-ssl').with_ensure('present') }
      it { is_expected.to contain_file('/var/www/html') }
    end
  end
  context 'with unsupported osfamily' do
    let :facts do
      { osfamily: 'Darwin',
        operatingsystemrelease: '13.1.0',
        is_pe: false }
    end

    it do
      expect {
        catalogue
      }.to raise_error(Puppet::Error, %r{Unsupported osfamily})
    end
  end
end
