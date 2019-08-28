require 'spec_helper_acceptance'
apache_hash = apache_settings_hash
describe 'apache::custom_config define' do
  context 'invalid config' do
    pp = <<-MANIFEST
        class { 'apache': }
        apache::custom_config { 'acceptance_test':
          content => 'INVALID',
        }
    MANIFEST
    it 'does not add the config' do
      apply_manifest(pp, expect_failures: true)
    end

    describe file("#{apache_hash['confd_dir']}/25-acceptance_test.conf") do
      it { expect(file).not_to exist }
    end
  end

  context 'valid config' do
    pp = <<-MANIFEST
        class { 'apache': }
        apache::custom_config { 'acceptance_test':
          content => '# just a comment',
        }
    MANIFEST
    it 'adds the config' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['confd_dir']}/25-acceptance_test.conf") do
      it { is_expected.to contain '# just a comment' }
    end
  end

  context 'with a custom filename' do
    pp = <<-MANIFEST
        class { 'apache': }
        apache::custom_config { 'filename_test':
          filename => 'custom_filename',
          content  => '# just another comment',
        }
    MANIFEST
    it 'stores content in the described file' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['confd_dir']}/custom_filename") do
      it { is_expected.to contain '# just another comment' }
    end
  end

  describe 'custom_config without priority prefix' do
    pp = <<-MANIFEST
        class { 'apache': }
        apache::custom_config { 'prefix_test':
          priority => false,
          content => '# just a comment',
        }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['confd_dir']}/prefix_test.conf") do
      it { is_expected.to be_file }
    end
  end

  describe 'custom_config only applied after configs are written' do
    pp = <<-MANIFEST
        class { 'apache': }

        apache::custom_config { 'ordering_test':
          content => '# just a comment',
        }

        # Try to wedge the apache::custom_config call between when httpd.conf is written and
        # ports.conf is written. This should trigger a dependency cycle
        File["#{apache_hash['conf_file']}"] -> Apache::Custom_config['ordering_test'] -> Concat["#{apache_hash['ports_file']}"]
    MANIFEST
    it 'applies in the right order' do
      expect(apply_manifest(pp, expect_failures: true).stderr).to match(%r{Found 1 dependency cycle}i)
    end

    describe file("#{apache_hash['confd_dir']}/25-ordering_test.conf") do
      it { is_expected.not_to be_file }
    end
  end
end
