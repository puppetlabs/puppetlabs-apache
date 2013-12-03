require 'spec_helper_acceptance'

describe 'apache::service class' do
  describe 'adding dependencies in between the base class and service class' do
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'apache': }
      file { '/tmp/test':
        require => Class['apache'],
        notify  => Class['apache::service'],
      }
      EOS

      # Run it twice and test for idempotency
      expect([0,2]).to include (apply_manifest(pp).exit_code)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
  end
end
