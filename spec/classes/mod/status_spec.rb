require 'spec_helper'

describe 'apache::mod::status', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    context 'on a Debian 8 OS with default params' do
      let :facts do
        {
          osfamily: 'Debian',
          operatingsystemrelease: '8',
          lsbdistcodename: 'squeeze',
          operatingsystem: 'Debian',
          id: 'root',
          kernel: 'Linux',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end

      it { is_expected.to contain_apache__mod('status') }

      expected =
        "<Location /server-status>\n"\
        "    SetHandler server-status\n"\
        "    Require ip 127.0.0.1 ::1\n"\
        "</Location>\n"\
        "ExtendedStatus On\n"\
        "\n"\
        "<IfModule mod_proxy.c>\n"\
        "    # Show Proxy LoadBalancer status in mod_status\n"\
        "    ProxyStatus On\n"\
        "</IfModule>\n"

      it { is_expected.to contain_file('status.conf').with_content(expected) }

      it {
        is_expected.to contain_file('status.conf').with(ensure: 'file',
                                                        path: '/etc/apache2/mods-available/status.conf')
      }

      it {
        is_expected.to contain_file('status.conf symlink').with(ensure: 'link',
                                                                path: '/etc/apache2/mods-enabled/status.conf')
      }
    end

    context 'on a RedHat 7 OS with default params' do
      let :facts do
        {
          osfamily: 'RedHat',
          operatingsystemrelease: '7',
          operatingsystem: 'RedHat',
          id: 'root',
          kernel: 'Linux',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end

      it { is_expected.to contain_apache__mod('status') }

      expected =
        "<Location /server-status>\n"\
        "    SetHandler server-status\n"\
        "    Require ip 127.0.0.1 ::1\n"\
        "</Location>\n"\
        "ExtendedStatus On\n"\
        "\n"\
        "<IfModule mod_proxy.c>\n"\
        "    # Show Proxy LoadBalancer status in mod_status\n"\
        "    ProxyStatus On\n"\
        "</IfModule>\n"

      it { is_expected.to contain_file('status.conf').with_content(expected) }
      it { is_expected.to contain_file('status.conf').with_path('/etc/httpd/conf.modules.d/status.conf') }
    end

    context 'on a Debian 8 OS with hash params and requires with an enforce all' do
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
          requires: { enforce: 'all', requires: ['ip 127.0.0.1', 'host localhost'] },
          status_path: '/server-status',
        }
      end

      it { is_expected.to contain_apache__mod('status') }

      expected =
        "<Location /server-status>\n"\
        "    SetHandler server-status\n"\
        "    <RequireAll>\n"\
        "        Require ip 127.0.0.1\n"\
        "        Require host localhost\n"\
        "    </RequireAll>\n"\
        "</Location>\n"\
        "ExtendedStatus On\n"\
        "\n"\
        "<IfModule mod_proxy.c>\n"\
        "    # Show Proxy LoadBalancer status in mod_status\n"\
        "    ProxyStatus On\n"\
        "</IfModule>\n"

      it { is_expected.to contain_file('status.conf').with_content(expected) }

      it {
        is_expected.to contain_file('status.conf').with(ensure: 'file',
                                                        path: '/etc/apache2/mods-available/status.conf')
      }

      it {
        is_expected.to contain_file('status.conf symlink').with(ensure: 'link',
                                                                path: '/etc/apache2/mods-enabled/status.conf')
      }
    end

    context 'on a RedHat 7 OS with default requires and extended status off, with a server-status path' do
      let :facts do
        {
          osfamily: 'RedHat',
          operatingsystemrelease: '7',
          operatingsystem: 'RedHat',
          id: 'root',
          kernel: 'Linux',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end

      let :params do
        {
          extended_status: 'Off',
          status_path: '/server-status',
        }
      end

      it { is_expected.to contain_apache__mod('status') }

      expected =
        "<Location /server-status>\n"\
        "    SetHandler server-status\n"\
        "    Require ip 127.0.0.1 ::1\n"\
        "</Location>\n"\
        "ExtendedStatus Off\n"\
        "\n"\
        "<IfModule mod_proxy.c>\n"\
        "    # Show Proxy LoadBalancer status in mod_status\n"\
        "    ProxyStatus On\n"\
        "</IfModule>\n"

      it { is_expected.to contain_file('status.conf').with_content(expected) }

      it { is_expected.to contain_file('status.conf').with_path('/etc/httpd/conf.modules.d/status.conf') }
    end
  end

  context "with custom parameters $allow_from => ['10.10.10.10','11.11.11.11'], $extended_status => 'Off', $status_path => '/custom-status'" do
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
        allow_from: ['10.10.10.10', '11.11.11.11'],
        extended_status: 'Off',
        status_path: '/custom-status',
      }
    end

    expected =
      "<Location /custom-status>\n"\
      "    SetHandler server-status\n"\
      "    Require ip 10.10.10.10 11.11.11.11\n"\
      "</Location>\n"\
      "ExtendedStatus Off\n"\
      "\n"\
      "<IfModule mod_proxy.c>\n"\
      "    # Show Proxy LoadBalancer status in mod_status\n"\
      "    ProxyStatus On\n"\
      "</IfModule>\n"

    it { is_expected.to contain_file('status.conf').with_content(expected) }
  end

  context "with valid parameter type $allow_from => ['10.10.10.10']" do
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
        operatingsystemrelease: '8',
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
  ['On', 'Off'].each do |valid_param|
    context "with valid value $extended_status => '#{valid_param}'" do
      let :facts do
        {
          osfamily: 'Debian',
          operatingsystemrelease: '8',
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

  ['Yes', 'No'].each do |invalid_param|
    context "with invalid value $extended_status => '#{invalid_param}'" do
      let :facts do
        {
          osfamily: 'Debian',
          operatingsystemrelease: '8',
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
