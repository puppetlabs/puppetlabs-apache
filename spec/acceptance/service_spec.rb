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
      execute_manifest(pp, :catch_failures => true)
      expect(execute_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
  end
end
