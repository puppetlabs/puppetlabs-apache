require 'spec_helper'

describe 'apache::python', :type => :class do

  it { should include_class("apache") }
  it { should include_class("apache::params") }
  it { should contain_package("apache_python_package") }
  it { should contain_a2mod("python").with(
   'ensure'  => 'present'
    )
  }

end
