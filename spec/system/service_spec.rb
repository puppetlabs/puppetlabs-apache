require 'spec_helper_system'

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
      puppet_apply(pp) do |r|
        [0,2].should include(r.exit_code)
        r.refresh
        r.exit_code.should be_zero
      end
    end
  end
end
