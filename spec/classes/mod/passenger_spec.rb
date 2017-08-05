require 'spec_helper'

describe 'apache::mod::passenger', :type => :class do
  it_behaves_like "a mod class, without including apache"
  context "validating all passenger params - using Debian" do
    let :facts do
      {
          :osfamily               => 'Debian',
          :operatingsystemrelease => '6',
          :kernel                 => 'Linux',
          :concat_basedir         => '/dne',
          :lsbdistcodename        => 'squeeze',
          :operatingsystem        => 'Debian',
          :id                     => 'root',
          :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          :is_pe                  => false,
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod('passenger') }
    it { is_expected.to contain_package("libapache2-mod-passenger") }
    it { is_expected.to contain_file('zpassenger.load').with({
                                                                 'path' => '/etc/apache2/mods-available/zpassenger.load',
                                                             }) }
    it { is_expected.to contain_file('passenger.conf').with({
                                                                'path' => '/etc/apache2/mods-available/passenger.conf',
                                                            }) }

    passenger_config_options = {
        'passenger_allow_encoded_slashes' => {Type: 'OnOff', PassOpt: :PassengerAllowEncodedSlashes},
        'passenger_app_env' => {Type: 'String', PassOpt: :PassengerAppEnv},
        'passenger_app_group_name' => {Type: 'String', PassOpt: :PassengerAppGroupName},
        'passenger_app_root' => {Type: 'FullPath', PassOpt: :PassengerAppRoot},
        'passenger_app_type' => {Type: 'String', PassOpt: :PassengerAppType},
        'passenger_base_uri' => {Type: 'URI', PassOpt: :PassengerBaseURI},
        'passenger_buffer_response' => {Type: 'OnOff', PassOpt: :PassengerBufferResponse},
        'passenger_buffer_upload' => {Type: 'OnOff', PassOpt: :PassengerBufferUpload},
        'passenger_concurrency_model' => {Type: ["process", "thread"], PassOpt: :PassengerConcurrencyModel},
        'passenger_data_buffer_dir' => {Type: 'FullPath', PassOpt: :PassengerDataBufferDir},
        'passenger_debug_log_file' => {Type: 'String', PassOpt: :PassengerDebugLogFile},
        'passenger_debugger' => {Type: 'OnOff', PassOpt: :PassengerDebugger},
        'passenger_default_group' => {Type: 'String', PassOpt: :PassengerDefaultGroup},
        'passenger_default_ruby' => {Type: 'FullPath', PassOpt: :PassengerDefaultRuby},
        'passenger_default_user' => {Type: 'String', PassOpt: :PassengerDefaultUser},
        'passenger_disable_security_update_check' => {Type: 'OnOff', PassOpt: :PassengerDisableSecurityUpdateCheck},
        'passenger_enabled' => {Type: 'OnOff', PassOpt: :PassengerEnabled},
        'passenger_error_override' => {Type: 'OnOff', PassOpt: :PassengerErrorOverride},
        'passenger_file_descriptor_log_file' => {Type: 'FullPath', PassOpt: :PassengerFileDescriptorLogFile},
        'passenger_fly_with' => {Type: 'FullPath', PassOpt: :PassengerFlyWith},
        'passenger_force_max_concurrent_requests_per_process' => {Type: 'Integer', PassOpt: :PassengerForceMaxConcurrentRequestsPerProcess},
        'passenger_friendly_error_pages' => {Type: 'OnOff', PassOpt: :PassengerFriendlyErrorPages},
        'passenger_group' => {Type: 'String', PassOpt: :PassengerGroup},
        'passenger_high_performance' => {Type: 'OnOff', PassOpt: :PassengerHighPerformance},
        'passenger_instance_registry_dir' => {Type: 'FullPath', PassOpt: :PassengerInstanceRegistryDir},
        'passenger_load_shell_envvars' => {Type: 'OnOff', PassOpt: :PassengerLoadShellEnvvars},
        'passenger_log_file' => {Type: 'FullPath', PassOpt: :PassengerLogFile},
        'passenger_log_level' => {Type: 'Integer', PassOpt: :PassengerLogLevel},
        'passenger_lve_min_uid' => {Type: 'Integer', PassOpt: :PassengerLveMinUid},
        'passenger_max_instances' => {Type: 'Integer', PassOpt: :PassengerMaxInstances},
        'passenger_max_instances_per_app' => {Type: 'Integer', PassOpt: :PassengerMaxInstancesPerApp},
        'passenger_max_pool_size' => {Type: 'Integer', PassOpt: :PassengerMaxPoolSize},
        'passenger_max_preloader_idle_time' => {Type: 'Integer', PassOpt: :PassengerMaxPreloaderIdleTime},
        'passenger_max_request_queue_size' => {Type: 'Integer', PassOpt: :PassengerMaxRequestQueueSize},
        'passenger_max_request_time' => {Type: 'Integer', PassOpt: :PassengerMaxRequestTime},
        'passenger_max_requests' => {Type: 'Integer', PassOpt: :PassengerMaxRequests},
        'passenger_memory_limit' => {Type: 'Integer', PassOpt: :PassengerMemoryLimit},
        'passenger_meteor_app_settings' => {Type: 'FullPath', PassOpt: :PassengerMeteorAppSettings},
        'passenger_min_instances' => {Type: 'Integer', PassOpt: :PassengerMinInstances},
        'passenger_nodejs' => {Type: 'FullPath', PassOpt: :PassengerNodejs},
        'passenger_pool_idle_time' => {Type: 'Integer', PassOpt: :PassengerPoolIdleTime},
        'passenger_pre_start' => {Type: 'URI', PassOpt: :PassengerPreStart},
        'passenger_python' => {Type: 'FullPath', PassOpt: :PassengerPython},
        'passenger_resist_deployment_errors' => {Type: 'OnOff', PassOpt: :PassengerResistDeploymentErrors},
        'passenger_resolve_symlinks_in_document_root' => {Type: 'OnOff', PassOpt: :PassengerResolveSymlinksInDocumentRoot},
        'passenger_response_buffer_high_watermark' => {Type: 'Integer', PassOpt: :PassengerResponseBufferHighWatermark},
        'passenger_restart_dir' => {Type: 'Path', PassOpt: :PassengerRestartDir},
        'passenger_rolling_restarts' => {Type: 'OnOff', PassOpt: :PassengerRollingRestarts},
        'passenger_root' => {Type: 'FullPath', PassOpt: :PassengerRoot},
        'passenger_ruby' => {Type: 'FullPath', PassOpt: :PassengerRuby},
        'passenger_security_update_check_proxy' => {Type: 'URI', PassOpt: :PassengerSecurityUpdateCheckProxy},
        'passenger_show_version_in_header' => {Type: 'OnOff', PassOpt: :PassengerShowVersionInHeader},
        'passenger_socket_backlog' => {Type: 'Integer', PassOpt: :PassengerSocketBacklog},
        'passenger_spawn_method' => {Type: ["smart", "direct"], PassOpt: :PassengerSpawnMethod},
        'passenger_start_timeout' => {Type: 'Integer', PassOpt: :PassengerStartTimeout},
        'passenger_startup_file' => {Type: 'RelPath', PassOpt: :PassengerStartupFile},
        'passenger_stat_throttle_rate' => {Type: 'Integer', PassOpt: :PassengerStatThrottleRate},
        'passenger_sticky_sessions' => {Type: 'OnOff', PassOpt: :PassengerStickySessions},
        'passenger_sticky_sessions_cookie_name' => {Type: 'String', PassOpt: :PassengerStickySessionsCookieName},
        'passenger_thread_count' => {Type: 'Integer', PassOpt: :PassengerThreadCount},
        'passenger_use_global_queue' => {Type: 'String', PassOpt: :PassengerUseGlobalQueue},
        'passenger_user' => {Type: 'String', PassOpt: :PassengerUser},
        'passenger_user_switching' => {Type: 'OnOff', PassOpt: :PassengerUserSwitching},
        'rack_auto_detect' => {Type: 'String', PassOpt: :RackAutoDetect},
        'rack_base_uri' => {Type: 'String', PassOpt: :RackBaseURI},
        'rack_env' => {Type: 'String', PassOpt: :RackEnv},
        'rails_allow_mod_rewrite' => {Type: 'String', PassOpt: :RailsAllowModRewrite},
        'rails_app_spawner_idle_time' => {Type: 'String', PassOpt: :RailsAppSpawnerIdleTime},
        'rails_auto_detect' => {Type: 'String', PassOpt: :RailsAutoDetect},
        'rails_base_uri' => {Type: 'String', PassOpt: :RailsBaseURI},
        'rails_default_user' => {Type: 'String', PassOpt: :RailsDefaultUser},
        'rails_env' => {Type: 'String', PassOpt: :RailsEnv},
        'rails_framework_spawner_idle_time' => {Type: 'String', PassOpt: :RailsFrameworkSpawnerIdleTime},
        'rails_ruby' => {Type: 'String', PassOpt: :RailsRuby},
        'rails_spawn_method' => {Type: 'String', PassOpt: :RailsSpawnMethod},
        'rails_user_switching' => {Type: 'String', PassOpt: :RailsUserSwitching},
        'union_station_filter' => {Type: 'QuotedString', PassOpt: :UnionStationFilter},
        'union_station_gateway_address' => {Type: 'URI', PassOpt: :UnionStationGatewayAddress},
        'union_station_gateway_cert' => {Type: 'FullPath', PassOpt: :UnionStationGatewayCert},
        'union_station_gateway_port' => {Type: 'Integer', PassOpt: :UnionStationGatewayPort},
        'union_station_key' => {Type: 'String', PassOpt: :UnionStationKey},
        'union_station_proxy_address' => {Type: 'URI', PassOpt: :UnionStationProxyAddress},
        'union_station_support' => {Type: 'OnOff', PassOpt: :UnionStationSupport},
        'wsgi_auto_detect' => {Type: 'String', PassOpt: :WsgiAutoDetect},
        'rails_autodetect' => {Type: 'OnOff', PassOpt: :RailsAutoDetect},
        'rack_autodetect' => {Type: 'OnOff', PassOpt: :RackAutoDetect},
    }
    passenger_config_options.each do |config_option, config_hash|
      puppetized_config_option = config_option
      valid_config_values = []
      case config_hash[:Type]
        when 'QuotedString'
          valid_config_values = ['"a quoted string"']
          valid_config_values.each do |valid_value|
            describe "with #{puppetized_config_option} => '#{valid_value.gsub(/\"/, '')}'" do
              let :params do
                { puppetized_config_option.to_sym => valid_value }
              end
              it { is_expected.to contain_file('passenger.conf').with_content(/^  #{config_hash[:PassOpt]} "#{valid_value}"$/) }
            end
          end
        when 'FullPath', 'RelPath', 'Path'
          valid_config_values = ['/some/path/to/somewhere']
          valid_config_values.each do |valid_value|
            describe "with #{puppetized_config_option} => #{valid_value}" do
              let :params do
                { puppetized_config_option.to_sym => valid_value }
              end
              it { is_expected.to contain_file('passenger.conf').with_content(/^  #{config_hash[:PassOpt]} "#{valid_value}"$/) }
            end
          end
        when 'URI', 'String'
          valid_config_values = ['some_string_for_you']
          valid_config_values.each do |valid_value|
            describe "with #{puppetized_config_option} => #{valid_value}" do
              let :params do
                { puppetized_config_option.to_sym => valid_value }
              end
              it { is_expected.to contain_file('passenger.conf').with_content(/^  #{config_hash[:PassOpt]} #{valid_value}$/) }
            end
          end
        when 'Integer'
          valid_config_values = [100]
          valid_config_values.each do |valid_value|
            describe "with #{puppetized_config_option} => #{valid_value}" do
              let :params do
                { puppetized_config_option.to_sym => valid_value }
              end
              it { is_expected.to contain_file('passenger.conf').with_content(/^  #{config_hash[:PassOpt]} #{valid_value}$/) }
            end
          end
        when 'OnOff'
          valid_config_values = ['on', 'off']
          valid_config_values.each do |valid_value|
            describe "with #{puppetized_config_option} => '#{valid_value}'" do
              let :params do
                { puppetized_config_option.to_sym => valid_value }
              end
              it { is_expected.to contain_file('passenger.conf').with_content(/^  #{config_hash[:PassOpt]} #{valid_value}$/) }
            end
          end
        else
          valid_config_values = config_hash[:Type]
          valid_config_values.each do |valid_value|
            describe "with #{puppetized_config_option} => '#{valid_value}'" do
              let :params do
                { puppetized_config_option.to_sym => valid_value }
              end
              it { is_expected.to contain_file('passenger.conf').with_content(/^  #{config_hash[:PassOpt]} #{valid_value}$/) }
            end
          end
      end
    end
  end
  context "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :kernel                 => 'Linux',
        :concat_basedir         => '/dne',
        :lsbdistcodename        => 'squeeze',
        :operatingsystem        => 'Debian',
        :id                     => 'root',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :is_pe                  => false,
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod('passenger') }
    it { is_expected.to contain_package("libapache2-mod-passenger") }
    it { is_expected.to contain_file('zpassenger.load').with({
      'path' => '/etc/apache2/mods-available/zpassenger.load',
    }) }
    it { is_expected.to contain_file('passenger.conf').with({
      'path' => '/etc/apache2/mods-available/passenger.conf',
    }) }
     describe "with passenger_root => '/usr/lib/example'" do
      let :params do
        { :passenger_root => '/usr/lib/example' }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerRoot "/usr/lib/example"}) }
    end
    describe "with passenger_ruby => /usr/lib/example/ruby" do
      let :params do
        { :passenger_ruby => '/usr/lib/example/ruby' }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerRuby "/usr/lib/example/ruby"}) }
    end
    describe "with passenger_default_ruby => /usr/lib/example/ruby1.9.3" do
      let :params do
        { :passenger_ruby => '/usr/lib/example/ruby1.9.3' }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerRuby "/usr/lib/example/ruby1.9.3"}) }
    end
    describe "with passenger_high_performance => on" do
      let :params do
        { :passenger_high_performance => 'on' }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(/^  PassengerHighPerformance on$/) }
    end
    describe "with passenger_pool_idle_time => 1200" do
      let :params do
        { :passenger_pool_idle_time => 1200 }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(/^  PassengerPoolIdleTime 1200$/) }
    end
    describe "with passenger_max_request_queue_size => 100" do
      let :params do
        { :passenger_max_request_queue_size => 100 }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(/^  PassengerMaxRequestQueueSize 100$/) }
    end

    describe "with passenger_max_requests => 20" do
      let :params do
        { :passenger_max_requests => 20 }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(/^  PassengerMaxRequests 20$/) }
    end
    describe "with passenger_spawn_method => direct" do
      let :params do
        { :passenger_spawn_method => 'direct' }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(/^  PassengerSpawnMethod direct$/) }
    end
    describe "with passenger_stat_throttle_rate => 10" do
      let :params do
        { :passenger_stat_throttle_rate => 10 }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(/^  PassengerStatThrottleRate 10$/) }
    end
    describe "with passenger_max_pool_size => 16" do
      let :params do
        { :passenger_max_pool_size => 16 }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(/^  PassengerMaxPoolSize 16$/) }
    end
    describe "with passenger_min_instances => 5" do
      let :params do
        { :passenger_min_instances => 5 }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(/^  PassengerMinInstances 5$/) }
    end
    describe "with passenger_max_instances_per_app => 8" do
      let :params do
        { :passenger_max_instances_per_app => 8 }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(/^  PassengerMaxInstancesPerApp 8$/) }
    end
    describe "with rack_autodetect => on" do
      let :params do
        { :rack_autodetect => 'on' }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(/^  RackAutoDetect on$/) }
    end
    describe "with rails_autodetect => on" do
      let :params do
        { :rails_autodetect => 'on' }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(/^  RailsAutoDetect on$/) }
    end
    describe "with passenger_use_global_queue => on" do
      let :params do
        { :passenger_use_global_queue => 'on' }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(/^  PassengerUseGlobalQueue on$/) }
    end
    describe "with passenger_app_env => 'foo'" do
      let :params do
        { :passenger_app_env => 'foo' }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(/^  PassengerAppEnv foo$/) }
    end
    describe "with passenger_instance_registry_dir => '/var/run/passenger-instreg'" do
      let :params do
        { :passenger_instance_registry_dir => '/var/run/passenger-instreg' }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerInstanceRegistryDir "/var/run/passenger-instreg"$}) }
    end
    describe "with passenger_log_file => '/var/log/apache2/passenger.log'" do
      let :params do
        { :passenger_log_file => '/var/log/apache2/passenger.log' }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerLogFile "/var/log/apache2/passenger.log"$}) }
    end
    describe "with passenger_log_level => 3" do
      let :params do
        { :passenger_log_level => 3 }
      end
      it { is_expected.to contain_file('passenger.conf').with_content(%r{^  PassengerLogLevel 3$}) }
    end
    describe "with mod_path => '/usr/lib/foo/mod_foo.so'" do
      let :params do
        { :mod_path => '/usr/lib/foo/mod_foo.so' }
      end
      it { is_expected.to contain_file('zpassenger.load').with_content(/^LoadModule passenger_module \/usr\/lib\/foo\/mod_foo\.so$/) }
    end
    describe "with mod_lib_path => '/usr/lib/foo'" do
      let :params do
        { :mod_lib_path => '/usr/lib/foo' }
      end
      it { is_expected.to contain_file('zpassenger.load').with_content(/^LoadModule passenger_module \/usr\/lib\/foo\/mod_passenger\.so$/) }
    end
    describe "with mod_lib => 'mod_foo.so'" do
      let :params do
        { :mod_lib => 'mod_foo.so' }
      end
      it { is_expected.to contain_file('zpassenger.load').with_content(/^LoadModule passenger_module \/usr\/lib\/apache2\/modules\/mod_foo\.so$/) }
    end
    describe "with mod_id => 'mod_foo'" do
      let :params do
        { :mod_id => 'mod_foo' }
      end
      it { is_expected.to contain_file('zpassenger.load').with_content(/^LoadModule mod_foo \/usr\/lib\/apache2\/modules\/mod_passenger\.so$/) }
    end

    context "with Ubuntu 12.04 defaults" do
      let :facts do
        {
            :osfamily               => 'Debian',
            :operatingsystemrelease => '12.04',
            :kernel                 => 'Linux',
            :operatingsystem        => 'Ubuntu',
            :lsbdistrelease         => '12.04',
            :concat_basedir         => '/dne',
            :id                     => 'root',
            :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
            :is_pe                  => false,
        }
      end

      it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerRoot "/usr"}) }
      it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerRuby "/usr/bin/ruby"}) }
      it { is_expected.to contain_file('passenger.conf').without_content(/PassengerDefaultRuby/) }
    end

    context "with Ubuntu 14.04 defaults" do
      let :facts do
        {
            :osfamily               => 'Debian',
            :operatingsystemrelease => '14.04',
            :operatingsystem        => 'Ubuntu',
            :kernel                 => 'Linux',
            :lsbdistrelease         => '14.04',
            :concat_basedir         => '/dne',
            :id                     => 'root',
            :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
            :is_pe                  => false,
        }
      end

      it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerRoot "/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini"}) }
      it { is_expected.to contain_file('passenger.conf').without_content(/PassengerRuby/) }
      it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerDefaultRuby "/usr/bin/ruby"}) }
    end

    context "with Debian 7 defaults" do
      let :facts do
        {
            :osfamily               => 'Debian',
            :operatingsystemrelease => '7.3',
            :operatingsystem        => 'Debian',
            :kernel                 => 'Linux',
            :lsbdistcodename        => 'wheezy',
            :concat_basedir         => '/dne',
            :id                     => 'root',
            :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
            :is_pe                  => false,
        }
      end

      it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerRoot "/usr"}) }
      it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerRuby "/usr/bin/ruby"}) }
      it { is_expected.to contain_file('passenger.conf').without_content(/PassengerDefaultRuby/) }
    end

    context "with Debian 8 defaults" do
      let :facts do
        {
            :osfamily               => 'Debian',
            :operatingsystemrelease => '8.0',
            :operatingsystem        => 'Debian',
            :kernel                 => 'Linux',
            :lsbdistcodename        => 'jessie',
            :concat_basedir         => '/dne',
            :id                     => 'root',
            :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
            :is_pe                  => false,
        }
      end

      it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerRoot "/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini"}) }
      it { is_expected.to contain_file('passenger.conf').without_content(/PassengerRuby/) }
      it { is_expected.to contain_file('passenger.conf').with_content(%r{PassengerDefaultRuby "/usr/bin/ruby"}) }
    end
  end

  context "on a RedHat OS" do
    let :rh_facts do
      {
          :osfamily               => 'RedHat',
          :concat_basedir         => '/dne',
          :operatingsystem        => 'RedHat',
          :id                     => 'root',
          :kernel                 => 'Linux',
          :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          :is_pe                  => false,
      }
    end

    context "on EL6" do
      let(:facts) { rh_facts.merge(:operatingsystemrelease => '6') }

      it { is_expected.to contain_class("apache::params") }
      it { is_expected.to contain_apache__mod('passenger') }
      it { is_expected.to contain_package("mod_passenger") }
      it { is_expected.to contain_file('passenger_package.conf').with({
                                                                          'path' => '/etc/httpd/conf.d/passenger.conf',
                                                                      }) }
      it { is_expected.to contain_file('passenger_package.conf').without_content }
      it { is_expected.to contain_file('passenger_package.conf').without_source }
      it { is_expected.to contain_file('zpassenger.load').with({
                                                                   'path' => '/etc/httpd/conf.d/zpassenger.load',
                                                               }) }
      it { is_expected.to contain_file('passenger.conf').without_content(/PassengerRoot/) }
      it { is_expected.to contain_file('passenger.conf').without_content(/PassengerRuby/) }
      describe "with passenger_root => '/usr/lib/example'" do
        let :params do
          { :passenger_root => '/usr/lib/example' }
        end
        it { is_expected.to contain_file('passenger.conf').with_content(/^  PassengerRoot "\/usr\/lib\/example"$/) }
      end
      describe "with passenger_ruby => /usr/lib/example/ruby" do
        let :params do
          { :passenger_ruby => '/usr/lib/example/ruby' }
        end
        it { is_expected.to contain_file('passenger.conf').with_content(/^  PassengerRuby "\/usr\/lib\/example\/ruby"$/) }
      end
    end

    context "on EL7" do
      let(:facts) { rh_facts.merge(:operatingsystemrelease => '7') }

      it { is_expected.to contain_file('passenger_package.conf').with({
                                                                          'path' => '/etc/httpd/conf.d/passenger.conf',
                                                                      }) }
      it { is_expected.to contain_file('zpassenger.load').with({
                                                                   'path' => '/etc/httpd/conf.modules.d/zpassenger.load',
                                                               }) }
    end
  end
  context "on a FreeBSD OS" do
    let :facts do
      {
          :osfamily               => 'FreeBSD',
          :operatingsystemrelease => '9',
          :concat_basedir         => '/dne',
          :operatingsystem        => 'FreeBSD',
          :id                     => 'root',
          :kernel                 => 'FreeBSD',
          :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          :is_pe                  => false,
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod('passenger') }
    it { is_expected.to contain_package("www/rubygem-passenger") }
  end
  context "on a Gentoo OS" do
    let :facts do
      {
          :osfamily               => 'Gentoo',
          :operatingsystem        => 'Gentoo',
          :operatingsystemrelease => '3.16.1-gentoo',
          :concat_basedir         => '/dne',
          :id                     => 'root',
          :kernel                 => 'Linux',
          :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin',
          :is_pe                  => false,
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod('passenger') }
    it { is_expected.to contain_package("www-apache/passenger") }
  end
end
