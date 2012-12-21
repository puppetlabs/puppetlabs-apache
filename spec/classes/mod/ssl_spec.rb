describe 'apache::mod::ssl', :type => :class do
  context 'on an unsupported OS' do
    let :facts do
      {
        :osfamily       => 'Magic',
        :concat_basedir => '/dne',
      }
    end
    it { expect { should raise_error(Puppet::Error, "Unsupported operatingsystem:") } }
  end

  context 'on a RedHat OS' do
    let :facts do
      {
        :osfamily       => 'RedHat',
        :concat_basedir => '/dne',
      }
    end
    it { should include_class('apache::params') }
    it { should contain_apache__mod('ssl') }
    it { should contain_package('mod_ssl') }
  end

  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily       => 'Debian',
        :concat_basedir => '/dne',
      }
    end
    it { should include_class('apache::params') }
    it { should contain_apache__mod('ssl') }
    it { should_not contain_package('libapache2-mod-ssl') }
  end
end
