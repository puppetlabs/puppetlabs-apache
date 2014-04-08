require 'spec_helper'

describe 'apache::mod', :type => :define do
  let :title do
    'spec_dot'
  end

  let :pre_condition do
    'include apache'
  end

  describe 'os-independent items' do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystemrelease => '12.04',
        :concat_basedir         => '/dne',
      }
    end

    let :params do
      {
        :ensure => 'present',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644',
      }
    end

    it do
      should contain_file('apache_dotconf_spec_dot.conf').with(
        :ensure => 'present',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644'
      )
    end

    context 'without path param' do
      let :params do
        {
          :path => ''
        }
      end
      it do
        should contain_file('apache_dotconf_spec_dot.conf').with_path('/etc/apache2/conf.d/spec_dot.conf')
      end
    end

    context 'with path param' do
      let :params do
        {
          :path => ''
        }
      end
      it do
        should contain_file('apache_dotconf_spec_dot.conf').with_path('/etc/apache2/other_path/spec_dot.conf')
      end
    end

    context 'with source and content params' do
      let :params  do
        {
          :source  => 'somesource',
          :content => 'somecontent',
        }
      end
      it 'should cause a failure' do
        expect {
          contain_file('apache_dotconf_spec.dot.conf')
        }.to raise_error(Puppet::Error, /You cannot specify more than one of content, source, target/)
      end
    end

    context 'with source and template params' do
      let :params do
        {
          :source   => 'somesource',
          :template => 'somecontent',
        }
      end
      it 'should cause a failure' do
        expect {
          contain_file('apache_dotconf_spec.dot.conf')
        }.to raise_error(Puppet::Error, /You cannot specify more than one of content, source, target/)
      end
    end

    context 'with content and template params' do
      let :params do
        {
          :content  => 'somecontent',
          :template => 'sometemplate',
        }
      end
      it 'should prioritize content' do
        should contain_file('apache_dotconf_spec_dot.conf').with_content('somecontent')
      end
    end

    context 'with source param' do
      let :params do
        {
          :source => 'somesource'
        }
      end
      it do
        should contain_file('apache_dotconf_spec_dot.conf').with_source('somesource')
      end
    end

    context 'with content param' do
      let :params do
        {
          :content => 'somecontent'
        }
      end
      it do
        should contain_file('apache_dotconf_spec_dot.conf').with_content('somecontent')
      end
    end
  end
end
