# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::lbmethod_byrequests', type: :class do
  context 'on a Debian OS' do
    include_examples 'Debian 11'

    context 'with Apache version >= 2.4' do
      let :params do
        {
          apache_version: '2.4'
        }
      end

      it { is_expected.to contain_class('apache::mod::proxy_balancer') }
      it { is_expected.to contain_apache__mod('lbmethod_byrequests') }
      it {
        is_expected.to contain_file('lbmethod_byrequests.load').with(
          {
            path: '/etc/apache2/mods-available/lbmethod_byrequests.load',
            content: "LoadModule lbmethod_byrequests_module /usr/lib/apache2/modules/mod_lbmethod_byrequests.so\n",
          },
        )
      }
      it {
        is_expected.to contain_file('lbmethod_byrequests.load symlink').with(
          {
            ensure: 'link',
            path: '/etc/apache2/mods-enabled/lbmethod_byrequests.load',
            target: '/etc/apache2/mods-available/lbmethod_byrequests.load',
          },
        )
      }
    end
  end
end
