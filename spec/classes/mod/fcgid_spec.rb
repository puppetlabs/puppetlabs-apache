# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::fcgid', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'on a Debian OS' do
    include_examples 'Debian 11'

    it { is_expected.to contain_class('apache::params') }

    it {
      expect(subject).to contain_apache__mod('fcgid').with('loadfile_name' => nil)
    }

    it { is_expected.to contain_package('libapache2-mod-fcgid') }
  end

  context 'on RHEL8' do
    include_examples 'RedHat 8'

    describe 'without parameters' do
      it { is_expected.to contain_class('apache::params') }

      it {
        expect(subject).to contain_apache__mod('fcgid').with('loadfile_name' => 'unixd_fcgid.load')
      }

      it { is_expected.to contain_package('mod_fcgid') }
    end
  end

  context 'on a FreeBSD OS' do
    include_examples 'FreeBSD 10'

    it { is_expected.to contain_class('apache::params') }

    it {
      expect(subject).to contain_apache__mod('fcgid').with('loadfile_name' => 'unixd_fcgid.load')
    }

    it { is_expected.to contain_package('www/mod_fcgid') }
  end

  context 'on a Gentoo OS' do
    include_examples 'Gentoo'

    it { is_expected.to contain_class('apache::params') }

    it {
      expect(subject).to contain_apache__mod('fcgid').with('loadfile_name' => nil)
    }

    it { is_expected.to contain_package('www-apache/mod_fcgid') }
  end
end
