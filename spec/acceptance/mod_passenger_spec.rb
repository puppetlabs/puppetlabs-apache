require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'apache::mod::passenger class' do
  passenger_config_options = {
      'passenger_allow_encoded_slashes' => {Type: 'OnOff', PassOpt: :PassengerAllowEncodedSlashes, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_app_env' => {Type: 'String', PassOpt: :PassengerAppEnv, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_app_group_name' => {Type: 'String', PassOpt: :PassengerAppGroupName, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_app_root' => {Type: 'FullPath', PassOpt: :PassengerAppRoot, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_app_type' => {Type: 'String', PassOpt: :PassengerAppType, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_base_uri' => {Type: 'URI', PassOpt: :PassengerBaseURI, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_buffer_response' => {Type: 'OnOff', PassOpt: :PassengerBufferResponse, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_buffer_upload' => {Type: 'OnOff', PassOpt: :PassengerBufferUpload, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_concurrency_model' => {Type: ["process", "thread"], PassOpt: :PassengerConcurrencyModel, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_data_buffer_dir' => {Type: 'FullPath', PassOpt: :PassengerDataBufferDir, Context: 'server config'},
      'passenger_debug_log_file' => {Type: 'String', PassOpt: :PassengerDebugLogFile, Context: 'server config'},
      'passenger_debugger' => {Type: 'OnOff', PassOpt: :PassengerDebugger, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_default_group' => {Type: 'String', PassOpt: :PassengerDefaultGroup, Context: 'server config'},
      'passenger_default_ruby' => {Type: 'FullPath', PassOpt: :PassengerDefaultRuby, Context: 'server config'},
      'passenger_default_user' => {Type: 'String', PassOpt: :PassengerDefaultUser, Context: 'server config'},
      'passenger_disable_security_update_check' => {Type: 'OnOff', PassOpt: :PassengerDisableSecurityUpdateCheck, Context: 'server config'},
      'passenger_enabled' => {Type: 'OnOff', PassOpt: :PassengerEnabled, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_error_override' => {Type: 'OnOff', PassOpt: :PassengerErrorOverride, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_file_descriptor_log_file' => {Type: 'FullPath', PassOpt: :PassengerFileDescriptorLogFile, Context: 'server config'},
      'passenger_fly_with' => {Type: 'FullPath', PassOpt: :PassengerFlyWith, Context: 'server config'},
      'passenger_force_max_concurrent_requests_per_process' => {Type: 'Integer', PassOpt: :PassengerForceMaxConcurrentRequestsPerProcess, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_friendly_error_pages' => {Type: 'OnOff', PassOpt: :PassengerFriendlyErrorPages, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_group' => {Type: 'String', PassOpt: :PassengerGroup, Context: 'server config, virtual host, directory'},
      'passenger_high_performance' => {Type: 'OnOff', PassOpt: :PassengerHighPerformance, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_instance_registry_dir' => {Type: 'FullPath', PassOpt: :PassengerInstanceRegistryDir, Context: 'server config'},
      'passenger_load_shell_envvars' => {Type: 'OnOff', PassOpt: :PassengerLoadShellEnvvars, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_log_file' => {Type: 'FullPath', PassOpt: :PassengerLogFile, Context: 'server config'},
      'passenger_log_level' => {Type: 'Integer', PassOpt: :PassengerLogLevel, Context: 'server config'},
      'passenger_lve_min_uid' => {Type: 'Integer', PassOpt: :PassengerLveMinUid, Context: 'server config, virtual host'},
      'passenger_max_instances' => {Type: 'Integer', PassOpt: :PassengerMaxInstances, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_max_instances_per_app' => {Type: 'Integer', PassOpt: :PassengerMaxInstancesPerApp, Context: 'server config'},
      'passenger_max_pool_size' => {Type: 'Integer', PassOpt: :PassengerMaxPoolSize, Context: 'server config'},
      'passenger_max_preloader_idle_time' => {Type: 'Integer', PassOpt: :PassengerMaxPreloaderIdleTime, Context: 'server config, virtual host'},
      'passenger_max_request_queue_size' => {Type: 'Integer', PassOpt: :PassengerMaxRequestQueueSize, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_max_request_time' => {Type: 'Integer', PassOpt: :PassengerMaxRequestTime, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_max_requests' => {Type: 'Integer', PassOpt: :PassengerMaxRequests, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_memory_limit' => {Type: 'Integer', PassOpt: :PassengerMemoryLimit, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_meteor_app_settings' => {Type: 'FullPath', PassOpt: :PassengerMeteorAppSettings, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_min_instances' => {Type: 'Integer', PassOpt: :PassengerMinInstances, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_nodejs' => {Type: 'FullPath', PassOpt: :PassengerNodejs, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_pool_idle_time' => {Type: 'Integer', PassOpt: :PassengerPoolIdleTime, Context: 'server config'},
      'passenger_pre_start' => {Type: 'URI', PassOpt: :PassengerPreStart, Context: 'server config, virtual host'},
      'passenger_python' => {Type: 'FullPath', PassOpt: :PassengerPython, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_resist_deployment_errors' => {Type: 'OnOff', PassOpt: :PassengerResistDeploymentErrors, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_resolve_symlinks_in_document_root' => {Type: 'OnOff', PassOpt: :PassengerResolveSymlinksInDocumentRoot, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_response_buffer_high_watermark' => {Type: 'Integer', PassOpt: :PassengerResponseBufferHighWatermark, Context: 'server config'},
      'passenger_restart_dir' => {Type: 'Path', PassOpt: :PassengerRestartDir, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_rolling_restarts' => {Type: 'OnOff', PassOpt: :PassengerRollingRestarts, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_root' => {Type: 'FullPath', PassOpt: :PassengerRoot, Context: 'server config'},
      'passenger_ruby' => {Type: 'FullPath', PassOpt: :PassengerRuby, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_security_update_check_proxy' => {Type: 'URI', PassOpt: :PassengerSecurityUpdateCheckProxy, Context: 'server config'},
      'passenger_show_version_in_header' => {Type: 'OnOff', PassOpt: :PassengerShowVersionInHeader, Context: 'server config'},
      'passenger_socket_backlog' => {Type: 'Integer', PassOpt: :PassengerSocketBacklog, Context: 'server config'},
      'passenger_spawn_method' => {Type: ["smart", "direct"], PassOpt: :PassengerSpawnMethod, Context: 'server config, virtual host'},
      'passenger_start_timeout' => {Type: 'Integer', PassOpt: :PassengerStartTimeout, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_startup_file' => {Type: 'RelPath', PassOpt: :PassengerStartupFile, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_stat_throttle_rate' => {Type: 'Integer', PassOpt: :PassengerStatThrottleRate, Context: 'server config'},
      'passenger_sticky_sessions' => {Type: 'OnOff', PassOpt: :PassengerStickySessions, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_sticky_sessions_cookie_name' => {Type: 'String', PassOpt: :PassengerStickySessionsCookieName, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_thread_count' => {Type: 'Integer', PassOpt: :PassengerThreadCount, Context: 'server config, virtual host, directory, .htaccess'},
      'passenger_use_global_queue' => {Type: 'String', PassOpt: :PassengerUseGlobalQueue, Context: ''},
      'passenger_user' => {Type: 'String', PassOpt: :PassengerUser, Context: 'server config, virtual host, directory'},
      'passenger_user_switching' => {Type: 'OnOff', PassOpt: :PassengerUserSwitching, Context: 'server config'},
      'rack_auto_detect' => {Type: 'String', PassOpt: :RackAutoDetect, Context: 'server config'},
      'rack_base_uri' => {Type: 'String', PassOpt: :RackBaseURI, Context: 'server config'},
      'rack_env' => {Type: 'String', PassOpt: :RackEnv, Context: 'server config, virtual host, directory, .htaccess'},
      'rails_allow_mod_rewrite' => {Type: 'String', PassOpt: :RailsAllowModRewrite, Context: 'server config'},
      'rails_app_spawner_idle_time' => {Type: 'String', PassOpt: :RailsAppSpawnerIdleTime, Context: 'server config'},
      'rails_auto_detect' => {Type: 'String', PassOpt: :RailsAutoDetect, Context: 'server config'},
      'rails_base_uri' => {Type: 'String', PassOpt: :RailsBaseURI, Context: 'server config'},
      'rails_default_user' => {Type: 'String', PassOpt: :RailsDefaultUser, Context: 'server config'},
      'rails_env' => {Type: 'String', PassOpt: :RailsEnv, Context: 'server config, virtual host, directory, .htaccess'},
      'rails_framework_spawner_idle_time' => {Type: 'String', PassOpt: :RailsFrameworkSpawnerIdleTime, Context: 'server config'},
      'rails_ruby' => {Type: 'String', PassOpt: :RailsRuby, Context: 'server config'},
      'rails_spawn_method' => {Type: 'String', PassOpt: :RailsSpawnMethod, Context: 'server config'},
      'rails_user_switching' => {Type: 'String', PassOpt: :RailsUserSwitching, Context: 'server config'},
      'union_station_filter' => {Type: 'QuotedString', PassOpt: :UnionStationFilter, Context: 'server config, virtual host, directory, .htaccess'},
      'union_station_gateway_address' => {Type: 'URI', PassOpt: :UnionStationGatewayAddress, Context: 'server config, virtual host'},
      'union_station_gateway_cert' => {Type: 'FullPath', PassOpt: :UnionStationGatewayCert, Context: 'server config, virtual host'},
      'union_station_gateway_port' => {Type: 'Integer', PassOpt: :UnionStationGatewayPort, Context: 'server config, virtual host'},
      'union_station_key' => {Type: 'String', PassOpt: :UnionStationKey, Context: 'server config, virtual host, directory, .htaccess'},
      'union_station_proxy_address' => {Type: 'URI', PassOpt: :UnionStationProxyAddress, Context: 'server config, virtual host'},
      'union_station_support' => {Type: 'OnOff', PassOpt: :UnionStationSupport, Context: 'server config, virtual host, directory, .htaccess'},
      'wsgi_auto_detect' => {Type: 'String', PassOpt: :WsgiAutoDetect, Context: 'server config'},
      'rails_autodetect' => {Type: 'OnOff', PassOpt: :RailsAutoDetect, Context: 'server config'},
      'rack_autodetect' => {Type: 'OnOff', PassOpt: :RackAutoDetect, Context: 'server config'},
  }
  case fact('osfamily')
  when 'Debian'
    conf_file = "#{$mod_dir}/passenger.conf"
    load_file = "#{$mod_dir}/zpassenger.load"

    case fact('operatingsystem')
    when 'Ubuntu'
      case fact('lsbdistrelease')
      when '10.04'
        passenger_root = '/usr'
        passenger_ruby = '/usr/bin/ruby'
      when '12.04'
        passenger_root = '/usr'
        passenger_ruby = '/usr/bin/ruby'
      when '14.04'
        passenger_root         = '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini'
        passenger_ruby         = '/usr/bin/ruby'
        passenger_default_ruby = '/usr/bin/ruby'
      when '16.04'
        passenger_root         = '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini'
        passenger_ruby         = '/usr/bin/ruby'
        passenger_default_ruby = '/usr/bin/ruby'
      else
        # This may or may not work on Ubuntu releases other than the above
        passenger_root = '/usr'
        passenger_ruby = '/usr/bin/ruby'
      end
    when 'Debian'
      case fact('lsbdistcodename')
      when 'wheezy'
        passenger_root = '/usr'
        passenger_ruby = '/usr/bin/ruby'
      when 'jessie'
        passenger_root         = '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini'
        passenger_ruby         = '/usr/bin/ruby'
        passenger_default_ruby = '/usr/bin/ruby'
      else
        # This may or may not work on Debian releases other than the above
        passenger_root = '/usr'
        passenger_ruby = '/usr/bin/ruby'
      end
    end

    passenger_module_path = '/usr/lib/apache2/modules/mod_passenger.so'
    rackapp_user = 'www-data'
    rackapp_group = 'www-data'
  when 'RedHat'
    conf_file = "#{$mod_dir}/passenger.conf"
    load_file = "#{$mod_dir}/zpassenger.load"
    # sometimes installs as 3.0.12, sometimes as 3.0.19 - so just check for the stable part
    passenger_root = '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini'
    passenger_ruby = '/usr/bin/ruby'
    passenger_module_path = 'modules/mod_passenger.so'
    rackapp_user = 'apache'
    rackapp_group = 'apache'
  end

  pp_rackapp = <<-EOS
    /* a simple ruby rack 'hello world' app */
    file { '/var/www/passenger':
      ensure => directory,
      owner  => '#{rackapp_user}',
      group  => '#{rackapp_group}',
    }
    file { '/var/www/passenger/config.ru':
      ensure  => file,
      owner   => '#{rackapp_user}',
      group   => '#{rackapp_group}',
      content => "app = proc { |env| [200, { \\"Content-Type\\" => \\"text/html\\" }, [\\"hello <b>world</b>\\"]] }\\nrun app",
    }
    apache::vhost { 'passenger.example.com':
      port          => '80',
      docroot       => '/var/www/passenger/public',
      docroot_group => '#{rackapp_group}',
      docroot_owner => '#{rackapp_user}',
      require       => File['/var/www/passenger/config.ru'],
    }
    host { 'passenger.example.com': ip => '127.0.0.1', }
  EOS

  case fact('osfamily')
    when 'Debian'
      context "setting passenger options within the apache 'Directory' directive" do
       it 'should allow something with no error' do
         all_passenger_directory_options = passenger_config_options.select {|k,v| /directory/ =~ v[:Context]}
         passenger_directory_options = ''
         all_passenger_directory_options.each do |k,v|
           passenger_directory_options << "'%s' => '%s',\n" % [k,'something']
         end
          pp = <<-EOS
          class { 'apache': service_ensure => stopped }
          class { 'apache::mod::passenger': }
          /* a simple ruby rack 'hello world' app */
          file { '/var/www/passenger':
           ensure => directory,
           owner  => '#{rackapp_user}',
           group  => '#{rackapp_group}',
          }
          file { '/var/www/passenger/config.ru':
            ensure  => file,
            owner   => '#{rackapp_user}',
            group   => '#{rackapp_group}',
            content => "app = proc { |env| [200, { \\"Content-Type\\" => \\"text/html\\" }, [\\"hello <b>world</b>\\"]] }\\nrun app",
          }
          apache::vhost { 'passenger.example.com':
            port          => '80',
            docroot       => '/var/www/passenger/public',
            docroot_group => '#{rackapp_group}',
            docroot_owner => '#{rackapp_user}',
            directories => [
               { 'path' => '/var/www/passenger',
                 #{passenger_directory_options}
               }     
            ],
            require       => File['/var/www/passenger/config.ru'],
          }
          host { 'passenger.example.com': ip => '127.0.0.1', }
          EOS
         apply_manifest(pp, :catch_failures => true)
       end
       describe file("#{$vhost_dir}/25-passenger.example.com.conf") do
         all_passenger_directory_options = passenger_config_options.select {|k,v| /directory/ =~ v[:Context]}
         all_passenger_directory_options.each do |k,v|
           case v[:Type]
             when 'QuotedString', 'RelPath', 'FullPath', 'Path'
              it { is_expected.to contain "#{v[:PassOpt]} \"something\"" }
             when 'String', 'URI', 'Integer'
               it { is_expected.to contain "#{v[:PassOpt]} something" }
             else
               it { is_expected.to contain "#{v[:PassOpt]} something" }
           end
         end
       end
      end
      context "default passenger config" do
        it 'succeeds in puppeting passenger' do
          pp = <<-EOS
          /* stock apache and mod_passenger */
          class { 'apache': }
          class { 'apache::mod::passenger': }
          #{pp_rackapp}
          EOS
          apply_manifest(pp, :catch_failures => true)
        end

        describe service($service_name) do
          if (fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8')
            pending 'Should be enabled - Bug 760616 on Debian 8'
          else
            it { should be_enabled }
          end
          it { is_expected.to be_running }
        end

        describe file(conf_file) do
          it { is_expected.to contain "PassengerRoot \"#{passenger_root}\"" }

          case fact('operatingsystem')
            when 'Ubuntu'
              case fact('lsbdistrelease')
                when '10.04'
                  it { is_expected.to contain "PassengerRuby \"#{passenger_ruby}\"" }
                  it { is_expected.not_to contain "/PassengerDefaultRuby/" }
                when '12.04'
                  it { is_expected.to contain "PassengerRuby \"#{passenger_ruby}\"" }
                  it { is_expected.not_to contain "/PassengerDefaultRuby/" }
                when '14.04'
                  it { is_expected.to contain "PassengerDefaultRuby \"#{passenger_ruby}\"" }
                  it { is_expected.not_to contain "/PassengerRuby/" }
                when '16.04'
                  it { is_expected.to contain "PassengerDefaultRuby \"#{passenger_ruby}\"" }
                  it { is_expected.not_to contain "/PassengerRuby/" }
                else
                  # This may or may not work on Ubuntu releases other than the above
                  it { is_expected.to contain "PassengerRuby \"#{passenger_ruby}\"" }
                  it { is_expected.not_to contain "/PassengerDefaultRuby/" }
              end
            when 'Debian'
              case fact('lsbdistcodename')
                when 'wheezy'
                  it { is_expected.to contain "PassengerRuby \"#{passenger_ruby}\"" }
                  it { is_expected.not_to contain "/PassengerDefaultRuby/" }
                when 'jessie'
                  it { is_expected.to contain "PassengerDefaultRuby \"#{passenger_ruby}\"" }
                  it { is_expected.not_to contain "/PassengerRuby/" }
                else
                  # This may or may not work on Debian releases other than the above
                  it { is_expected.to contain "PassengerRuby \"#{passenger_ruby}\"" }
                  it { is_expected.not_to contain "/PassengerDefaultRuby/" }
              end
          end
        end

        describe file(load_file) do
          it { is_expected.to contain "LoadModule passenger_module #{passenger_module_path}" }
        end

        it 'should output status via passenger-memory-stats' do
          shell("PATH=/usr/bin:$PATH /usr/sbin/passenger-memory-stats") do |r|
            expect(r.stdout).to match(/Apache processes/)
            expect(r.stdout).to match(/Nginx processes/)
            expect(r.stdout).to match(/Passenger processes/)

            # passenger-memory-stats output on newer Debian/Ubuntu verions do not contain
            # these two lines
            unless ((fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemrelease') == '14.04') or
                (fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemrelease') == '16.04') or
                (fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'))
              expect(r.stdout).to match(/### Processes: [0-9]+/)
              expect(r.stdout).to match(/### Total private dirty RSS: [0-9\.]+ MB/)
            end

            expect(r.exit_code).to eq(0)
          end
        end

        # passenger-status fails under stock ubuntu-server-12042-x64 + mod_passenger,
        # even when the passenger process is successfully installed and running
        unless fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemrelease') == '12.04'
          it 'should output status via passenger-status' do
            # xml output not available on ubunutu <= 10.04, so sticking with default pool output
            shell("PATH=/usr/bin:$PATH /usr/sbin/passenger-status") do |r|
              # spacing may vary
              expect(r.stdout).to match(/[\-]+ General information [\-]+/)
              if fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemrelease') == '14.04' or
                  (fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemrelease') == '16.04') or
                  fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
                expect(r.stdout).to match(/Max pool size[ ]+: [0-9]+/)
                expect(r.stdout).to match(/Processes[ ]+: [0-9]+/)
                expect(r.stdout).to match(/Requests in top-level queue[ ]+: [0-9]+/)
              else
                expect(r.stdout).to match(/max[ ]+= [0-9]+/)
                expect(r.stdout).to match(/count[ ]+= [0-9]+/)
                expect(r.stdout).to match(/active[ ]+= [0-9]+/)
                expect(r.stdout).to match(/inactive[ ]+= [0-9]+/)
                expect(r.stdout).to match(/Waiting on global queue: [0-9]+/)
              end

              expect(r.exit_code).to eq(0)
            end
          end
        end

        it 'should answer to passenger.example.com' do
          shell("/usr/bin/curl passenger.example.com:80") do |r|
            expect(r.stdout).to match(/^hello <b>world<\/b>$/)
            expect(r.exit_code).to eq(0)
          end
        end

      end
  end
end
