require 'spec_helper'

describe 'apache::vhost::fragment' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'myfragment' }

      context 'adding to the default vhost' do
        let(:pre_condition) { 'include apache' }

        let(:params) do
          {
            vhost: 'default',
            priority: '15',
          }
        end

        context 'with content' do
          let(:params) { super().merge(content: '# Foo') }

          it 'creates a vhost concat fragment' do
            is_expected.to compile.with_all_deps
            is_expected.to contain_concat('15-default.conf')
            is_expected.to create_concat__fragment('default-myfragment')
              .with_target('15-default.conf')
              .with_order(900)
              .with_content('# Foo')
          end
        end

        context 'without content' do
          let(:params) { super().merge(content: '') }

          it 'does not create a vhost concat fragment' do
            is_expected.to compile.with_all_deps
            is_expected.to contain_concat('15-default.conf')
            is_expected.not_to contain_concat__fragment('default-myfragment')
          end
        end
      end

      context 'adding to a custom vhost' do
        let(:params) do
          {
            vhost: 'custom',
            content: '# Foo',
          }
        end

        context 'with priority => false' do
          let(:params) { super().merge(priority: false) }
          let(:pre_condition) do
            <<-PUPPET
            include apache
            apache::vhost { 'custom':
              docroot  => '/path/to/docroot',
              priority => false,
            }
            PUPPET
          end

          it 'creates a vhost concat fragment' do
            is_expected.to compile.with_all_deps
            is_expected.to contain_concat('custom.conf')
            is_expected.to create_concat__fragment('custom-myfragment')
              .with_target('custom.conf')
              .with_order(900)
              .with_content('# Foo')
          end
        end

        context 'with priority => 42' do
          let(:params) { super().merge(priority: '42') }
          let(:pre_condition) do
            <<-PUPPET
            include apache
            apache::vhost { 'custom':
              docroot  => '/path/to/docroot',
              priority => '42',
            }
            PUPPET
          end

          it 'creates a vhost concat fragment' do
            is_expected.to compile.with_all_deps
            is_expected.to contain_concat('42-custom.conf')
            is_expected.to create_concat__fragment('custom-myfragment')
              .with_target('42-custom.conf')
              .with_order(900)
              .with_content('# Foo')
          end
        end

        context 'with default priority' do
          let(:pre_condition) do
            <<-PUPPET
            include apache
            apache::vhost { 'custom':
              docroot  => '/path/to/docroot',
            }
            PUPPET
          end

          it 'creates a vhost concat fragment' do
            is_expected.to compile.with_all_deps
            is_expected.to contain_concat('25-custom.conf')
            is_expected.to create_concat__fragment('custom-myfragment')
              .with_target('25-custom.conf')
              .with_order(900)
              .with_content('# Foo')
          end
        end
      end
    end
  end
end
