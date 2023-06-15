# frozen_string_literal: true

require 'spec_helper'

describe 'Apache::LogLevel' do
  [
    'info',
    'warn ssl:info',
    'warn mod_ssl.c:info',
    'warn mod_ssl.c:info',
    'warn ssl_module:info',
    'trace4',
    'ssl:info',
  ].each do |allowed_value|
    it { is_expected.to allow_value(allowed_value) }
  end

  [
    'garbage',
    '',
    [],
    ['info'],
    'thisiswarning',
    'errorerror',
  ].each do |invalid_value|
    it { is_expected.not_to allow_value(invalid_value) }
  end
end
