# frozen_string_literal: true

require 'spec_helper'

# This function is called inside the OS specific contexts
def general_mime_magic_specs
  it { is_expected.to contain_apache__mod('mime_magic') }
end

describe 'apache::mod::mime_magic', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'On a Debian OS with default params' do
    include_examples 'Debian 11'

    general_mime_magic_specs

    it do
      is_expected.to contain_file('mime_magic.conf').with_content(
        "MIMEMagicFile \"/etc/apache2/magic\"\n",
      )
    end

    it {
      is_expected.to contain_file('mime_magic.conf').with(ensure: 'file',
                                                          path: '/etc/apache2/mods-available/mime_magic.conf')
    }
    it {
      is_expected.to contain_file('mime_magic.conf symlink').with(ensure: 'link',
                                                                  path: '/etc/apache2/mods-enabled/mime_magic.conf')
    }

    context 'with magic_file => /tmp/Debian_magic' do
      let :params do
        { magic_file: '/tmp/Debian_magic' }
      end

      it do
        is_expected.to contain_file('mime_magic.conf').with_content(
          "MIMEMagicFile \"/tmp/Debian_magic\"\n",
        )
      end
    end
  end

  context 'on a RedHat OS with default params' do
    include_examples 'RedHat 6'

    general_mime_magic_specs

    it do
      is_expected.to contain_file('mime_magic.conf').with_content(
        "MIMEMagicFile \"/etc/httpd/conf/magic\"\n",
      )
    end

    it { is_expected.to contain_file('mime_magic.conf').with_path('/etc/httpd/conf.d/mime_magic.conf') }
  end
end
