# run a test task
require 'spec_helper_acceptance'

describe 'apache tasks', if: puppet_version =~ %r{(5\.\d+\.\d+)} && host_inventory['facter']['os']['name'] != 'sles' do
  describe 'reload' do
    pp = <<-MANIFEST
      class { 'apache':
        default_vhost => false,
      }
      apache::listen { '9090':}
    MANIFEST
    it 'execute reload' do
      apply_manifest(pp, catch_failures: true)

      result = run_task(task_name: 'apache', params: 'action=reload')
      expect_multiple_regexes(result: result, regexes: [%r{reload successful}, %r{Job completed. 1/1 nodes succeeded|Ran on 1 node}])
    end
  end
end
