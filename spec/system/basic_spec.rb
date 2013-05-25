require 'spec_helper_system'

# Here we put the more basic fundamental tests, ultra obvious stuff.
describe "basic tests:" do
  it 'make sure we have copied the module across' do
    # No point diagnosing any more if the module wasn't copied properly
    system_run("ls /etc/puppet/modules/apache") do |r|
      r[:exit_code].should == 0
      r[:stdout].should =~ /Modulefile/
      r[:stderr].should == ''
    end
  end

  it 'my class should work with no errors' do
    pp = <<-EOS
      class { 'apache': }
    EOS

    # Run it once and make sure it doesn't bail with errors
    puppet_apply(pp) do |r|
      r.exit_code.should_not eq(1)
    end

    # Run it again and make sure no changes occurred this time, proving idempotency
    puppet_apply(pp) do |r|
      r.exit_code.should == 0
    end
  end
end
