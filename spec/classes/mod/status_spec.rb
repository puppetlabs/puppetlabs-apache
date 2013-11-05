require 'spec_helper'

describe 'apache::mod::status', :type => :class do
  let :pre_condition do
    'include apache'
  end

  let :facts do
    {
      :osfamily               => 'RedHat',
      :operatingsystemrelease => '6',
      :concat_basedir         => '/dne',
    }
  end

  it { should contain_apache__mod('status') }

  context 'default' do
    it { should contain_file('status.conf').with_content(/Allow from 127\.0\.0\.1 ::1/) }
  end

  context 'custom allow_from (string)' do
    let :params do
      {
        :allow_from => '1.2.3.4'
      }
    end
    it { should contain_file('status.conf').with_content(/Allow from 1\.2\.3\.4/) }
  end

  context 'custom allow_from (array)' do
    let :params do
      {
        :allow_from => [ '1.2.3.4', '2.3.4.5' ]
      }
    end
    it { should contain_file('status.conf').with_content(/Allow from 1\.2\.3\.4 2\.3\.4\.5/) }
  end

end
