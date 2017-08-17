require 'spec_helper'

describe 'apache::mod::jk', :type => :class do
  it_behaves_like 'a mod class, without including apache'

  shared_examples 'minimal resources' do
    it { is_expected.to compile }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to create_class('apache::mod::jk') }
    it { is_expected.to contain_class('apache') }
    it { is_expected.to contain_apache__mod('jk') }
    it { is_expected.to contain_file('jk.conf').that_notifies('Class[apache::service]') }
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

    it_behaves_like 'minimal resources'
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

    it_behaves_like 'minimal resources'
    it {
      verify_contents(catalogue, 'jk.conf', ['<IfModule jk_module>', '</IfModule>'])
    }

  end

  path_formats = {
    :undef => {
      :shm_file => :undef,
      :log_file => :undef,
      :shm_path => '/var/log/httpd/jk-runtime-status',
      :log_path => '/var/log/httpd/mod_jk.log',
    },
  }
  context 'RHEL 6 with required facts' do
    path_formats.each do |format, paths|
      context "when shm_file and log_file parameters are #{format}" do
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
          {
            :logroot  => '/var/log/httpd',
            :shm_file => paths[:shm_file],
            :log_file => paths[:shm_file],
          }
        end

        it_behaves_like 'minimal resources'
      end
    end
  end

end
