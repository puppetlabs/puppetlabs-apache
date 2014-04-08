require 'spec_helper_acceptance'

describe 'apache::dotconf define', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  context 'ensure absent' do
    it 'should remove config file' do
      pp = <<-EOS
        class { 'apache': }
        apache::dotconf {'test':
          ensure => 'absent'
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
    end

    describe file("#{$confd_dir}/test.conf") do
      it { should_not be_file }
    end
  end
end
