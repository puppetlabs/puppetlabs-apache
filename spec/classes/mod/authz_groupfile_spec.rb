# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::authz_groupfile' do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    context 'on a Debian OS' do
      include_examples 'Debian 11'

      it { is_expected.to contain_apache__mod('authz_groupfile') }
    end
  end
end
