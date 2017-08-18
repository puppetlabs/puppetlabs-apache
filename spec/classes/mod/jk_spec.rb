require 'spec_helper'

describe 'apache::mod::jk', :type => :class do
  it_behaves_like 'a mod class, without including apache'

  shared_examples 'minimal resources' do |mod_dir|
    it { is_expected.to compile }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to create_class('apache::mod::jk') }
    it { is_expected.to contain_class('apache') }
    it { is_expected.to contain_apache__mod('jk') }
    it { is_expected.to contain_file('jk.conf').that_notifies('Class[apache::service]') }
    it { is_expected.to contain_file('jk.conf').with({ :path => "#{mod_dir}/jk.conf" }) }
  end

  context "RHEL 6 with only required facts and no parameters" do

    let (:facts) do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6',
      }
    end

    let (:pre_condition) do
      'include apache'
    end

    let (:params) do
      { :logroot => '/var/log/httpd' }
    end

    mod_dir = '/etc/httpd/conf.d'
    let (:mod_dir) { mod_dir }

    it_behaves_like 'minimal resources', mod_dir
    it { is_expected.to contain_file('jk.conf').with_content(
      "# This file is generated automatically by Puppet - DO NOT EDIT\n"\
      "# Any manual changes will be overwritten\n"\
      "\n"\
      "<IfModule jk_module>\n"\
      "  JkShmFile /var/log/httpd/jk-runtime-status\n"\
      "  JkLogFile /var/log/httpd/mod_jk.log\n"\
      "</IfModule>\n"
    ) }
    it {
      verify_contents(catalogue, 'jk.conf', ['<IfModule jk_module>', '</IfModule>'])
    }

  end

  context "Debian 8 with only required facts and no parameters" do

    let (:facts) do
      {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '8',
      }
    end

    let (:pre_condition) do
      'include apache'
    end

    let (:params) do
      { :logroot => '/var/log/apache2' }
    end

    mod_dir = '/etc/apache2/mods-available'
    let (:mod_dir) { mod_dir }

    it_behaves_like 'minimal resources', mod_dir
    it { is_expected.to contain_file('jk.conf').with_content(
      "# This file is generated automatically by Puppet - DO NOT EDIT\n"\
      "# Any manual changes will be overwritten\n"\
      "\n"\
      "<IfModule jk_module>\n"\
      "  JkShmFile /var/log/apache2/jk-runtime-status\n"\
      "  JkLogFile /var/log/apache2/mod_jk.log\n"\
      "</IfModule>\n"
    ) }
    it {
      verify_contents(catalogue, 'jk.conf', ['<IfModule jk_module>', '</IfModule>'])
    }

  end

end
