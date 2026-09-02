# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::lbmethod_bybusyness', type: :class do
  context 'on a Debian OS' do
    include_examples 'Debian 11'

    context 'with Apache version >= 2.4' do
      let :params do
        {
          apache_version: '2.4'
        }
      end

      it { is_expected.to contain_class('apache::mod::proxy_balancer') }
      it { is_expected.to contain_apache__mod('lbmethod_bybusyness') }
      it {
        is_expected.to contain_file('lbmethod_bybusyness.load').with(
          {
            path: '/etc/apache2/mods-available/lbmethod_bybusyness.load',
            content: "LoadModule lbmethod_bybusyness_module /usr/lib/apache2/modules/mod_lbmethod_bybusyness.so\n",
          },
        )
      }
      it {
        is_expected.to contain_file('lbmethod_bybusyness.load symlink').with(
          {
            ensure: 'link',
            path: '/etc/apache2/mods-enabled/lbmethod_bybusyness.load',
            target: '/etc/apache2/mods-available/lbmethod_bybusyness.load',
          },
        )
      }
    end
  end
end
