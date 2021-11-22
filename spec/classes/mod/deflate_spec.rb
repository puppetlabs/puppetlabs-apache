# frozen_string_literal: true

require 'spec_helper'

# This function is called inside the OS specific contexts
def general_deflate_specs
  it { is_expected.to contain_apache__mod('deflate') }

  expected = "AddOutputFilterByType DEFLATE application/rss+xml\n"\
  "AddOutputFilterByType DEFLATE application/x-javascript\n"\
      "AddOutputFilterByType DEFLATE text/css\n"\
             "AddOutputFilterByType DEFLATE text/html\n"\
             "\n"\
             "DeflateFilterNote Input instream\n"\
             "DeflateFilterNote Output outstream\n"\
             "DeflateFilterNote Ratio ratio\n"

  it do
    is_expected.to contain_file('deflate.conf').with_content(expected)
  end
end

describe 'apache::mod::deflate', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    let :pre_condition do
      'class { "apache::mod::deflate":
        types => [ "text/html", "text/css" , "application/x-javascript", "application/rss+xml"],
        notes => {
          "Input" => "instream",
          "Ratio" => "ratio",
          "Output" => "outstream",
        }
      }
      '
    end

    context 'On a Debian OS with default params' do
      include_examples 'Debian 11'

      # Load the more generic tests for this context
      general_deflate_specs

      it {
        is_expected.to contain_file('deflate.conf').with(ensure: 'file',
                                                         path: '/etc/apache2/mods-available/deflate.conf')
      }
      it {
        is_expected.to contain_file('deflate.conf symlink').with(ensure: 'link',
                                                                 path: '/etc/apache2/mods-enabled/deflate.conf')
      }
    end

    context 'on a RedHat OS with default params' do
      include_examples 'RedHat 6'

      # Load the more generic tests for this context
      general_deflate_specs

      it { is_expected.to contain_file('deflate.conf').with_path('/etc/httpd/conf.d/deflate.conf') }
    end

    context 'On a FreeBSD OS with default params' do
      include_examples 'FreeBSD 9'

      # Load the more generic tests for this context
      general_deflate_specs

      it {
        is_expected.to contain_file('deflate.conf').with(ensure: 'file',
                                                         path: '/usr/local/etc/apache24/Modules/deflate.conf')
      }
    end

    context 'On a Gentoo OS with default params' do
      include_examples 'Gentoo'

      # Load the more generic tests for this context
      general_deflate_specs

      it {
        is_expected.to contain_file('deflate.conf').with(ensure: 'file',
                                                         path: '/etc/apache2/modules.d/deflate.conf')
      }
    end
  end
end
