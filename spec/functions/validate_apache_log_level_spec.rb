require 'spec_helper'

describe 'apache::validate_apache_log_level' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('garbage').and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('info') }
  it { is_expected.to run.with_params('warn ssl:info') }
  it { is_expected.to run.with_params('warn mod_ssl.c:info') }
  it { is_expected.to run.with_params('warn ssl_module:info') }
  it { is_expected.to run.with_params('trace4') }
end
