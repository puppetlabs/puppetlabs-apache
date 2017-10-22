require 'spec_helper'

describe 'apache::vhost::access_logs', type: :define do
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

    it 'creates a CustomLog entry using `combined` and the vhost\'s `_access.log` file' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_target('apache::vhost::rspec.example.com')
        .with_content('  CustomLog "/var/log/httpd/rspec.example.com_access.log" combined ' + "\n")
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment\'s `_access.log` file' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::access_logs { "rspec.example.com": }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log-test_title')
    end
  end

  context 'With access_log_file' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_log_file: 'test.log' }
    end

    it 'creates a CustomLog entry using the custom access log file' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/test.log" combined ' + "\n")
    end
  end

  context 'With absolute access_log_file' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_log_file: '/var/log/test.log' }
    end

    it 'creates a CustomLog entry using the custom access log file' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/test.log" combined ' + "\n")
    end
  end

  context 'With access_log_pipe' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_log_pipe: "|mailx -s 'hostname' apachelogs" }
    end

    it 'creates a CustomLog entry using the custom access log pipe command' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "|mailx -s \'hostname\' apachelogs" combined ' + "\n")
    end
  end

  context 'With access_log_syslog' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_log_syslog: '|logger -p daemon.info -t httpd' }
    end

    it 'creates a CustomLog entry using the custom access syslog command' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "|logger -p daemon.info -t httpd" combined ' + "\n")
    end
  end

  context 'With access_log_format' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_log_format: 'custom_format' }
    end

    it 'creates a CustomLog entry using the custom access log format' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/rspec.example.com_access.log" "custom_format" ' + "\n")
    end
  end

  context 'With access_log_env' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_log_env_var: 'foobar' }
    end

    it 'creates a CustomLog entry using the custom access log env var' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/rspec.example.com_access.log" combined env=foobar' + "\n")
    end
  end

  context 'With access_log_file and access_log_pipe' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_log_file: 'test.log',
        access_log_pipe: "|mailx -s 'hostname' apachelogs" }
    end

    it 'raises an error' do
      is_expected.to raise_error(Puppet::Error, %r{'access_log_file' and 'access_log_pipe' cannot be defined at the same time})
    end
  end

  # THIS IS BROKEN - it should raise an error, but does not currently do so, and picks the log file over the syslog command
  context 'With access_log_file and access_log_syslog' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_log_file: 'test.log',
        access_log_syslog: '|logger -p daemon.info -t httpd' }
    end

    # it 'raises an error' do
    #   is_expected.to raise_error(Puppet::Error, %r{...})
    # end

    it 'creates a CustomLog entry using the custom access log file and not the syslog pipe' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/test.log" combined ' + "\n")
    end
  end

  # THIS IS BROKEN - it should raise an error, but does not currently do so, and picks the pipe over the syslog command
  context 'With access_log_pipe and access_log_syslog' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_log_pipe: "|mailx -s 'hostname' apachelogs",
        access_log_syslog: '|logger -p daemon.info -t httpd' }
    end

    # it 'raises an error' do
    #   is_expected.to raise_error(Puppet::Error, %r{...})
    # end

    it 'creates a CustomLog entry using the custom syslog command and not the pipe' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "|logger -p daemon.info -t httpd" combined ' + "\n")
    end
  end

  context 'With access_log_file and access_log_format' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_log_file: 'test.log',
        access_log_format: 'custom_format' }
    end

    it 'creates a CustomLog entry using the custom access log file and format' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/test.log" "custom_format" ' + "\n")
    end
  end

  context 'With access_log_file and access_log_env_var' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_log_file: 'test.log',
        access_log_env_var: 'foobar' }
    end

    it 'creates a CustomLog entry using the custom access log file and env var' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/test.log" combined env=foobar' + "\n")
    end
  end

  context 'With access_log_file, access_log_format, and access_log_env_var' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_log_file: 'test.log',
        access_log_format: 'custom_format',
        access_log_env_var: 'foobar' }
    end

    it 'creates a CustomLog entry using the custom access log file, format, and env var' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/test.log" "custom_format" env=foobar' + "\n")
    end
  end

  context 'With empty access_logs' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [] }
    end

    it 'creates an access_log fragment with no CustomLog directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .without_content(%r{CustomLog "})
    end
  end

  context 'With one access_logs entry containing `file`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [{ 'file' => '/var/log/test.log' }] }
    end

    it 'creates a CustomLog entry using the custom access log file' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/test.log" combined ' + "\n")
    end
  end

  context 'With one access_logs entry containing `pipe`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [{ 'pipe' => "|mailx -s 'hostname' apachelogs" }] }
    end

    it 'creates a CustomLog entry using the custom access log pipe command' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "|mailx -s \'hostname\' apachelogs" combined ' + "\n")
    end
  end

  context 'With one access_logs entry containing `syslog`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [{ 'syslog' => '|logger -p daemon.info -t httpd' }] }
    end

    it 'creates a CustomLog entry using the custom access syslog command' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "|logger -p daemon.info -t httpd" combined ' + "\n")
    end
  end

  context 'With one access_logs entry containing `format`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [{ 'format' => 'custom_format' }] }
    end

    it 'creates a CustomLog entry using the custom access log format' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/rspec.example.com_access.log" "custom_format" ' + "\n")
    end
  end

  context 'With one access_logs entry containing `env`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [{ 'env' => 'foobar' }] }
    end

    it 'creates a CustomLog entry using the custom access log env var' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/rspec.example.com_access.log" combined env=foobar' + "\n")
    end
  end

  # THIS IS BROKEN - it should raise an error, but does not currently do so, and picks the log file over the pipe
  context 'With one access_logs entry containing `file` and `pipe`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [{ 'file' => 'test.log', 'pipe' => "|mailx -s 'hostname' apachelogs" }] }
    end

    # it 'raises an error' do
    #   is_expected.to raise_error(Puppet::Error, %r{...})
    # end

    it 'creates a CustomLog entry using the custom access log file and not the pipe' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/test.log" combined ' + "\n")
    end
  end

  # THIS IS BROKEN - it should raise an error, but does not currently do so, and picks the log file over the syslog command
  context 'With one access_logs entry containing `file` and `syslog`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [{ 'file' => 'test.log', 'syslog' => '|logger -p daemon.info -t httpd' }] }
    end

    # it 'raises an error' do
    #   is_expected.to raise_error(Puppet::Error, %r{...})
    # end

    it 'creates a CustomLog entry using the custom access log file and not the syslog command' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/test.log" combined ' + "\n")
    end
  end

  # THIS IS BROKEN - it should raise an error, but does not currently do so, and picks the syslog command over the pipe
  context 'With one access_logs entry containing `pipe` and `syslog`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [{ 'pipe' => "mailx -s 'hostname' apachelogs", 'syslog' => '|logger -p daemon.info -t httpd' }] }
    end

    # it 'raises an error' do
    #   is_expected.to raise_error(Puppet::Error, %r{...})
    # end

    it 'creates a CustomLog entry using the syslog command and not the pipe' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "|logger -p daemon.info -t httpd" combined ' + "\n")
    end
  end

  # THIS IS BROKEN - it should raise an error, but does not currently do so, and picks the log file over the pipe or syslog command
  context 'With one access_logs entry containing `file`, `pipe`, and `syslog`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [{ 'file' => 'test.log', 'pipe' => "mailx -s 'hostname' apachelogs", 'syslog' => '|logger -p daemon.info -t httpd' }] }
    end

    # it 'raises an error' do
    #   is_expected.to raise_error(Puppet::Error, %r{...})
    # end

    it 'creates a CustomLog entry using the custom access log file and not the pipe or syslog command' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/test.log" combined ' + "\n")
    end
  end

  context 'With one access_logs entry containing `file` and `format`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [{ 'file' => 'test.log', 'format' => 'custom_format' }] }
    end

    it 'creates a CustomLog entry using the custom access log file and format' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/test.log" "custom_format" ' + "\n")
    end
  end

  context 'With one access_logs entry containing `file` and `env`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [{ 'file' => 'test.log', 'env' => 'foobar' }] }
    end

    it 'creates a CustomLog entry using the custom access log file and env var' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/test.log" combined env=foobar' + "\n")
    end
  end

  context 'With one access_logs entry containing `file`, `format`, and `env`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [{ 'file' => 'test.log', 'format' => 'custom_format', 'env' => 'foobar' }] }
    end

    it 'creates a CustomLog entry using the custom access log file, format, and env var' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/test.log" "custom_format" env=foobar' + "\n")
    end
  end

  context 'With two access_logs entries' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [{ 'file' => 'test1.log' }, { 'file' => 'test2.log' }] }
    end

    it 'creates two CustomLog entries in the specified order' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/test1.log" combined ' + "\n" + '  CustomLog "/var/log/httpd/test2.log" combined ' + "\n")
    end
  end

  context 'With two access_logs entries in a different order' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { access_logs: [{ 'file' => 'test2.log' }, { 'file' => 'test1.log' }] }
    end

    it 'creates two CustomLog entries in the specified order' do
      is_expected.to contain_concat__fragment('rspec.example.com-access_log')
        .with_content('  CustomLog "/var/log/httpd/test2.log" combined ' + "\n" + '  CustomLog "/var/log/httpd/test1.log" combined ' + "\n")
    end
  end
end
