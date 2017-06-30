require 'spec_helper'

describe 'apache::mod::jk', :type => :class do
  it_behaves_like 'a mod class, without including apache'

  it { is_expected.to compile }
  it { is_expected.to create_class('apache::mod::jk') }
  it { is_expected.to contain_class('apache') }
  it { is_expected.to contain_apache__mod('jk') }
  it { is_expected.to contain_file('jk.conf').that_notifies('Class[apache::service]').with(
    :ensure  => file,
    :content => /<IfModule jk_module>/,
    :content => /<\/IfModule>/,
  )}

end
