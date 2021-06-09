# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::dumpio', type: :class do
  context 'on a Debian OS' do
    let :pre_condition do
      'class{"apache":
         default_mods => false,
         mod_dir    => "/tmp/junk",
       }'
    end

    include_examples 'Debian 8'

    context 'default configuration fore parameters' do
      it { is_expected.to compile }
      it { is_expected.to contain_class('apache::mod::dumpio') }
      it { is_expected.to contain_file('dumpio.conf').with_path('/tmp/junk/dumpio.conf') }
      it { is_expected.to contain_file('dumpio.conf').with_content(%r{^\s*DumpIOInput\s+"Off"$}) }
      it { is_expected.to contain_file('dumpio.conf').with_content(%r{^\s*DumpIOOutput\s+"Off"$}) }
    end
    context 'with dumpio_input set to On' do
      let :params do
        {
          dump_io_input: 'On',
        }
      end

      it { is_expected.to contain_file('dumpio.conf').with_content(%r{^\s*DumpIOInput\s+"On"$}) }
      it { is_expected.to contain_file('dumpio.conf').with_content(%r{^\s*DumpIOOutput\s+"Off"$}) }
    end
    context 'with dumpio_ouput set to On' do
      let :params do
        {
          dump_io_output: 'On',
        }
      end

      it { is_expected.to contain_file('dumpio.conf').with_content(%r{^\s*DumpIOInput\s+"Off"$}) }
      it { is_expected.to contain_file('dumpio.conf').with_content(%r{^\s*DumpIOOutput\s+"On"$}) }
    end
  end
end
