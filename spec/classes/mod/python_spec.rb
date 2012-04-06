require 'spec_helper'

describe 'apache::mod::python', :type => :class do

  it { should include_class("apache") }

  it { should contain_package("mod_python_package").with(
   'ensure'  => 'installed',
   'require' => 'Package[httpd]'
    )
  }

  it { should contain_a2mod("python").with(
   'ensure'  => 'present'
    )
  }

end
