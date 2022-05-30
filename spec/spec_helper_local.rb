# frozen_string_literal: true

if ENV['COVERAGE'] == 'yes'
  require 'simplecov'
  require 'simplecov-console'
  require 'codecov'

  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console,
    SimpleCov::Formatter::Codecov,
  ]
  SimpleCov.start do
    track_files 'lib/**/*.rb'

    add_filter '/spec'

    # do not track vendored files
    add_filter '/vendor'
    add_filter '/.vendor'

    # do not track gitignored files
    # this adds about 4 seconds to the coverage check
    # this could definitely be optimized
    add_filter do |f|
      # system returns true if exit status is 0, which with git-check-ignore means file is ignored
      system("git check-ignore --quiet #{f.filename}")
    end
  end
end

shared_examples :compile, compile: true do
  it { is_expected.to compile.with_all_deps }
end

shared_context 'a mod class, without including apache' do
  let(:facts) { on_supported_os['debian-10-x86_64'] }
end

shared_context 'Debian 11' do
  let(:facts) { on_supported_os['debian-11-x86_64'] }
end

shared_context 'Ubuntu 18.04' do
  let(:facts) { on_supported_os['ubuntu-18.04-x86_64'] }
end

shared_context 'RedHat 6' do
  let(:facts) { on_supported_os['redhat-6-x86_64'] }
end

shared_context 'RedHat 7' do
  let(:facts) { on_supported_os['redhat-7-x86_64'] }
end

shared_context 'RedHat 8' do
  let(:facts) { on_supported_os['redhat-8-x86_64'] }
end

shared_context 'Fedora 28' do
  let :facts do
    {
      kernel: 'Linux',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      os: {
        name: 'Fedora',
        family: 'Redhat',
        release: {
          major: '28',
          full: '28',
        },
      },
      identity: {
        uid: 'root',
      },
    }
  end
end

shared_context 'FreeBSD 9' do
  let :facts do
    {
      kernel: 'FreeBSD',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      os: {
        name: 'FreeBSD',
        family: 'FreeBSD',
        release: {
          full: '9',
        },
      },
      identity: {
        uid: 'root',
      },
    }
  end
end

shared_context 'FreeBSD 10' do
  let :facts do
    {
      kernel: 'FreeBSD',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      os: {
        name: 'FreeBSD',
        family: 'FreeBSD',
        release: {
          full: '10',
        },
      },
      identity: {
        uid: 'root',
      },
    }
  end
end

shared_context 'Gentoo' do
  let :facts do
    {
      kernel: 'Linux',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin',
      os: {
        name: 'Gentoo',
        family: 'Gentoo',
        release: {
          major: '2.7',
          full: '2.7',
        },
      },
      identity: {
        uid: 'root',
      },
    }
  end
end

shared_context 'Darwin' do
  let :facts do
    {
      os: {
        family: 'Darwin',
        release: {
          full: '13.1.0',
        },
      },
    }
  end
end

shared_context 'Unsupported OS' do
  let :facts do
    {
      kernel: 'Linux',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      os: {
        name: 'Magic',
        family: 'Magic',
        release: {
          full: '0',
        },
      },
      identity: {
        uid: 'root',
      },
    }
  end
end

shared_context 'SLES 12' do
  let(:facts) { on_supported_os['sles-12-x86_64'] }
end
