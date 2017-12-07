require 'spec_helper'

describe 'apache::vhost::php', type: :define do
  let :facts do
    {
      osfamily: 'RedHat',
      operatingsystemrelease: '6',
      concat_basedir: '/dne',
      operatingsystem: 'RedHat',
      id: 'root',
      kernel: 'Linux',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      is_pe: false,
    }
  end
  let :pre_condition do
    'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}'
  end

  context 'With no parameters' do
    let(:title) { 'rspec.example.com' }

    it 'does not include the concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.exmaple.com-php')
    end
  end

  context 'With a php_flags parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { php_flags: { foo: true, bar: false } }
    end

    it 'creates a php_flag entry for each flag with the appropriate value' do
      is_expected.to contain_concat__fragment('rspec.example.com-php')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  php_flag foo on\n})
        .with_content(%r{  php_flag bar off\n})
    end
  end

  context 'With a php_values parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { php_values: { foo: 'bar', baz: 123 } }
    end

    it 'creates a php_value entry for each key with the appropriate value' do
      is_expected.to contain_concat__fragment('rspec.example.com-php')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  php_value foo "bar"\n})
        .with_content(%r{  php_value baz 123\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { php_flags: { foo: true },
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-php-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { php_flags: { foo: true },
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::php { "rspec.example.com": php_values => { bar => baz } }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-php')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-php-test_title')
    end
  end
end
