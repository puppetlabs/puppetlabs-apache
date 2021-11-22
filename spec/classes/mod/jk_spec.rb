# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::jk', type: :class do
  it_behaves_like 'a mod class, without including apache'

  shared_examples 'minimal resources' do |mod_dir|
    it { is_expected.to compile }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to create_class('apache::mod::jk') }
    it { is_expected.to contain_class('apache') }
    it { is_expected.to contain_apache__mod('jk') }
    it { is_expected.to contain_file('jk.conf').that_notifies('Class[apache::service]') }
    it { is_expected.to contain_file('jk.conf').with(path: "#{mod_dir}/jk.conf") }
  end

  shared_examples 'specific workers_file' do |mod_dir|
    # let(:pre_condition) do
    #  'include apache'
    # end
    let(:params) do
      {
        workers_file: "#{mod_dir}/workers.properties",
        workers_file_content: {
          'worker_a' => {
            'type' => 'ajp13',
            'socket_keepalive' => 'true',
            'comment'          => 'This is worker A',
          },
          'worker_b' => {
            'type' => 'ajp13',
            'socket_keepalive' => 'true',
            'comment'          => 'This is worker B',
          },
          'worker_maintain' => 40,
          'worker_lists' => ['worker_a,worker_b'],
        },
      }
    end

    it { is_expected.to compile }
    it { is_expected.to compile.with_all_deps }
    expected_content = "# This file is generated automatically by Puppet - DO NOT EDIT\n"\
                       "# Any manual changes will be overwritten\n"\
                       "\n"\
                       "worker.list = worker_a,worker_b\n"\
                       "\n"\
                       "worker.maintain = 40\n"\
                       "\n"\
                       "# This is worker A\n"\
                       "worker.worker_a.socket_keepalive=true\n"\
                       "worker.worker_a.type=ajp13\n"\
                       "\n"\
                       "# This is worker B\n"\
                       "worker.worker_b.socket_keepalive=true\n"\
                       "worker.worker_b.type=ajp13\n"
    it { is_expected.to contain_file("#{mod_dir}/workers.properties").with_content(expected_content) }
  end

  default_ip = '192.168.1.1'
  altern8_ip = '10.1.2.3'
  default_port = 80
  altern8_port = 8008

  context 'Debian 11' do
    include_examples 'Debian 11'

    context 'with only required facts and default parameters' do
      let(:facts) { super().merge('ipaddress' => default_ip) }
      let(:pre_condition) do
        'include apache'
      end
      let(:params) do
        {
          logroot: '/var/log/apache2',
        }
      end
      let(:mod_dir) { mod_dir }

      mod_dir = '/etc/apache2/mods-available'

      it_behaves_like 'minimal resources', mod_dir
      it_behaves_like 'specific workers_file', mod_dir
      it { is_expected.to contain_apache__listen("#{default_ip}:#{default_port}") }
      it { is_expected.to contain_package('libapache2-mod-jk') }
      it {
        verify_contents(catalogue, 'jk.conf', ['<IfModule jk_module>', '</IfModule>'])
      }
    end
  end

  context 'RHEL 6' do
    include_examples 'RedHat 6'
    let(:pre_condition) do
      'include apache'
    end
    let(:params) do
      {
        logroot: '/var/log/httpd',
      }
    end

    context 'with required facts' do
      let(:facts) { super().merge('ipaddress' => default_ip) }

      context 'and default parameters' do
        let(:mod_dir) { mod_dir }

        mod_dir = '/etc/httpd/conf.d'

        it_behaves_like 'minimal resources', mod_dir
        it_behaves_like 'specific workers_file', mod_dir
        it { is_expected.to contain_apache__listen("#{default_ip}:#{default_port}") }
        it {
          verify_contents(catalogue, 'jk.conf', ['<IfModule jk_module>', '</IfModule>'])
        }
      end

      context 'and alternative IP' do
        let(:params) { super().merge(ip: altern8_ip) }

        it { is_expected.to contain_apache__listen("#{altern8_ip}:#{default_port}") }
      end

      context 'and alternative port' do
        let(:params) { super().merge(port: altern8_port) }

        it { is_expected.to contain_apache__listen("#{default_ip}:#{altern8_port}") }
      end

      context 'no binding' do
        let(:params) { super().merge(add_listen: false) }

        it { is_expected.not_to contain_apache__listen("#{default_ip}:#{default_port}") }
      end

      {
        default: {
          shm_file: :undef,
          log_file: :undef,
          shm_path: '/var/log/httpd/jk-runtime-status',
          log_path: '/var/log/httpd/mod_jk.log',
        },
        relative: {
          shm_file: 'shm_file',
          log_file: 'log_file',
          shm_path: '/var/log/httpd/shm_file',
          log_path: '/var/log/httpd/log_file',
        },
        absolute: {
          shm_file: '/run/shm_file',
          log_file: '/tmp/log_file',
          shm_path: '/run/shm_file',
          log_path: '/tmp/log_file',
        },
        pipe: {
          shm_file: :undef,
          log_file: '"|rotatelogs /var/log/httpd/mod_jk.log.%Y%m%d 86400 -180"',
          shm_path: '/var/log/httpd/jk-runtime-status',
          log_path: '"|rotatelogs /var/log/httpd/mod_jk.log.%Y%m%d 86400 -180"',
        },
      }.each do |option, paths|
        context "#{option} shm_file and log_file paths" do
          let(:params) do
            super().merge(
              shm_file: paths[:shm_file],
              log_file: paths[:log_file],
            )
          end

          expected = "# This file is generated automatically by Puppet - DO NOT EDIT\n"\
                     "# Any manual changes will be overwritten\n"\
                     "\n"\
                     "<IfModule jk_module>\n"\
                     "  JkShmFile #{paths[:shm_path]}\n"\
                     "  JkLogFile #{paths[:log_path]}\n"\
                     "</IfModule>\n"
          it { is_expected.to contain_file('jk.conf').with_content(expected) }
        end
      end
    end
  end
end
