# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::peruser', type: :class do
  let :pre_condition do
    'class { "apache": mpm_module => false, }'
  end

  context 'on a FreeBSD OS' do
    include_examples 'FreeBSD 10'

    it { is_expected.to compile.and_raise_error(%r{Unsupported osfamily FreeBSD}) }
  end

  context 'on a Gentoo OS' do
    include_examples 'Gentoo'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.not_to contain_apache__mod('peruser') }
    it { is_expected.to contain_file('/etc/apache2/modules.d/peruser.conf').with_ensure('file') }
  end
end
