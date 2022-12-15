# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::data', type: :class do
  context 'on a Debian OS' do
    include_examples 'Debian 11'

    it { is_expected.to contain_apache__mod('data') }
  end
end
