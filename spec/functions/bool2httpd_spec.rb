require 'spec_helper'

shared_examples 'apache::bool2httpd function' do
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

describe 'apache::bool2httpd' do
  it_behaves_like 'apache::bool2httpd function'

  describe 'deprecated non-namespaced shim' do
    describe 'bool2httpd', type: :puppet_function do
      it_behaves_like 'apache::bool2httpd function'
    end
  end
end
