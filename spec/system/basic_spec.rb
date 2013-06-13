require 'spec_helper_system'

describe 'basic tests:' do
  # Using puppet_apply as a subject
  context puppet_apply 'notice("foo")' do
    its(:stdout) { should =~ /foo/ }
    its(:stderr) { should be_empty }
    its(:exit_code) { should be_zero }
  end

  # Using puppet_apply as a helper
  it 'my class should work with no errors' do
    pp = <<-EOS
      class { 'apache': }
    EOS

    # Run it twice and test for idempotency
    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should be_zero
    end
  end
end

