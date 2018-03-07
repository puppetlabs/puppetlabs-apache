require 'spec_helper'

describe 'apache::bool2httpd' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params('1', '2').and_raise_error(ArgumentError) }
  it { is_expected.to run.with_params(true).and_return('On') }
  it 'expected to return a string "On"' do
    expect(subject.execute(true)).to be_an_instance_of(String)
  end
  it { is_expected.to run.with_params(false).and_return('Off') }
  it 'expected to return a string "Off"' do
    expect(subject.execute(false)).to be_an_instance_of(String)
  end
  it { is_expected.to run.with_params('mail').and_return('mail') }
  it { is_expected.to run.with_params(nil).and_return('Off') }
  it { is_expected.to run.with_params(:undef).and_return('Off') }
  it { is_expected.to run.with_params('foo').and_return('foo') }
end
