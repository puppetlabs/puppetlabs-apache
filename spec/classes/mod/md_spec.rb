require 'spec_helper'

describe 'apache::mod::md', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      if facts[:os]['family'] == 'Debian'
        context 'validating all md params - using Debian' do
          md_options = {
            'md_activation_delay' => { type: 'Duration', pass_opt: 'MDActivationDelay' },
            'md_base_server' => { type: 'OnOff', pass_opt: 'MDBaseServer' },
            'md_ca_challenges' => { type: 'CAChallenges', pass_opt: 'MDCAChallenges' },
            'md_certificate_agreement' => { type: 'MDCertificateAgreement', pass_opt: 'MDCertificateAgreement' },
            'md_certificate_authority' => { type: 'URL', pass_opt: 'MDCertificateAuthority' },
            'md_certificate_check' => { type: 'String', pass_opt: 'MDCertificateCheck' },
            'md_certificate_monitor' => { type: 'URL', pass_opt: 'MDCertificateMonitor' },
            'md_certificate_protocol' => { type: 'MDCertificateProtocol', pass_opt: 'MDCertificateProtocol' },
            'md_certificate_status' => { type: 'OnOff', pass_opt: 'MDCertificateStatus' },
            'md_challenge_dns01' => { type: 'Path', pass_opt: 'MDChallengeDns01' },
            'md_contact_email' => { type: 'EMail', pass_opt: 'MDContactEmail' },
            'md_http_proxy' => { type: 'URL', pass_opt: 'MDHttpProxy' },
            'md_members' => { type: 'MDMembers', pass_opt: 'MDMembers' },
            'md_message_cmd' => { type: 'Path', pass_opt: 'MDMessageCmd' },
            'md_must_staple' => { type: 'OnOff', pass_opt: 'MDMustStaple' },
            'md_notify_cmd' => { type: 'Path', pass_opt: 'MDNotifyCmd' },
            'md_port_map' => { type: 'String', pass_opt: 'MDPortMap' },
            'md_private_keys' => { type: 'String', pass_opt: 'MDPrivateKeys' },
            'md_renew_mode' => { type: 'MDRenewMode', pass_opt: 'MDRenewMode' },
            'md_renew_window' => { type: 'Duration', pass_opt: 'MDRenewWindow' },
            'md_require_https' => { type: 'MDRequireHttps', pass_opt: 'MDRequireHttps' },
            'md_server_status' => { type: 'OnOff', pass_opt: 'MDServerStatus' },
            'md_staple_others' => { type: 'OnOff', pass_opt: 'MDStapleOthers' },
            'md_stapling' => { type: 'OnOff', pass_opt: 'MDStapling' },
            'md_stapling_keep_response' => { type: 'Duration', pass_opt: 'MDStaplingKeepResponse' },
            'md_stapling_renew_window' => { type: 'Duration', pass_opt: 'MDStaplingRenewWindow' },
            'md_store_dir' => { type: 'Path', pass_opt: 'MDStoreDir' },
            'md_warn_window' => { type: 'Duration', pass_opt: 'MDWarnWindow' },
          }

          md_options.each do |config_option, config_hash|
            puppetized_config_option = config_option
            case config_hash[:type]
            when 'CAChallenges'
              valid_config_values = [['dns-01'], ['tls-alpn-01', 'http-01']]
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => #{valid_value}" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('md.conf').with_content(%r{^#{config_hash[:pass_opt]} #{valid_value.join(' ')}}) }
                end
              end
            when 'EMail'
              valid_config_values = ['root@example.com']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => #{valid_value}" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('md.conf').with_content(%r{^#{config_hash[:pass_opt]} #{valid_value}$}) }
                end
              end
            when 'Duration'
              valid_config_values = ['7d', '33%']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => '#{valid_value}'" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('md.conf').with_content(%r{^#{config_hash[:pass_opt]} #{valid_value}$}) }
                end
              end
            when 'MDCertificateAgreement'
              valid_config_values = ['accepted']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => '#{valid_value}'" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('md.conf').with_content(%r{^#{config_hash[:pass_opt]} #{valid_value}$}) }
                end
              end
            when 'MDCertificateProtocol'
              valid_config_values = ['ACME']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => '#{valid_value}'" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('md.conf').with_content(%r{^#{config_hash[:pass_opt]} #{valid_value}$}) }
                end
              end
            when 'MDMembers'
              valid_config_values = ['auto', 'manual']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => '#{valid_value}'" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('md.conf').with_content(%r{^#{config_hash[:pass_opt]} #{valid_value}$}) }
                end
              end
            when 'MDRenewMode'
              valid_config_values = ['always', 'auto', 'manual']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => '#{valid_value}'" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('md.conf').with_content(%r{^#{config_hash[:pass_opt]} #{valid_value}$}) }
                end
              end
            when 'MDRequireHttps'
              valid_config_values = ['off', 'temporary', 'permanent']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => '#{valid_value}'" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('md.conf').with_content(%r{^#{config_hash[:pass_opt]} #{valid_value}$}) }
                end
              end
            when 'OnOff'
              valid_config_values = ['on', 'off']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => '#{valid_value}'" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('md.conf').with_content(%r{^#{config_hash[:pass_opt]} #{valid_value}$}) }
                end
              end
            when 'Path'
              valid_config_values = ['/some/path/to/somewhere']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => #{valid_value}" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('md.conf').with_content(%r{^#{config_hash[:pass_opt]} "#{valid_value}"$}) }
                end
              end
            when 'String'
              valid_config_values = ['a random string']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => '#{valid_value}'" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('md.conf').with_content(%r{^#{config_hash[:pass_opt]} #{valid_value}$}) }
                end
              end
            when 'URL'
              valid_config_values = ['https://example.com/example']
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => '#{valid_value}'" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('md.conf').with_content(%r{^#{config_hash[:pass_opt]} #{valid_value}$}) }
                end
              end
            else
              valid_config_values = config_hash[:type]
              valid_config_values.each do |valid_value|
                describe "with #{puppetized_config_option} => '#{valid_value}'" do
                  let :params do
                    { puppetized_config_option.to_sym => valid_value }
                  end

                  it { is_expected.to contain_file('md.conf').with_content(%r{^#{config_hash[:pass_opt]} #{valid_value}$}) }
                end
              end
            end
          end
        end
      end

      it { is_expected.to contain_class('apache::mod::watchdog') }
      it { is_expected.to contain_apache__mod('md') }
      it { is_expected.to contain_file('md.conf') }
    end
  end
end
