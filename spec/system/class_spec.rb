require 'spec_helper_system'

describe 'apache class' do

  it 'should install apache' do
    if system_node.facts['osfamily'] == 'Debian'
      system_run('dpkg --get-selections | grep apache2') do |r|
        r.stdout.should =~ /^apache2\s+install$/
        r.exit_code.should == 0
      end
    elsif system_node.facts['osfamily'] == 'RedHat' or system_node.facts['osfamily'] == 'amazon'
      system_run('rpm -q httpd') do |r|
        r.stdout.should =~ /httpd/
        r.exit_code.should == 0
      end
    end
  end

  it 'should start the apache service' do
    if system_node.facts['osfamily'] == 'Debian'
      system_run('service apache2 status') do |r|
        r.exit_code.should == 0
      end
    elsif system_node.facts['osfamily'] == 'RedHat' or system_node.facts['osfamily'] == 'amazon'
      system_run('service httpd status') do |r|
        r.exit_code.should == 0
      end
    end
  end

end
