require 'spec_helper'

describe 'apache::mod::passenger', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      case facts[:os]['family']
      when 'Debian'
        context 'validating all passenger params - using Debian' do
          it { is_expected.to contain_class('apache::params') }
          it { is_expected.to contain_apache__mod('passenger') }
          it { is_expected.to contain_package('libapache2-mod-passenger') }
          it {
            is_expected.to contain_file('zpassenger.load').with('path' => '/etc/apache2/mods-available/zpassenger.load')
          }
          it {
            is_expected.to contain_file('passenger.conf').with('path' => '/etc/apache2/mods-available/passenger.conf')
          }

          passenger_config_options = {
            'passenger_allow_encoded_slashes' => { type: 'OnOff', pass_opt: :PassengerAllowEncodedSlashes },
            'passenger_app_env' => { type: 'String', pass_opt: :PassengerAppEnv },
            'passenger_app_group_name' => { type: 'String', pass_opt: :PassengerAppGroupName },
            'passenger_app_root' => { type: 'FullPath', pass_opt: :PassengerAppRoot },
            'passenger_app_type' => { type: 'String', pass_opt: :PassengerAppType },
            'passenger_base_uri' => { type: 'URI', pass_opt: :PassengerBaseURI },
            'passenger_buffer_response' => { type: 'OnOff', pass_opt: :PassengerBufferResponse },
            'passenger_buffer_upload' => { type: 'OnOff', pass_opt: :PassengerBufferUpload },
            'passenger_concurrency_model' => { type: ['process', 'thread'], pass_opt: :PassengerConcurrencyModel },
            'passenger_data_buffer_dir' => { type: 'FullPath', pass_opt: :PassengerDataBufferDir },
            'passenger_debug_log_file' => { type: 'String', pass_opt: :PassengerDebugLogFile },
            'passenger_debugger' => { type: 'OnOff', pass_opt: :PassengerDebugger },
            'passenger_default_group' => { type: 'String', pass_opt: :PassengerDefaultGroup },
            'passenger_default_ruby' => { type: 'FullPath', pass_opt: :PassengerDefaultRuby },
            'passenger_default_user' => { type: 'String', pass_opt: :PassengerDefaultUser },
            'passenger_disable_security_update_check' => { type: 'OnOff', pass_opt: :PassengerDisableSecurityUpdateCheck },
            'passenger_enabled' => { type: 'OnOff', pass_opt: :PassengerEnabled },
            'passenger_error_override' => { type: 'OnOff', pass_opt: :PassengerErrorOverride },
            'passenger_file_descriptor_log_file' => { type: 'FullPath', pass_opt: :PassengerFileDescriptorLogFile },
            'passenger_fly_with' => { type: 'FullPath', pass_opt: :PassengerFlyWith },
            'passenger_force_max_concurrent_requests_per_process' => { type: 'Integer', pass_opt: :PassengerForceMaxConcurrentRequestsPerProcess },
            'passenger_friendly_error_pages' => { type: 'OnOff', pass_opt: :PassengerFriendlyErrorPages },
            'passenger_group' => { type: 'String', pass_opt: :PassengerGroup },
            'passenger_high_performance' => { type: 'OnOff', pass_opt: :PassengerHighPerformance },
            'passenger_instance_registry_dir' => { type: 'FullPath', pass_opt: :PassengerInstanceRegistryDir },
            'passenger_load_shell_envvars' => { type: 'OnOff', pass_opt: :PassengerLoadShellEnvvars },
            'passenger_log_file' => { type: 'FullPath', pass_opt: :PassengerLogFile },
            'passenger_log_level' => { type: 'Integer', pass_opt: :PassengerLogLevel },
            'passenger_lve_min_uid' => { type: 'Integer', pass_opt: :PassengerLveMinUid },
            'passenger_max_instances' => { type: 'Integer', pass_opt: :PassengerMaxInstances },
            'passenger_max_instances_per_app' => { type: 'Integer', pass_opt: :PassengerMaxInstancesPerApp },
            'passenger_max_pool_size' => { type: 'Integer', pass_opt: :PassengerMaxPoolSize },
            'passenger_max_preloader_idle_time' => { type: 'Integer', pass_opt: :PassengerMaxPreloaderIdleTime },
            'passenger_max_request_queue_size' => { type: 'Integer', pass_opt: :PassengerMaxRequestQueueSize },
            'passenger_max_request_time' => { type: 'Integer', pass_opt: :PassengerMaxRequestTime },
            'passenger_max_requests' => { type: 'Integer', pass_opt: :PassengerMaxRequests },
            'passenger_memory_limit' => { type: 'Integer', pass_opt: :PassengerMemoryLimit },
            'passenger_meteor_app_settings' => { type: 'FullPath', pass_opt: :PassengerMeteorAppSettings },
            'passenger_min_instances' => { type: 'Integer', pass_opt: :PassengerMinInstances },
            'passenger_nodejs' => { type: 'FullPath', pass_opt: :PassengerNodejs },
            'passenger_pool_idle_time' => { type: 'Integer', pass_opt: :PassengerPoolIdleTime },
            'passenger_pre_start' => { type: 'URI', pass_opt: :PassengerPreStart },
            'passenger_python' => { type: 'FullPath', pass_opt: :PassengerPython },
            'passenger_resist_deployment_errors' => { type: 'OnOff', pass_opt: :PassengerResistDeploymentErrors },
            'passenger_resolve_symlinks_in_document_root' => { type: 'OnOff', pass_opt: :PassengerResolveSymlinksInDocumentRoot },
            'passenger_response_buffer_high_watermark' => { type: 'Integer', pass_opt: :PassengerResponseBufferHighWatermark },
            'passenger_restart_dir' => { type: 'Path', pass_opt: :PassengerRestartDir },
            'passenger_rolling_restarts' => { type: 'OnOff', pass_opt: :PassengerRollingRestarts },
            'passenger_root' => { type: 'FullPath', pass_opt: :PassengerRoot },
            'passenger_ruby' => { type: 'FullPath', pass_opt: :PassengerRuby },
            'passenger_security_update_check_proxy' => { type: 'URI', pass_opt: :PassengerSecurityUpdateCheckProxy },
            'passenger_show_version_in_header' => { type: 'OnOff', pass_opt: :PassengerShowVersionInHeader },
            'passenger_socket_backlog' => { type: 'Integer', pass_opt: :PassengerSocketBacklog },
            'passenger_spawn_method' => { type: ['smart', 'direct'], pass_opt: :PassengerSpawnMethod },
            'passenger_start_timeout' => { type: 'Integer', pass_opt: :PassengerStartTimeout },
            'passenger_startup_file' => { type: 'RelPath', pass_opt: :PassengerStartupFile },
            'passenger_stat_throttle_rate' => { type: 'Integer', pass_opt: :PassengerStatThrottleRate },
            'passenger_sticky_sessions' => { type: 'OnOff', pass_opt: :PassengerStickySessions },
            'passenger_sticky_sessions_cookie_name' => { type: 'String', pass_opt: :PassengerStickySessionsCookieName },
            'passenger_thread_count' => { type: 'Integer', pass_opt: :PassengerThreadCount },
            'passenger_use_global_queue' => { type: 'String', pass_opt: :PassengerUseGlobalQueue },
            'passenger_user' => { type: 'String', pass_opt: :PassengerUser },
            'passenger_user_switching' => { type: 'OnOff', pass_opt: :PassengerUserSwitching },
            'rack_auto_detect' => { type: 'String', pass_opt: :RackAutoDetect },
            'rack_autodetect' => { type: 'String', pass_opt: :RackAutoDetect },
            'rack_base_uri' => { type: 'String', pass_opt: :RackBaseURI },
            'rack_env' => { type: 'String', pass_opt: :RackEnv },
            'rails_allow_mod_rewrite' => { type: 'String', pass_opt: :RailsAllowModRewrite },
            'rails_app_spawner_idle_time' => { type: 'String', pass_opt: :RailsAppSpawnerIdleTime },
            'rails_auto_detect' => { type: 'String', pass_opt: :RailsAutoDetect },
            'rails_autodetect' => { type: 'String', pass_opt: :RailsAutoDetect },
            'rails_base_uri' => { type: 'String', pass_opt: :RailsBaseURI },
            'rails_default_user' => { type: 'String', pass_opt: :RailsDefaultUser },
            'rails_env' => { type: 'String', pass_opt: :RailsEnv },
            'rails_framework_spawner_idle_time' => { type: 'String', pass_opt: :RailsFrameworkSpawnerIdleTime },
            'rails_ruby' => { type: 'String', pass_opt: :RailsRuby },
            'rails_spawn_method' => { type: 'String', pass_opt: :RailsSpawnMethod },
            'rails_user_switching' => { type: 'String', pass_opt: :RailsUserSwitching },
            'wsgi_auto_detect' => { type: 'String', pass_opt: :WsgiAutoDetect },
          }
          passenger_config_options.each do |config_option, config_hash|
            puppetized_config_option = config_option
            case config_hash[:type]
              # UnionStationFilter values are quoted strings
            when 'QuotedString'
              valid_config_values = ['"a quoted string"']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => '#{valid_value.delete('"')}'" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('passenger.conf').with_content(%r{^  #{config_hash[:pass_opt]} "#{valid_value}"$}) }
                end
              end
            when 'FullPath', 'RelPath', 'Path'
              valid_config_values = ['/some/path/to/somewhere']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => #{valid_value}" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('passenger.conf').with_content(%r{^  #{config_hash[:pass_opt]} "#{valid_value}"$}) }
                end
              end
            when 'URI', 'String', 'Integer'
              valid_config_values = ['some_value_for_you']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => #{valid_value}" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('passenger.conf').with_content(%r{^  #{config_hash[:pass_opt]} #{valid_value}$}) }
                end
              end
            when 'OnOff'
              valid_config_values = ['on', 'off']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => '#{valid_value}'" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('passenger.conf').with_content(%r{^  #{config_hash[:pass_opt]} #{valid_value}$}) }
                end
              end
            else
              valid_config_values = config_hash[:type]
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => '#{valid_value}'" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('passenger.conf').with_content(%r{^  #{config_hash[:pass_opt]} #{valid_value}$}) }
                end
              end
            end
          end
        end

        it { is_expected.to contain_class('apache::params') }
        it { is_expected.to contain_apache__mod('passenger') }
        it { is_expected.to contain_package('libapache2-mod-passenger') }
        it {
          is_expected.to contain_file('zpassenger.load').with('path' => '/etc/apache2/mods-available/zpassenger.load')
        }
        it {
          is_expected.to contain_file('passenger.conf').with('path' => '/etc/apache2/mods-available/passenger.conf')
        }

        context 'passenger config with passenger_installed_version set', test: true do
          describe 'fails when an option is not valid for $passenger_installed_version' do
            let :params do
              {
                passenger_installed_version: '4.0.0',
                passenger_instance_registry_dir: '/some/path/to/nowhere',
              }
            end

            it { is_expected.to raise_error(%r{passenger_instance_registry_dir is not introduced until version 5.0.0}) }
          end

          describe 'fails when an option is removed' do
            let :params do
              {
                passenger_installed_version: '5.0.0',
                rails_autodetect: 'on',
              }
            end

            it { is_expected.to raise_error(%r{REMOVED PASSENGER OPTION}) }
          end

          describe 'warns when an option is deprecated' do
            puts facts[:os]['family']
            puts facts[:os]['release']

            let :params do
              {
                passenger_installed_version: '5.0.0',
                rails_ruby: '/some/path/to/ruby',
              }
            end

            specify { expect { warn(%r{DEPRECATED PASSENGER OPTION}) }.to output(%r{DEPRECATED PASSENGER OPTION}).to_stderr }
          end
        end

        describe "with passenger_root => '/usr/lib/example'" do
          let :params do
            { passenger_root: '/usr/lib/example' }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerRoot "/usr/lib/example"}) }
        end
        describe 'with passenger_ruby => /usr/lib/example/ruby' do
          let :params do
            { passenger_ruby: '/usr/lib/example/ruby' }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerRuby "/usr/lib/example/ruby"}) }
        end
        describe 'with passenger_default_ruby => /usr/lib/example/ruby1.9.3' do
          let :params do
            { passenger_ruby: '/usr/lib/example/ruby1.9.3' }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerRuby "/usr/lib/example/ruby1.9.3"}) }
        end
        describe 'with passenger_high_performance => on' do
          let :params do
            { passenger_high_performance: 'on' }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerHighPerformance on$}) }
        end
        describe 'with passenger_pool_idle_time => 1200' do
          let :params do
            { passenger_pool_idle_time: 1200 }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerPoolIdleTime 1200$}) }
        end
        describe 'with passenger_max_request_queue_size => 100' do
          let :params do
            { passenger_max_request_queue_size: 100 }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerMaxRequestQueueSize 100$}) }
        end

        describe 'with passenger_max_requests => 20' do
          let :params do
            { passenger_max_requests: 20 }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerMaxRequests 20$}) }
        end
        describe 'with passenger_spawn_method => direct' do
          let :params do
            { passenger_spawn_method: 'direct' }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerSpawnMethod direct$}) }
        end
        describe 'with passenger_stat_throttle_rate => 10' do
          let :params do
            { passenger_stat_throttle_rate: 10 }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerStatThrottleRate 10$}) }
        end
        describe 'with passenger_max_pool_size => 16' do
          let :params do
            { passenger_max_pool_size: 16 }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerMaxPoolSize 16$}) }
        end
        describe 'with passenger_min_instances => 5' do
          let :params do
            { passenger_min_instances: 5 }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerMinInstances 5$}) }
        end
        describe 'with passenger_max_instances_per_app => 8' do
          let :params do
            { passenger_max_instances_per_app: 8 }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerMaxInstancesPerApp 8$}) }
        end
        describe 'with rack_autodetect => on' do
          let :params do
            { rack_autodetect: 'on' }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  RackAutoDetect on$}) }
        end
        describe 'with rails_autodetect => on' do
          let :params do
            { rails_autodetect: 'on' }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  RailsAutoDetect on$}) }
        end
        describe 'with passenger_use_global_queue => on' do
          let :params do
            { passenger_use_global_queue: 'on' }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerUseGlobalQueue on$}) }
        end
        describe "with passenger_app_env => 'foo'" do
          let :params do
            { passenger_app_env: 'foo' }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerAppEnv foo$}) }
        end
        describe "with passenger_log_file => '/var/log/apache2/passenger.log'" do
          let :params do
            { passenger_log_file: '/var/log/apache2/passenger.log' }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerLogFile "/var/log/apache2/passenger.log"$}) }
        end
        describe 'with passenger_log_level => 3' do
          let :params do
            { passenger_log_level: 3 }
          end

          it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerLogLevel 3$}) }
        end
        describe "with mod_path => '/usr/lib/foo/mod_foo.so'" do
          let :params do
            { mod_path: '/usr/lib/foo/mod_foo.so' }
          end

          it { is_expected.to contain_file('zpassenger.load').with_content(%r{^LoadModule passenger_module \/usr\/lib\/foo\/mod_foo\.so$}) }
        end
        describe "with mod_lib_path => '/usr/lib/foo'" do
          let :params do
            { mod_lib_path: '/usr/lib/foo' }
          end

          it { is_expected.to contain_file('zpassenger.load').with_content(%r{^LoadModule passenger_module \/usr\/lib\/foo\/mod_passenger\.so$}) }
        end
        describe "with mod_lib => 'mod_foo.so'" do
          let :params do
            { mod_lib: 'mod_foo.so' }
          end

          it { is_expected.to contain_file('zpassenger.load').with_content(%r{^LoadModule passenger_module \/usr\/lib\/apache2\/modules\/mod_foo\.so$}) }
        end
        describe "with mod_id => 'mod_foo'" do
          let :params do
            { mod_id: 'mod_foo' }
          end

          it { is_expected.to contain_file('zpassenger.load').with_content(%r{^LoadModule mod_foo \/usr\/lib\/apache2\/modules\/mod_passenger\.so$}) }
        end

        context 'with Ubuntu 16.04 defaults' do
          it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerRoot "/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini"}) }
          it { is_expected.to contain_file('passenger.conf').without_content(%r{PassengerRuby}) }
          it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerDefaultRuby "/usr/bin/ruby"}) }
        end

        if facts[:os]['release']['major'].to_i == 8
          context 'with Debian 8 defaults' do
            it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerRoot "/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini"}) }
            it { is_expected.to contain_file('passenger.conf').without_content(%r{PassengerRuby}) }
            it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerDefaultRuby "/usr/bin/ruby"}) }
          end
        end
      when 'RedHat'
        context 'on a RedHat OS' do
          case facts[:os]['release']['major']
          when '6'
            context 'on EL6' do
              it { is_expected.to contain_class('apache::params') }
              it { is_expected.to contain_apache__mod('passenger') }
              it { is_expected.to contain_package('mod_passenger') }
              it {
                is_expected.to contain_file('passenger_package.conf').with('path' => '/etc/httpd/conf.d/passenger.conf')
              }
              it { is_expected.to contain_file('passenger_package.conf').without_content }
              it { is_expected.to contain_file('passenger_package.conf').without_source }
              it {
                is_expected.to contain_file('zpassenger.load').with('path' => '/etc/httpd/conf.d/zpassenger.load')
              }
              it { is_expected.to contain_file('passenger.conf').without_content(%r{PassengerRoot}) }
              it { is_expected.to contain_file('passenger.conf').without_content(%r{PassengerRuby}) }
              describe "with passenger_root => '/usr/lib/example'" do
                let :params do
                  { passenger_root: '/usr/lib/example' }
                end

                it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerRoot "\/usr\/lib\/example"$}) }
              end
              describe 'with passenger_ruby => /usr/lib/example/ruby' do
                let :params do
                  { passenger_ruby: '/usr/lib/example/ruby' }
                end

                it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerRuby "\/usr\/lib\/example\/ruby"$}) }
              end
            end
          when '7'

            context 'on EL7' do
              it {
                is_expected.to contain_file('passenger_package.conf').with('path' => '/etc/httpd/conf.d/passenger.conf')
              }
              it {
                is_expected.to contain_file('zpassenger.load').with('path' => '/etc/httpd/conf.modules.d/zpassenger.load')
              }
            end
          end
        end
      when 'FreeBSD'
        context 'on a FreeBSD OS' do
          it { is_expected.to contain_class('apache::params') }
          it { is_expected.to contain_apache__mod('passenger') }
          it { is_expected.to contain_package('www/rubygem-passenger') }
        end
      when 'Gentoo'
        context 'on a Gentoo OS' do
          it { is_expected.to contain_class('apache::params') }
          it { is_expected.to contain_apache__mod('passenger') }
          it { is_expected.to contain_package('www-apache/passenger') }
        end
      end
    end
  end
end
