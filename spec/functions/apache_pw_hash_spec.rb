require 'spec_helper'

describe 'apache::apache_pw_hash' do

  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params("").and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params(1).and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params(true).and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params({}).and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params([]).and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params("test").and_return('{SHA}qUqP5cyxm6YcTAhz05Hph5gvu9M=') }
end
