# This function is called inside the OS specific contexts
def general_info_specs
  it { should contain_apache__mod("info") }

  it do
    should contain_file("info.conf").with_content(
      "<Location /server-info>\n"\
      "    SetHandler server-info\n"\
      "    Order deny,allow\n"\
      "    Deny from all\n"\
      "    Allow from 127.0.0.1 ::1\n"\
      "</Location>\n"
    )
  end
end

describe 'apache::mod::info', :type => :class do
  let :pre_condition do
    'include apache'
  end

  context "On a Debian OS with default params" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end

    # Load the more generic tests for this context
    general_info_specs()

    it { should contain_file("info.conf").with({
      :ensure => 'file',
      :path   => '/etc/apache2/mods-available/info.conf',
    } ) }
    it { should contain_file("info.conf symlink").with({
      :ensure => 'link',
      :path   => '/etc/apache2/mods-enabled/info.conf',
    } ) }
  end

  context "on a RedHat OS with default params" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end

    # Load the more generic tests for this context
    general_info_specs()

    it { should contain_file("info.conf").with_path("/etc/httpd/conf.d/info.conf") }
  end

  context "with $allow_from => ['10.10.10.10','11.11.11.11']" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    let :params do
      { :allow_from => ['10.10.10.10','11.11.11.11'] }
    end
    it do
      should contain_file("info.conf").with_content(
        "<Location /server-info>\n"\
        "    SetHandler server-info\n"\
        "    Order deny,allow\n"\
        "    Deny from all\n"\
        "    Allow from 10.10.10.10 11.11.11.11\n"\
        "</Location>\n"
      )
    end
  end
end
