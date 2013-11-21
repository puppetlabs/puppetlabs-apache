require 'spec_helper_acceptance'

describe 'basic tests:' do
  pp = 'notice("foo")'
  it { expect(apply_manifest(pp).exit_code).to eq(0) }
end

describe 'disable selinux:' do
  pp = <<-EOS
  exec { "setenforce 0":
    path   => "/bin:/sbin:/usr/bin:/usr/sbin",
    onlyif => "which setenforce && getenforce | grep Enforcing",
  }
  EOS
  it { expect(apply_manifest(pp).exit_code).to eq(0) }
end
