# frozen_string_literal: true

require 'spec_helper'

# This function is called inside the OS specific conte, :compilexts
def general_mime_specs
  it { is_expected.to contain_apache__mod('mime') }

  it do
    expect(subject).to contain_file('mime.conf').with_content(%r{AddHandler type-map var})
    expect(subject).to contain_file('mime.conf').with_content(%r{ddOutputFilter INCLUDES .shtml})
    expect(subject).to contain_file('mime.conf').with_content(%r{AddType text/html .shtml})
    expect(subject).to contain_file('mime.conf').with_content(%r{AddType application/x-compress .Z})
  end
end

describe 'apache::mod::mime', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'On a Debian OS with default params', :compile do
    include_examples 'Debian 11'

    general_mime_specs

    it { is_expected.to contain_file('mime.conf').with_path('/etc/apache2/mods-available/mime.conf') }
  end

  context 'on a RedHat OS with default params', :compile do
    include_examples 'RedHat 8'

    general_mime_specs

    it { is_expected.to contain_file('mime.conf').with_path('/etc/httpd/conf.modules.d/mime.conf') }
  end
end
