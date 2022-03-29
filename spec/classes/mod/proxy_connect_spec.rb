# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::proxy_connect', type: :class do
  let :pre_condition do
    [
      'include apache::mod::proxy',
    ]
  end

  include_examples 'a mod class, without including apache'

  it { is_expected.to contain_apache__mod('proxy_connect') }
end
