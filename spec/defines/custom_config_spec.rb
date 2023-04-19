# frozen_string_literal: true

require 'spec_helper'

describe 'apache::custom_config', type: :define do
  let :pre_condition do
    'class { "apache": }'
  end
  let :title do
    'rspec'
  end

  include_examples 'Debian 11'

  context 'defaults with content' do
    let :params do
      {
        'content' => '# Test',
      }
    end

    it {
      is_expected.to contain_exec('syntax verification for rspec')
        .with('refreshonly' => 'true', 'command' => ['/usr/sbin/apachectl', '-t'])
        .that_subscribes_to('File[apache_rspec]')
        .that_notifies('Class[Apache::Service]')
        .that_comes_before('Exec[remove rspec if invalid]')
    }
    it {
      is_expected.to contain_exec('remove rspec if invalid')
        .with('unless' => [['/usr/sbin/apachectl', '-t']], 'refreshonly' => 'true')
        .that_subscribes_to('File[apache_rspec]')
    }
    it {
      is_expected.to contain_file('apache_rspec')
        .with('ensure' => 'present', 'content' => '# Test')
        .that_requires('Package[httpd]')
    }
  end
  context 'set everything with source' do
    let :params do
      {
        'confdir' => '/dne',
        'priority' => 30,
        'source' => 'puppet:///modules/apache/test',
        'verify_command' => ['/bin/true'],
      }
    end

    it {
      is_expected.to contain_exec('syntax verification for rspec').with('command' => ['/bin/true'])
    }
    it {
      is_expected.to contain_exec('remove rspec if invalid').with('command' => ['/bin/rm', '/dne/30-rspec.conf'],
                                                                  'unless' => [['/bin/true']])
    }
    it {
      is_expected.to contain_file('apache_rspec')
        .that_requires('Package[httpd]')
        .with('path' => '/dne/30-rspec.conf',
              'ensure' => 'present',
              'source' => 'puppet:///modules/apache/test')
    }
  end
  context 'verify_config => false' do
    let :params do
      {
        'content' => '# test',
        'verify_config' => false,
      }
    end

    it { is_expected.not_to contain_exec('syntax verification for rspec') }
    it { is_expected.not_to contain_exec('remove rspec if invalid') }
    it { is_expected.to contain_file('apache_rspec').that_notifies('Class[Apache::Service]') }
  end
  context 'ensure => absent' do
    let :params do
      {
        'ensure' => 'absent',
      }
    end

    it { is_expected.not_to contain_exec('syntax verification for rspec') }
    it { is_expected.not_to contain_exec('remove rspec if invalid') }
    it { is_expected.to contain_file('apache_rspec').with('ensure' => 'absent') }
  end
  describe 'validation' do
    context 'both content and source' do
      let :params do
        {
          'content' => 'foo',
          'source' => 'bar',
        }
      end

      it { is_expected.to compile.and_raise_error(%r{Only one of \$content and \$source can be specified\.}) }
    end

    context 'neither content nor source' do
      it { is_expected.to compile.and_raise_error(%r{One of \$content and \$source must be specified\.}) }
    end
  end
end
