# frozen_string_literal: true

require 'spec_helper'

describe 'apache::params', type: :class do
  context 'On a Debian OS' do
    include_examples 'Debian 8'

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to have_resource_count(0) }
  end
end
