require 'spec_helper'

describe Facter::Util::Fact do
  before do
    Facter.clear
  end

  describe 'apache_version' do
    context 'with value' do
      before :each do
        Facter::Util::Resolution.stubs(:which).with('apachectl').returns(true)
        Facter::Util::Resolution.stubs(:exec).with('apachectl -v 2>&1').returns('Server version: Apache/2.4.16 (Unix)
                                                                                  Server built:   Jul 31 2015 15:53:26')
      end
      it do
        expect(Facter.fact(:apache_version).value).to eq('2.4.16')
      end
    end
  end

  describe 'apache_version with empty OS' do
    context 'with value' do
      before :each do
        Facter::Util::Resolution.stubs(:which).with('apachectl').returns(true)
        Facter::Util::Resolution.stubs(:exec).with('apachectl -v 2>&1').returns('Server version: Apache/2.4.6 ()
                                                                                  Server built:   Nov 21 2015 05:34:59')
      end
      it do
        expect(Facter.fact(:apache_version).value).to eq('2.4.6')
      end
    end
  end
end
