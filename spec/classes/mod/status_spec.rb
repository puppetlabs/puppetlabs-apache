require 'spec_helper'

# Helper function for testing the contents of `status.conf`
# Apache < 2.4
def status_conf_spec(allow_from, extended_status, status_path)
  expected =
    "<Location #{status_path}>\n"\
    "    SetHandler server-status\n"\
    "    Order deny,allow\n"\
    "    Deny from all\n"\
    "    Allow from #{Array(allow_from).join(' ')}\n"\
    "</Location>\n"\
    "ExtendedStatus #{extended_status}\n"\
    "\n"\
    "<IfModule mod_proxy.c>\n"\
    "    # Show Proxy LoadBalancer status in mod_status\n"\
    "    ProxyStatus On\n"\
    "</IfModule>\n"
  it do
    is_expected.to contain_file('status.conf').with_content(expected)
  end
end

# Apache >= 2.4
def require_directives(requires)
  if requires == :undef
    "    Require ip 127.0.0.1 ::1\n"
  elsif requires.is_a?(String)
    if ['', 'unmanaged'].include? requires.downcase
      ''
    else
      "    Require #{requires}\n"
    end
  elsif requires.is_a?(Array)
    requires.map { |req| "    Require #{req}\n" }.join('')
  elsif requires.is_a?(Hash)
    if requires.key?(:enforce)
      \
      "    <Require#{requires[:enforce].capitalize}>\n" + \
        requires[:requires].map { |req| "        Require #{req}\n" }.join('') + \
        "    </Require#{requires[:enforce].capitalize}>\n"
    else
      requires[:requires].map { |req| "    Require #{req}\n" }.join('')
    end
  end
end

def status_conf_spec_require(requires, extended_status, status_path)
  expected =
    "<Location #{status_path}>\n"\
    "    SetHandler server-status\n"\
    "#{require_directives(requires)}"\
    "</Location>\n"\
    "ExtendedStatus #{extended_status}\n"\
    "\n"\
    "<IfModule mod_proxy.c>\n"\
    "    # Show Proxy LoadBalancer status in mod_status\n"\
    "    ProxyStatus On\n"\
    "</IfModule>\n"
  it do
    is_expected.to contain_file('status.conf').with_content(expected)
  end
end

