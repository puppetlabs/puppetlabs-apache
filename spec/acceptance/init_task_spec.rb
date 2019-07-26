require 'spec_helper_acceptance'

describe 'apache tasks' do
  describe 'reload' do
    pp = <<-MANIFEST
      class { 'apache':
        default_vhost => false,
      }
      apache::listen { '9090':}
    MANIFEST
    it 'execute reload' do
      apply_manifest(pp, catch_failures: true)

      result = run_bolt_task('apache', 'action' => 'reload')
      expect(result.stdout).to contain(%(reload successful))
    end
  end
end
