require 'spec_helper'

describe 'apache::vhost::error_log', type: :define do
  let :facts do
    {
      osfamily: 'RedHat',
      operatingsystemrelease: '6',
      concat_basedir: '/dne',
      operatingsystem: 'RedHat',
      id: 'root',
      kernel: 'Linux',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      is_pe: false,
    }
  end
  let :pre_condition do
    'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}'
  end

  context 'With no parameters' do
    let(:title) { 'rspec.example.com' }

    it 'creates a default ErrorLog entry' do
      is_expected.to contain_concat__fragment('rspec.example.com-logging')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ErrorLog "/var/log/httpd/rspec.example.com_error.log"\n})
    end
  end

  context 'With error_log set to `false`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { error_log: false }
    end

    it 'fails' do
      is_expected.to compile.and_raise_error(%r{must be defined})
    end
  end

  context 'With error_log_file set to an absolute path' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { error_log_file: '/foo' }
    end

    it 'points create an ErrorLog to the absolute path' do
      is_expected.to contain_concat__fragment('rspec.example.com-logging')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ErrorLog "/foo"\n})
    end
  end

  context 'With error_log_file set to a relative path' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { error_log_file: 'foo' }
    end

    it 'points create an ErrorLog to the filename within the default log directory' do
      is_expected.to contain_concat__fragment('rspec.example.com-logging')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ErrorLog "/var/log/httpd/foo"\n})
    end
  end

  context 'With error_log_pipe set' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { error_log_pipe: '|foo' }
    end

    it 'points create an ErrorLog to the error_log_pipe' do
      is_expected.to contain_concat__fragment('rspec.example.com-logging')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ErrorLog "|foo"\n})
    end
  end

  context 'With error_log_syslog set' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { error_log_syslog: 'syslog:foo' }
    end

    it 'points create an ErrorLog to the error_log_syslog' do
      is_expected.to contain_concat__fragment('rspec.example.com-logging')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ErrorLog "syslog:foo"\n})
    end
  end

  context 'With both error_log_file and error_log_pipe set' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { error_log_file: 'foo',
        error_log_pipe: '|foo' }
    end

    it 'fails' do
      is_expected.to compile.and_raise_error(%r{cannot be defined at the same time})
    end
  end

  context 'With both error_log_file and error_log_syslog set' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { error_log_file: 'foo',
        error_log_syslog: 'syslog:foo' }
    end

    it 'fails' do
      is_expected.to compile.and_raise_error(%r{cannot be defined at the same time})
    end
  end

  context 'With both error_log_pipe and error_log_syslog set' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { error_log_pipe: '|foo',
        error_log_syslog: 'syslog:foo' }
    end

    it 'fails' do
      is_expected.to compile.and_raise_error(%r{cannot be defined at the same time})
    end
  end

  context 'With error_log set to `false` and log_level set' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { error_log: false,
        log_level: 'info' }
    end

    it 'creates a LogLevel entry with the specified log level' do
      is_expected.to contain_concat__fragment('rspec.example.com-logging')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  LogLevel info\n})
    end
  end

  context 'With log_level set to an invalid value' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { error_log: false,
        log_level: 'foo' }
    end

    it 'fails' do
      is_expected.to compile.and_raise_error(%r{is not one of the supported Apache HTTP Server log levels})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { error_log_file: '/foo',
        vhost: 'rspec.example.com' }
    end

    it 'creates the same concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-logging')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { error_log_file: '/foo',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::error_log { "rspec.example.com": error_log_pipe => "|foo" }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
