require 'spec_helper'

describe 'apache::vhost::wsgi', type: :define do
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

    it 'compiles' do
      is_expected.to compile
    end
    it 'does not create the concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-wsgi')
    end
  end

  context 'With a value for `wsgi_application_group`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { wsgi_application_group: 'App' }
    end

    it 'creates the WSGIApplicationGroup directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{WSGIApplicationGroup +App})
    end
  end

  context 'With a value for `wsgi_process_group`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { wsgi_process_group: 'myProcessGroup' }
    end

    it 'creates the WSGIProcessGroup directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{WSGIProcessGroup +myProcessGroup})
    end
  end

  context 'With a value for `wsgi_pass_authorization`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { wsgi_pass_authorization: 'on' }
    end

    it 'creates the WSGIPassAuthorization directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{WSGIPassAuthorization +on})
    end
  end

  context 'With a value for `wsgi_chunked_request`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { wsgi_chunked_request: 'on' }
    end

    it 'creates the WSGIChunkedRequest directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{WSGIChunkedRequest +on})
    end
  end

  context 'With a value for `wsgi_daemon_process`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { wsgi_daemon_process: 'daemons' }
    end

    it 'creates the WSGIDaemonProcess directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{WSGIDaemonProcess +daemons\n})
    end
  end

  context 'With a value for `wsgi_daemon_process` and an empty `wsgi_daemon_process_options`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { wsgi_daemon_process: 'daemons',
        wsgi_daemon_process_options: {} }
    end

    it 'creates the WSGIDaemonProcess directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{WSGIDaemonProcess +daemons +\n})
    end
  end

  context 'With a value for `wsgi_daemon_process` and `wsgi_daemon_process_options`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { wsgi_daemon_process: 'daemons',
        wsgi_daemon_process_options: {
          'processes' => 2,
          'display-name' => '%{GROUP}',
        } }
    end

    it 'creates the WSGIDaemonProcess directive with the specified options' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{WSGIDaemonProcess +daemons +display-name=%\{GROUP\} +processes=2})
    end
  end

  context 'With a value for `wsgi_import_script`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { wsgi_import_script: '/path/to/script' }
    end

    it 'does not create the concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-wsgi')
    end
  end

  context 'With a value for `wsgi_import_script` and an empty `wsgi_import_script_options`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { wsgi_import_script: '/path/to/script',
        wsgi_import_script_options: {} }
    end

    it 'creates the WSGIImportScript directive with the given options' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{WSGIImportScript +/path/to/script +\n})
    end
  end

  context 'With a value for `wsgi_import_script` and `wsgi_inport_script_options`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { wsgi_import_script: '/path/to/script',
        wsgi_import_script_options: {
          'process-group' => 'myProcessGroup',
          'application-group' => '%{GLOBAL}',
        } }
    end

    it 'creates the WSGIImportScript directive with the given options' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{WSGIImportScript +/path/to/script +application-group=%\{GLOBAL\} +process-group=myProcessGroup})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { wsgi_application_group: 'App2',
        vhost: 'rspec.example.com' }
    end

    it 'creates the same concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { wsgi_application_group: 'App2',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::wsgi { "rspec.example.com": wsgi_application_group => "App1" }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
