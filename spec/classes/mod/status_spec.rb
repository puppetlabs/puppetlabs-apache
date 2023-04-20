# frozen_string_literal: true

require 'spec_helper'

def require_directives(requires)
  if requires == :undef
    "    Require ip 127.0.0.1 ::1\n"
  elsif requires.is_a?(String)
    if ['', 'unmanaged'].include? requires.downcase
      ''
    else
      "    Require #{requires}\n"
    end
  elsif requires.is_a?(Array)
    requires.map { |req| "    Require #{req}\n" }.join('')
  elsif requires.is_a?(Hash)
    if requires.key?(:enforce)
 \
      "    <Require#{requires[:enforce].capitalize}>\n" + \
        requires[:requires].map { |req| "        Require #{req}\n" }.join('') + \
        "    </Require#{requires[:enforce].capitalize}>\n"
    else
      requires[:requires].map { |req| "    Require #{req}\n" }.join('')
    end
  end
end

shared_examples 'status_conf_spec_require' do |requires, extended_status, status_path|
  expected =
    "<Location #{status_path}>\n    " \
    "SetHandler server-status\n" \
    "#{require_directives(requires)}" \
    "</Location>\n" \
    "ExtendedStatus #{extended_status}\n" \
    "\n" \
    "<IfModule mod_proxy.c>\n    " \
    "# Show Proxy LoadBalancer status in mod_status\n    " \
    "ProxyStatus On\n" \
    "</IfModule>\n"
  it('status conf require') do
    expect(subject).to contain_file('status.conf').with_content(expected)
  end
end

describe 'apache::mod::status', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    context 'on a Debian 11 OS' do
      include_examples 'Debian 11'

      context 'with default params' do
        it { is_expected.to contain_apache__mod('status') }

        include_examples 'status_conf_spec_require', 'ip 127.0.0.1 ::1', 'On', '/server-status'

        it {
          expect(subject).to contain_file('status.conf').with(ensure: 'file',
                                                              path: '/etc/apache2/mods-available/status.conf')
        }

        it {
          expect(subject).to contain_file('status.conf symlink').with(ensure: 'link',
                                                                      path: '/etc/apache2/mods-enabled/status.conf')
        }
      end

      context "with custom parameters $extended_status => 'Off', $status_path => '/custom-status'" do
        let :params do
          {
            extended_status: 'Off',
            status_path: '/custom-status'
          }
        end

        it { is_expected.to compile }

        include_examples 'status_conf_spec_require', 'ip 127.0.0.1 ::1', 'Off', '/custom-status'
      end

      # Only On or Off are valid options
      ['On', 'Off'].each do |valid_param|
        context "with valid value $extended_status => '#{valid_param}'" do
          let :params do
            { extended_status: valid_param }
          end

          it 'expects to succeed regular expression validation' do
            expect(subject).to compile
          end
        end
      end

      ['Yes', 'No'].each do |invalid_param|
        context "with invalid value $extended_status => '#{invalid_param}'" do
          let :params do
            { extended_status: invalid_param }
          end

          it 'expects to fail regular expression validation' do
            expect(subject).to compile.and_raise_error(%r{extended_status})
          end
        end
      end
    end

    context 'on a RedHat 8 OS' do
      include_examples 'RedHat 8'

      context 'with default params' do
        it { is_expected.to contain_apache__mod('status') }

        include_examples 'status_conf_spec_require', 'ip 127.0.0.1 ::1', 'On', '/server-status'

        it { is_expected.to contain_file('status.conf').with_path('/etc/httpd/conf.modules.d/status.conf') }
      end
    end

    valid_requires = {
      undef: :undef,
      empty: '',
      unmanaged: 'unmanaged',
      string: 'ip 127.0.0.1 192.168',
      array: [
        'ip 127.0.0.1',
        'ip ::1',
        'host localhost',
      ],
      hash: {
        requires: [
          'ip 10.1',
          'host somehost',
        ]
      },
      enforce: {
        enforce: 'all',
        requires: [
          'ip 127.0.0.1',
          'host localhost',
        ]
      }
    }
    valid_requires.each do |req_key, req_value|
      context "with default params and #{req_key} requires" do
        let :params do
          {
            requires: req_value
          }
        end

        context 'on a Debian 11 OS' do
          include_examples 'Debian 11'

          it { is_expected.to contain_apache__mod('status') }

          include_examples 'status_conf_spec_require', req_value, 'On', '/server-status'

          it {
            expect(subject).to contain_file('status.conf').with(ensure: 'file',
                                                                path: '/etc/apache2/mods-available/status.conf')
          }

          it {
            expect(subject).to contain_file('status.conf symlink').with(ensure: 'link',
                                                                        path: '/etc/apache2/mods-enabled/status.conf')
          }
        end

        context 'on a RedHat 7 OS' do
          include_examples 'RedHat 7'

          it { is_expected.to contain_apache__mod('status') }

          include_examples 'status_conf_spec_require', req_value, 'On', '/server-status'

          it { is_expected.to contain_file('status.conf').with_path('/etc/httpd/conf.modules.d/status.conf') }
        end

        context 'on a RedHat 8 OS' do
          include_examples 'RedHat 8'

          it { is_expected.to contain_apache__mod('status') }

          include_examples 'status_conf_spec_require', req_value, 'On', '/server-status'

          it { is_expected.to contain_file('status.conf').with_path('/etc/httpd/conf.modules.d/status.conf') }
        end
      end
    end
  end
end
