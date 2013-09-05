require 'spec_helper_system'

describe 'apache::mod::itk class' do
  case node.facts['osfamily']
  when 'Debian'
    servicename = 'apache2'
    describe 'running puppet code' do
      # Using puppet_apply as a helper
      it 'should work with no errors' do
        pp = <<-EOS
          class { 'apache':
            mpm_module => 'itk',
          }
        EOS

        # Run it twice and test for idempotency
        puppet_apply(pp) do |r|
          r.exit_code.should_not == 1
          r.refresh
          r.exit_code.should be_zero
        end
      end
    end

    describe service(servicename) do
      it { should be_running }
      it { should be_enabled }
    end
  when 'RedHat'
    # Not implemented yet
  end
end
