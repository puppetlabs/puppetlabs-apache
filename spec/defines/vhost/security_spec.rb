require 'spec_helper'

describe 'apache::vhost::security', type: :define do
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
    'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled", logroot => "/logroot" }'
  end

  context 'With no parameters' do
    let(:title) { 'rspec.example.com' }

    it 'does not create the concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-security')
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { modsec_audit_log: true,
        vhost: 'rspec.example.com' }
    end

    it 'creates the same concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { modsec_audit_log: true,
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::security { "rspec.example.com": modsec_disable_vhost => true }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end

  context 'with modsec_audit_log enabled but no other audit parameters' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { modsec_audit_log: true }
    end

    it 'sets the SecAuditLog to /logroot/rspec.example.com_security.log' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_content(%r{SecAuditLog "/logroot/rspec\.example\.com_security\.log"})
    end
  end

  context 'with modsec_audit_log enabled in an ssl vhost but no other audit parameters' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { modsec_audit_log: true,
        ssl: true }
    end

    it 'sets the SecAuditLog to /logroot/rspec.example.com_security_ssl.log' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_content(%r{SecAuditLog "/logroot/rspec\.example\.com_security_ssl\.log"})
    end
  end

  context 'with modsec_audit_log enabled and modsec_audit_log_file specified' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { modsec_audit_log: true,
        modsec_audit_log_file: 'filename' }
    end

    it 'sets the SecAuditLog to the log filename in the logroot' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_content(%r{SecAuditLog "/logroot/filename"})
    end
  end

  context 'with modsec_audit_log enabled and modsec_audit_log_pipe specified' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { modsec_audit_log: true,
        modsec_audit_log_pipe: 'pipename' }
    end

    it 'sets the SecAuditLog to the pipe filename' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_content(%r{SecAuditLog "pipename"})
    end
  end

  context 'with modsec_disable_vhost set to true' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { modsec_disable_vhost: true }
    end

    it 'disables the security rule engine' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_content(%r{SecRuleEngine Off})
    end
  end

  context 'with a string for modsec_disable_ips' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { modsec_disable_ips: 'ipaddr' }
    end

    it 'creates the correct security rule' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_content(%r{SecRule REMOTE_ADDR "ipaddr"})
    end
  end

  context 'with an array for modsec_disable_ips' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { modsec_disable_ips: %w[ip1 ip2] }
    end

    it 'creates the correct security rule' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_content(%r{SecRule REMOTE_ADDR "ip1,ip2"})
    end
  end

  context 'with an empty array for modsec_disable_ips' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { modsec_disable_ips: [] }
    end

    it 'does not create a REMOTE_ADDR security rule' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .without_content(%r{SecRule REMOTE_ADDR})
    end
  end

  context 'with a hash for modsec_disable_ids' do
    let(:title) { 'rspec.example.com' }
    let :params do
      {
        modsec_disable_ids: {
          loc1: 'id1',
          loc2: %w[id2a id2b],
        },
      }
    end

    it 'creates the correct LocationMatch and SecRuleRemoveById tags' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_content(%r{<LocationMatch loc1>[^<]*SecRuleRemoveById id1[^<]*</LocationMatch>})
        .with_content(%r{<LocationMatch loc2>[^<]*SecRuleRemoveById id2a[^<]*SecRuleRemoveById id2b[^<]*</LocationMatch>})
    end
  end

  context 'with an array for modsec_disable_ids' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { modsec_disable_ids: %w[id3 id4] }
    end

    it 'creates the correct LocationMatch and SecRuleRemoveById tags' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_content(%r{<LocationMatch \.\*>[^<]*SecRuleRemoveById id3[^<]*SecRuleRemoveById id4[^<]*</LocationMatch>})
    end
  end

  context 'with a hash for modsec_disable_msgs' do
    let(:title) { 'rspec.example.com' }
    let :params do
      {
        modsec_disable_msgs: {
          loc1: 'msg1',
          loc2: %w[msg2a msg2b],
        },
      }
    end

    it 'creates the correct LocationMatch and SecRuleRemoveByMsg tags' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_content(%r{<LocationMatch loc1>[^<]*SecRuleRemoveByMsg "msg1"[^<]*</LocationMatch>})
        .with_content(%r{<LocationMatch loc2>[^<]*SecRuleRemoveByMsg "msg2a"[^<]*SecRuleRemoveByMsg "msg2b"[^<]*</LocationMatch>})
    end
  end

  context 'with an array for modsec_disable_msgs' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { modsec_disable_msgs: %w[msg3 msg4] }
    end

    it 'creates the correct LocationMatch and SecRuleRemoveByMsg tags' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_content(%r{<LocationMatch \.\*>[^<]*SecRuleRemoveByMsg "msg3"[^<]*SecRuleRemoveByMsg "msg4"[^<]*</LocationMatch>})
    end
  end

  context 'with a hash for modsec_disable_tags' do
    let(:title) { 'rspec.example.com' }
    let :params do
      {
        modsec_disable_tags: {
          loc1: 'tag1',
          loc2: %w[tag2a tag2b],
        },
      }
    end

    it 'creates the correct LocationMatch and SecRuleRemoveByTag tags' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_content(%r{<LocationMatch loc1>[^<]*SecRuleRemoveByTag "tag1"[^<]*</LocationMatch>})
        .with_content(%r{<LocationMatch loc2>[^<]*SecRuleRemoveByTag "tag2a"[^<]*SecRuleRemoveByTag "tag2b"[^<]*</LocationMatch>})
    end
  end

  context 'with an array for modsec_disable_tags' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { modsec_disable_tags: %w[tag3 tag4] }
    end

    it 'creates the correct LocationMatch and SecRuleRemoveByTag tags' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_content(%r{<LocationMatch \.\*>[^<]*SecRuleRemoveByTag "tag3"[^<]*SecRuleRemoveByTag "tag4"[^<]*</LocationMatch>})
    end
  end

  context 'with modsec_body_limit' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { modsec_body_limit: 1234 }
    end

    it 'creates the SecRequestBodyLimit tag' do
      is_expected.to contain_concat__fragment('rspec.example.com-security')
        .with_content(%r{SecRequestBodyLimit 1234})
    end
  end
end
