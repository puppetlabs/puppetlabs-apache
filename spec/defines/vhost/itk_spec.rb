require 'spec_helper'

describe 'apache::vhost::itk', type: :define do
  let :facts do
    {
      osfamily: 'RedHat',
      operatingsystemrelease: '6',
      concat_basedir: '/dne',
      operatingsystem: 'RedHat',
      id: 'root',
      kernel: 'Linux',
      kernelversion: '2.6.32',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      is_pe: false,
    }
  end
  let :pre_condition do
    'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}'
  end

  context 'With no parameters' do
    let(:title) { 'rspec.example.com' }

    it 'fails to compile' do
      is_expected.to compile.and_raise_error(%r{expects a value for parameter})
    end
  end

  context 'With an itk parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { itk: { foo: 'bar' } }
    end

    it 'creates an <IfModule mpm_itk_module> entry' do
      is_expected.to contain_concat__fragment('rspec.example.com-itk')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  <IfModule mpm_itk_module>\n})
    end
  end

  context 'With itk["user"] and itk["group"] defined' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { itk: { user: 'foo', group: 'bar' } }
    end

    it 'creates an AssignUserId entry' do
      is_expected.to contain_concat__fragment('rspec.example.com-itk')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  AssignUserId foo bar\n})
    end
  end

  context 'With itk["assignuseridexpr"] defined' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { itk: { assignuseridexpr: 'foo' } }
    end

    it 'creates an AssignUserIdExpr entry' do
      is_expected.to contain_concat__fragment('rspec.example.com-itk')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  AssignUserIdExpr foo\n})
    end
  end

  context 'With itk["assigngroupidexpr"] defined' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { itk: { assigngroupidexpr: 'foo' } }
    end

    it 'creates an AssignGroupIdExpr entry' do
      is_expected.to contain_concat__fragment('rspec.example.com-itk')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  AssignGroupIdExpr foo\n})
    end
  end

  context 'With itk["maxclientvhost"] defined' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { itk: { maxclientvhost: 'foo' } }
    end

    it 'creates a MaxClientsVHost entry' do
      is_expected.to contain_concat__fragment('rspec.example.com-itk')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  MaxClientsVHost foo\n})
    end
  end

  context 'With itk["nice"] defined' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { itk: { nice: 'foo' } }
    end

    it 'creates a NiceValue entry' do
      is_expected.to contain_concat__fragment('rspec.example.com-itk')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  NiceValue foo\n})
    end
  end

  context 'With itk["limituidrange"] defined on an older kernel' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { itk: { limituidrange: 'foo' } }
    end

    it 'does not create a LimitUIDRange entry' do
      is_expected.to contain_concat__fragment('rspec.example.com-itk')
        .with_target('apache::vhost::rspec.example.com')
        .without_content(%r{  LimitUIDRange foo\n})
    end
  end

  context 'With itk["limitgidrange"] defined on an older kernel' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { itk: { limitgidrange: 'foo' } }
    end

    it 'does not create a LimitGIDRange entry' do
      is_expected.to contain_concat__fragment('rspec.example.com-itk')
        .with_target('apache::vhost::rspec.example.com')
        .without_content(%r{  LimitGIDRange foo\n})
    end
  end

  context 'With itk["limituidrange"] defined on a newer kernel' do
    let(:title) { 'rspec.example.com' }
    let :facts do
      super().merge(
        kernelversion: '3.5.0',
      )
    end
    let :params do
      { itk: { limituidrange: 'foo' } }
    end

    it 'creates a LimitUIDRange entry' do
      is_expected.to contain_concat__fragment('rspec.example.com-itk')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  LimitUIDRange foo\n})
    end
  end

  context 'With itk["limitgidrange"] defined on a newer kernel' do
    let(:title) { 'rspec.example.com' }
    let :facts do
      super().merge(
        kernelversion: '3.5.0',
      )
    end
    let :params do
      { itk: { limitgidrange: 'foo' } }
    end

    it 'creates a LimitGIDRange entry' do
      is_expected.to contain_concat__fragment('rspec.example.com-itk')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  LimitGIDRange foo\n})
    end
  end

  context 'With an invalid itk parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { itk: 'foo' }
    end

    it 'fails' do
      is_expected.to compile.and_raise_error(%r{expects a Hash})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { itk: { foo: 'bar' },
        vhost: 'rspec.example.com' }
    end

    it 'creates the same concat' do
      is_expected.to contain_concat__fragment('rspec.example.com-itk')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { itk: { foo: 'bar' },
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::itk { "rspec.example.com": itk => { "baz" => "quux" } }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
