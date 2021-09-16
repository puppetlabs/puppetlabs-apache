# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod', type: :define do
  let :pre_condition do
    'include apache'
  end

  let :title do
    'spec_m'
  end

  context 'on a RedHat osfamily' do
    include_examples 'RedHat 6'

    describe 'for non-special modules' do
      it { is_expected.to contain_class('apache::params') }
      it 'manages the module load file' do
        is_expected.to contain_file('spec_m.load').with(path: '/etc/httpd/conf.d/spec_m.load',
                                                        content: "LoadModule spec_m_module modules/mod_spec_m.so\n",
                                                        owner: 'root',
                                                        group: 'root',
                                                        mode: '0644')
      end
    end

    describe 'with file_mode set' do
      let :pre_condition do
        "class {'::apache': file_mode => '0640'}"
      end

      it 'manages the module load file' do
        is_expected.to contain_file('spec_m.load').with(mode: '0640')
      end
    end

    describe 'with shibboleth module and package param passed' do
      # name/title for the apache::mod define
      let :title do
        'xsendfile'
      end
      # parameters
      let(:params) { { package: 'mod_xsendfile' } }

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_package('mod_xsendfile') }
    end
  end

  context 'on a Debian osfamily' do
    include_examples 'Debian 11'

    describe 'for non-special modules' do
      it { is_expected.to contain_class('apache::params') }
      it 'manages the module load file' do
        is_expected.to contain_file('spec_m.load').with(path: '/etc/apache2/mods-available/spec_m.load',
                                                        content: "LoadModule spec_m_module /usr/lib/apache2/modules/mod_spec_m.so\n",
                                                        owner: 'root',
                                                        group: 'root',
                                                        mode: '0644')
      end
      it 'links the module load file' do
        is_expected.to contain_file('spec_m.load symlink').with(path: '/etc/apache2/mods-enabled/spec_m.load',
                                                                target: '/etc/apache2/mods-available/spec_m.load',
                                                                owner: 'root',
                                                                group: 'root',
                                                                mode: '0644')
      end
    end
  end

  context 'on a FreeBSD osfamily' do
    include_examples 'FreeBSD 9'

    describe 'for non-special modules' do
      it { is_expected.to contain_class('apache::params') }
      it 'manages the module load file' do
        is_expected.to contain_file('spec_m.load').with(path: '/usr/local/etc/apache24/Modules/spec_m.load',
                                                        content: "LoadModule spec_m_module /usr/local/libexec/apache24/mod_spec_m.so\n",
                                                        owner: 'root',
                                                        group: 'wheel',
                                                        mode: '0644')
      end
    end
  end

  context 'on a Gentoo osfamily' do
    include_examples 'Gentoo'

    describe 'for non-special modules' do
      it { is_expected.to contain_class('apache::params') }
      it 'manages the module load file' do
        is_expected.to contain_file('spec_m.load').with(path: '/etc/apache2/modules.d/spec_m.load',
                                                        content: "LoadModule spec_m_module /usr/lib/apache2/modules/mod_spec_m.so\n",
                                                        owner: 'root',
                                                        group: 'wheel',
                                                        mode: '0644')
      end
    end
  end
end
