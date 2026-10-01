# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::proxy_wstunnel', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'on a Debian OS' do
    include_examples 'Debian 11'

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('apache') }
    it { is_expected.to contain_class('apache::mod::proxy') }
    it { is_expected.to contain_apache__mod('proxy_wstunnel') }
    it {
      is_expected.to contain_file('proxy_wstunnel.load').with(
        {
          path: '/etc/apache2/mods-available/proxy_wstunnel.load',
          content: "LoadModule proxy_wstunnel_module /usr/lib/apache2/modules/mod_proxy_wstunnel.so\n",
        },
      )
    }
    it {
      is_expected.to contain_file('proxy_wstunnel.load symlink').with(
        {
          ensure: 'link',
          path: '/etc/apache2/mods-enabled/proxy_wstunnel.load',
          target: '/etc/apache2/mods-available/proxy_wstunnel.load',
        },
      )
    }
  end
end
