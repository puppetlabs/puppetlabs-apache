require 'spec_helper'

describe 'apache::vhost::passenger', type: :define do
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

    it 'does not include the concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-passenger')
    end
  end

  context 'With a passenger_spawn_method parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { passenger_spawn_method: 'foo' }
    end

    it 'creates a PassengerSpawnMethod entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-passenger')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  PassengerSpawnMethod foo\n})
    end
  end

  context 'With a passenger_app_root parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { passenger_app_root: 'foo' }
    end

    it 'creates a PassengerAppRoot entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-passenger')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  PassengerAppRoot foo\n})
    end
  end

  context 'With a passenger_app_env parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { passenger_app_env: 'foo' }
    end

    it 'creates a PassengerAppEnv entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-passenger')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  PassengerAppEnv foo\n})
    end
  end

  context 'With a passenger_ruby parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { passenger_ruby: 'foo' }
    end

    it 'creates a PassengerRuby entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-passenger')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  PassengerRuby foo\n})
    end
  end

  context 'With a passenger_min_instances parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { passenger_min_instances: 'foo' }
    end

    it 'creates a PassengerMinInstances entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-passenger')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  PassengerMinInstances foo\n})
    end
  end

  context 'With a passenger_max_requests parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { passenger_max_requests: 'foo' }
    end

    it 'creates a PassengerMaxRequests entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-passenger')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  PassengerMaxRequests foo\n})
    end
  end

  context 'With a passenger_start_timeout parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { passenger_start_timeout: 'foo' }
    end

    it 'creates a PassengerStartTimeout entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-passenger')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  PassengerStartTimeout foo\n})
    end
  end

  context 'With a passenger_user parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { passenger_user: 'foo' }
    end

    it 'creates a PassengerUser entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-passenger')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  PassengerUser foo\n})
    end
  end

  context 'With a passenger_group parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { passenger_group: 'foo' }
    end

    it 'creates a PassengerGroup entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-passenger')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  PassengerGroup foo\n})
    end
  end

  context 'With a passenger_high_performance parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { passenger_high_performance: 'foo' }
    end

    it 'creates a PassengerHighPerformance entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-passenger')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  PassengerHighPerformance foo\n})
    end
  end

  context 'With a passenger_nodejs parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { passenger_nodejs: 'foo' }
    end

    it 'creates a PassengerNodejs entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-passenger')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  PassengerNodejs foo\n})
    end
  end

  context 'With a passenger_sticky_sessions parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { passenger_sticky_sessions: true }
    end

    it 'creates a PassengerStickySessions entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-passenger')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  PassengerStickySessions On\n})
    end
  end

  context 'With a passenger_startup_file parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { passenger_startup_file: 'foo' }
    end

    it 'creates a PassengerStartupFile entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-passenger')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  PassengerStartupFile foo\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { passenger_spawn_method: 'foo',
        vhost: 'rspec.example.com' }
    end

    it 'creates the same concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-passenger')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { passenger_spawn_method: 'foo',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::passenger { "rspec.example.com": passenger_spawn_method => "bar" }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
