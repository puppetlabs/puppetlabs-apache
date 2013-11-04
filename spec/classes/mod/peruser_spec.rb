describe 'apache::mod::peruser', :type => :class do
  let :pre_condition do
    'class { "apache": mpm_module => false, }'
  end
  # TBD
end
