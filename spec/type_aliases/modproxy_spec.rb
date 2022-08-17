require 'spec_helper'

describe 'Apache::ModProxyProtocol' do
  [
    'ajp://www.example.com',
    'fcgi://www.example.com',
    'ftp://www.example.com',
    'h2://www.example.com',
    'h2c://www.example.com',
    'http://www.example.com',
    'https://www.example.com',
    'scgi://www.example.com',
    'uwsgi://www.example.com',
    'ws://www.example.com',
    'wss://www.example.com',
    'unix:/path/to/unix.socket',
  ].each do |allowed_value|
    it { is_expected.to allow_value(allowed_value) }
  end
end
