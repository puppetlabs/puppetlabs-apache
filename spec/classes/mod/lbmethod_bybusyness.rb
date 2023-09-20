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

      it {
        # rubocop:disable Layout/LineLength
        expect(subject).to contain_file('/etc/apache2/mods-enabled/lbmethod_byrequests.load').with('ensure' => 'file',
                                                                                                   'content' => "LoadModule lbmethod_byrequests_module /usr/lib/apache2/modules/mod_lbmethod_byrequests.so\n")
        # rubocop:enable Layout/LineLength
      }
    end
  end
end