describe 'apache::mod::status', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    context 'on a Debian 6 OS with default params' do
      let :facts do
        {
          osfamily: 'Debian',
          operatingsystemrelease: '6',
          concat_basedir: '/dne',
          lsbdistcodename: 'squeeze',
          operatingsystem: 'Debian',
          id: 'root',
          kernel: 'Linux',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end

      it { is_expected.to contain_apache__mod('status') }

      status_conf_spec(['127.0.0.1', '::1'], 'On', '/server-status')

      it {
        is_expected.to contain_file('status.conf').with(ensure: 'file',
                                                        path: '/etc/apache2/mods-available/status.conf')
      }

      it {
        is_expected.to contain_file('status.conf symlink').with(ensure: 'link',
                                                                path: '/etc/apache2/mods-enabled/status.conf')
      }
    end

    context 'on a RedHat 6 OS with default params' do
      let :facts do
        {
          osfamily: 'RedHat',
          operatingsystemrelease: '6',
          concat_basedir: '/dne',
          operatingsystem: 'RedHat',
          id: 'root',
          kernel: 'Linux',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end

      it { is_expected.to contain_apache__mod('status') }

      status_conf_spec(['127.0.0.1', '::1'], 'On', '/server-status')

      it { is_expected.to contain_file('status.conf').with_path('/etc/httpd/conf.d/status.conf') }
    end

    valid_requires = {
      undef: :undef,
      empty: '',
      unmanaged: 'unmanaged',
      string: 'ip 127.0.0.1 192.168',
      array: [
        'ip 127.0.0.1',
        'ip ::1',
        'host localhost',
      ],
      hash: {
        requires: [
          'ip 10.1',
          'host somehost',
        ],
      },
      enforce: {
        enforce: 'all',
        requires: [
          'ip 127.0.0.1',
          'host localhost',
        ],
      },
    }
    valid_requires.each do |req_key, req_value|
      context "on a Debian 8 OS with default params and #{req_key} requires" do
        let :facts do
          {
            osfamily: 'Debian',
            operatingsystemrelease: '8',
            concat_basedir: '/dne',
            lsbdistcodename: 'squeeze',
            operatingsystem: 'Debian',
            id: 'root',
            kernel: 'Linux',
            path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
            is_pe: false,
          }
        end

        let :params do
          {
            requires: req_value,
          }
        end

        it { is_expected.to contain_apache__mod('status') }

        status_conf_spec_require(req_value, 'On', '/server-status')

        it {
          is_expected.to contain_file('status.conf').with(ensure: 'file',
                                                          path: '/etc/apache2/mods-available/status.conf')
        }

        it {
          is_expected.to contain_file('status.conf symlink').with(ensure: 'link',
                                                                  path: '/etc/apache2/mods-enabled/status.conf')
        }
      end

      context "on a RedHat 7 OS with default params and #{req_key} requires" do
        let :facts do
          {
            osfamily: 'RedHat',
            operatingsystemrelease: '7',
            concat_basedir: '/dne',
            operatingsystem: 'RedHat',
            id: 'root',
            kernel: 'Linux',
            path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
            is_pe: false,
          }
        end

        let :params do
          {
            requires: req_value,
          }
        end

        it { is_expected.to contain_apache__mod('status') }

        status_conf_spec_require(req_value, 'On', '/server-status')

        it { is_expected.to contain_file('status.conf').with_path('/etc/httpd/conf.modules.d/status.conf') }
      end
    end

    context "with custom parameters $allow_from => ['10.10.10.10','11.11.11.11'], $extended_status => 'Off', $status_path => '/custom-status'" do
      let :facts do
        {
          osfamily: 'Debian',
          operatingsystemrelease: '6',
          concat_basedir: '/dne',
          lsbdistcodename: 'squeeze',
          operatingsystem: 'Debian',
          id: 'root',
          kernel: 'Linux',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end
      let :params do
        {
          allow_from: ['10.10.10.10', '11.11.11.11'],
          extended_status: 'Off',
          status_path: '/custom-status',
        }
      end

      status_conf_spec(['10.10.10.10', '11.11.11.11'], 'Off', '/custom-status')
    end

    context "with valid parameter type $allow_from => ['10.10.10.10']" do
      let :facts do
        {
          osfamily: 'Debian',
          operatingsystemrelease: '6',
          concat_basedir: '/dne',
          lsbdistcodename: 'squeeze',
          operatingsystem: 'Debian',
          id: 'root',
          kernel: 'Linux',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end
      let :params do
        { allow_from: ['10.10.10.10'] }
      end

      it 'expects to succeed array validation' do
        expect {
          is_expected.to contain_file('status.conf')
        }.not_to raise_error
      end
    end

    context "with invalid parameter type $allow_from => '10.10.10.10'" do
      let :facts do
        {
          osfamily: 'Debian',
          operatingsystemrelease: '6',
          concat_basedir: '/dne',
          operatingsystem: 'Debian',
          id: 'root',
          kernel: 'Linux',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end
      let :params do
        { allow_from: '10.10.10.10' }
      end

      it 'expects to fail array validation' do
        expect {
          is_expected.to contain_file('status.conf')
        }.to raise_error(Puppet::Error)
      end
    end

    # Only On or Off are valid options
    %w[On Off].each do |valid_param|
      context "with valid value $extended_status => '#{valid_param}'" do
        let :facts do
          {
            osfamily: 'Debian',
            operatingsystemrelease: '6',
            concat_basedir: '/dne',
            lsbdistcodename: 'squeeze',
            operatingsystem: 'Debian',
            id: 'root',
            kernel: 'Linux',
            path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
            is_pe: false,
          }
        end
        let :params do
          { extended_status: valid_param }
        end

        it 'expects to succeed regular expression validation' do
          expect {
            is_expected.to contain_file('status.conf')
          }.not_to raise_error
        end
      end
    end

    %w[Yes No].each do |invalid_param|
      context "with invalid value $extended_status => '#{invalid_param}'" do
        let :facts do
          {
            osfamily: 'Debian',
            operatingsystemrelease: '6',
            concat_basedir: '/dne',
            operatingsystem: 'Debian',
            id: 'root',
            kernel: 'Linux',
            path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
            is_pe: false,
          }
        end
        let :params do
          { extended_status: invalid_param }
        end

        it 'expects to fail regular expression validation' do
          expect {
            is_expected.to contain_file('status.conf')
          }.to raise_error(Puppet::Error)
        end
      end
    end
  end
end
