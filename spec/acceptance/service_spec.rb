require 'spec_helper_acceptance'

describe 'apache::service class' do
  describe 'adding dependencies in between the base class and service class' do
    let(:pp) do
      <<-MANIFEST
        class { 'apache': }
        file { '/tmp/test':
          require => Class['apache'],
          notify  => Class['apache::service'],
        }
      MANIFEST
    end

    it 'behaves idempotently' do
      idempotent_apply(pp)
    end
  end
end
