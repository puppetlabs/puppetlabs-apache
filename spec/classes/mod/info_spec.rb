# frozen_string_literal: true

require 'spec_helper'

def general_info_specs_apache24
  it { is_expected.to contain_apache__mod('info') }

  context 'passing no parameters' do
    expected = "<Location /server-info>\n    " \
               "SetHandler server-info\n    " \
               "Require ip 127.0.0.1 ::1\n" \
               "</Location>\n"
    it { is_expected.to contain_file('info.conf').with_content(expected) }
  end
  context 'passing restrict_access => false' do
    let :params do
      {
        restrict_access: false
      }
    end

    it {
      is_expected.to contain_file('info.conf').with_content(
        "<Location /server-info>\n    " \
        "SetHandler server-info\n" \
        "</Location>\n",
      )
    }
  end
  context "passing allow_from => ['10.10.1.2', '192.168.1.2', '127.0.0.1']" do
    let :params do
      { allow_from: ['10.10.1.2', '192.168.1.2', '127.0.0.1'] }
    end

    expected = "<Location /server-info>\n    " \
               "SetHandler server-info\n    " \
               "Require ip 10.10.1.2 192.168.1.2 127.0.0.1\n" \
               "</Location>\n"
    it {
      is_expected.to contain_file('info.conf').with_content(expected)
    }
  end
  context 'passing both restrict_access and allow_from' do
    let :params do
      {
        restrict_access: false,
        allow_from: ['10.10.1.2', '192.168.1.2', '127.0.0.1']
      }
    end

    it {
      is_expected.to contain_file('info.conf').with_content(
        "<Location /server-info>\n    " \
        "SetHandler server-info\n" \
        "</Location>\n",
      )
    }
  end
end

describe 'apache::mod::info', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'On a Debian OS' do
    include_examples 'Debian 11'

    # Load the more generic tests for this context
    general_info_specs_apache24

    it {
      is_expected.to contain_file('info.conf').with(ensure: 'file',
                                                    path: '/etc/apache2/mods-available/info.conf')
    }
    it {
      is_expected.to contain_file('info.conf symlink').with(ensure: 'link',
                                                            path: '/etc/apache2/mods-enabled/info.conf')
    }
  end

  context 'on a RedHat OS' do
    include_examples 'RedHat 8'

    # Load the more generic tests for this context
    general_info_specs_apache24

    it {
      is_expected.to contain_file('info.conf').with(ensure: 'file',
                                                    path: '/etc/httpd/conf.modules.d/info.conf')
    }
  end

  context 'on a FreeBSD OS' do
    include_examples 'FreeBSD 10'

    # Load the more generic tests for this context
    general_info_specs_apache24

    it {
      is_expected.to contain_file('info.conf').with(ensure: 'file',
                                                    path: '/usr/local/etc/apache24/Modules/info.conf')
    }
  end

  context 'on a Gentoo OS' do
    include_examples 'Gentoo'

    # Load the more generic tests for this context
    general_info_specs_apache24

    it {
      is_expected.to contain_file('info.conf').with(ensure: 'file',
                                                    path: '/etc/apache2/modules.d/info.conf')
    }
  end
end
