require 'spec_helper'

describe 'the bool2httpd function' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'exists' do
    expect(Puppet::Parser::Functions.function('bool2httpd')).to eq('function_bool2httpd')
  end

  it 'raises a ParseError if there is less than 1 arguments' do
    expect { scope.function_bool2httpd([]) }.to(raise_error(Puppet::ParseError))
  end

  it "converts true to 'On'" do
    result = scope.function_bool2httpd([true])
    expect(result).to(eq('On'))
  end

  it 'converts true to a string' do
    result = scope.function_bool2httpd([true])
    expect(result.class).to(eq(String))
  end

  it "converts false to 'Off'" do
    result = scope.function_bool2httpd([false])
    expect(result).to(eq('Off'))
  end

  it 'converts false to a string' do
    result = scope.function_bool2httpd([false])
    expect(result.class).to(eq(String))
  end

  it 'accepts (and return) any string' do
    result = scope.function_bool2httpd(['mail'])
    expect(result).to(eq('mail'))
  end

  it 'accepts a nil value (and return Off)' do
    result = scope.function_bool2httpd([nil])
    expect(result).to(eq('Off'))
  end

  it "accepts an undef value (and return 'Off')" do
    result = scope.function_bool2httpd([:undef])
    expect(result).to(eq('Off'))
  end

  it 'returns a default value on non-matches' do
    result = scope.function_bool2httpd(['foo'])
    expect(result).to(eq('foo'))
  end
end
