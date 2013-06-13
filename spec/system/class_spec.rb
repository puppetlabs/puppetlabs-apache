require 'spec_helper_system'

describe 'apache class' do
  let(:distro_commands) {
    YAML.load(File.read(File.dirname(__FILE__) + '/../fixtures/system/distro_commands.yaml'))
  }
  let(:os) {
    node.facts['osfamily']
  }

  it 'should install apache' do
    if distro_commands.has_key?(os)
      shell(distro_commands[os]["package_check"]["command"]) do |r|
        r.stdout.should =~ distro_commands[os]['package_check']['stdout']
        r.exit_code.should == 0
      end
    end
  end

  it 'should start the apache service' do
    if distro_commands.has_key?(os)
      shell(distro_commands[os]["service_check"]["command"]) do |r|
        r.exit_code.should == 0
      end
    end
  end
end
