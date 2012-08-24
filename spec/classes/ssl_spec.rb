require 'spec_helper'

describe 'apache::ssl', :type => :class do
  describe 'when running on redhat' do
    let(:facts) { {:operatingsystem => 'redhat', :osfamily => 'redhat'} }
    it { should include_class('apache::mod::ssl') }
  end
end
