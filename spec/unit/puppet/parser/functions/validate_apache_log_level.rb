#! /usr/bin/env ruby -S rspec # rubocop:disable Lint/ScriptPermission
require 'spec_helper'

describe 'the validate_apache_log_level function' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'exists' do
    expect(Puppet::Parser::Functions.function('validate_apache_log_level')).to eq('function_validate_apache_log_level')
  end

  it 'raises a ParseError if there is less than 1 arguments' do
    expect { scope.function_validate_apache_log_level([]) }.to(raise_error(Puppet::ParseError))
  end

  it 'raises a ParseError when given garbage' do
    expect { scope.function_validate_apache_log_level(['garbage']) }.to(raise_error(Puppet::ParseError))
  end

  it 'does not raise a ParseError when given a plain log level' do
    expect { scope.function_validate_apache_log_level(['info']) }.not_to raise_error
  end

  it 'does not raise a ParseError when given a log level and module log level #ssl' do
    expect { scope.function_validate_apache_log_level(['warn ssl:info']) }.not_to raise_error
  end

  it 'does not raise a ParseError when given a log level and module log level #mod_ssl.c' do
    expect { scope.function_validate_apache_log_level(['warn mod_ssl.c:info']) }.not_to raise_error
  end

  it 'does not raise a ParseError when given a log level and module log level #ssl_module' do
    expect { scope.function_validate_apache_log_level(['warn ssl_module:info']) }.not_to raise_error
  end

  it 'does not raise a ParseError when given a trace level' do
    expect { scope.function_validate_apache_log_level(['trace4']) }.not_to raise_error
  end
end
