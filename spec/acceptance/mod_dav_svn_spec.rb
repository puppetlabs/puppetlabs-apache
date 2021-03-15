# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'apache::mod::dav_svn class' do
  context 'dav_svn module with authz_svn disabled' do
    pp = <<-MANIFEST
      class { 'apache': }
      class { 'apache::mod::dav_svn':
        authz_svn_enabled => false,
      }
    MANIFEST

    it 'applies with no errors' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'applies a second time without changes' do
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'dav_svn module with authz_svn enabled' do
    pp = <<-MANIFEST
      class { 'apache': }
      class { 'apache::mod::dav_svn':
        authz_svn_enabled => true,
      }
    MANIFEST

    it 'applies with no errors' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'applies a second time without changes' do
      apply_manifest(pp, catch_changes: true)
    end
  end
end
