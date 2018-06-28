require 'spec_helper'

describe 'apache::custom_config', type: :define do
  let :pre_condition do
    'class { "apache": }'
  end
  let :title do
    'rspec'
  end
  let :facts do
    {
      osfamily: 'Debian',
      operatingsystemrelease: '8',
      concat_basedir: '/',
      lsbdistcodename: 'jessie',
      operatingsystem: 'Debian',
      id: 'root',
      kernel: 'Linux',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      is_pe: false,
    }
  end

  context 'defaults with content' do
    let :params do
      {
        'content' => '# Test',
      }
    end

    it {
      is_expected.to contain_exec('syntax verification for rspec').with('refreshonly' => 'true',
                                                                        'subscribe'   => 'File[apache_rspec]',
                                                                        'command'     => '/usr/sbin/apachectl -t',
                                                                        'notify'      => 'Class[Apache::Service]',
                                                                        'before'      => 'Exec[remove rspec if invalid]')
    }
    it {
      is_expected.to contain_exec('remove rspec if invalid').with('unless' => '/usr/sbin/apachectl -t',
                                                                  'subscribe'   => 'File[apache_rspec]',
                                                                  'refreshonly' => 'true')
    }
    it {
      is_expected.to contain_file('apache_rspec').with('ensure' => 'present',
                                                       'content' => '# Test',
                                                       'require' => 'Package[httpd]')
    }
  end
  context 'set everything with source' do
    let :params do
      {
        'confdir'        => '/dne',
        'priority'       => '30',
        'source'         => 'puppet:///modules/apache/test',
        'verify_command' => '/bin/true',
      }
    end

    it {
      is_expected.to contain_exec('syntax verification for rspec').with('command' => '/bin/true')
    }
    it {
      is_expected.to contain_exec('remove rspec if invalid').with('command' => '/bin/rm /dne/30-rspec.conf',
                                                                  'unless' => '/bin/true')
    }
    it {
      is_expected.to contain_file('apache_rspec').with('path' => '/dne/30-rspec.conf',
                                                       'ensure' => 'present',
                                                       'source' => 'puppet:///modules/apache/test',
                                                       'require' => 'Package[httpd]')
    }
  end
  context 'verify_config => false' do
    let :params do
      {
        'content'       => '# test',
        'verify_config' => false,
      }
    end

    it { is_expected.not_to contain_exec('syntax verification for rspec') }
    it { is_expected.not_to contain_exec('remove rspec if invalid') }
    it {
      is_expected.to contain_file('apache_rspec').with('notify' => 'Class[Apache::Service]')
    }
  end
  context 'ensure => absent' do
    let :params do
      {
        'ensure' => 'absent',
      }
    end

    it { is_expected.not_to contain_exec('syntax verification for rspec') }
    it { is_expected.not_to contain_exec('remove rspec if invalid') }
    it {
      is_expected.to contain_file('apache_rspec').with('ensure' => 'absent')
    }
  end
  describe 'validation' do
    context 'both content and source' do
      let :params do
        {
          'content' => 'foo',
          'source'  => 'bar',
        }
      end

      it do
        expect {
          catalogue
        }.to raise_error(Puppet::Error, %r{Only one of \$content and \$source can be specified\.})
      end
    end
    context 'neither content nor source' do
      it do
        expect {
          catalogue
        }.to raise_error(Puppet::Error, %r{One of \$content and \$source must be specified\.})
      end
    end
  end
end
