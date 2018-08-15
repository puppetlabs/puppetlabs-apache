require 'spec_helper'

describe 'apache::mod::php', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      case facts[:os]['family']
      when 'Debian'
        describe 'on a Debian OS' do
          context 'with mpm_module => prefork' do
            let :pre_condition do
              'class { "apache": mpm_module => prefork, }'
            end

            it { is_expected.to contain_class('apache::params') }
            it { is_expected.to contain_class('apache::mod::prefork') }
          end
          case facts[:os]['release']['major']
          when '8'
            context 'on jessie' do
              let :pre_condition do
                'class { "apache": mpm_module => prefork, }'
              end

              it {
                is_expected.to contain_file('php5.load').with(
                  content: "LoadModule php5_module /usr/lib/apache2/modules/libphp5.so\n",
                )
              }
              context 'with mpm_module => itk on jessie' do
                let :pre_condition do
                  'class { "apache": mpm_module => itk, }'
                end

                it { is_expected.to contain_class('apache::params') }
                it { is_expected.to contain_class('apache::mod::itk') }
                it { is_expected.to contain_apache__mod('php5') }
                it { is_expected.to contain_package('libapache2-mod-php5') }
                it {
                  is_expected.to contain_file('php5.load').with(
                    content: "LoadModule php5_module /usr/lib/apache2/modules/libphp5.so\n",
                  )
                }
              end
            end
          when '9'
            context 'on stretch' do
              let :pre_condition do
                'class { "apache": mpm_module => prefork, }'
              end

              it { is_expected.to contain_apache__mod('php7.0') }
              it { is_expected.to contain_package('libapache2-mod-php7.0') }
              it {
                is_expected.to contain_file('php7.0.load').with(
                  content: "LoadModule php7_module /usr/lib/apache2/modules/libphp7.0.so\n",
                )
              }
            end
          end
        end
      when 'RedHat'
        describe 'on a RedHat OS' do
          context 'with default params' do
            let :pre_condition do
              'class { "apache": }'
            end

            it { is_expected.to contain_class('apache::params') }
            it { is_expected.to contain_apache__mod('php5') }
            it { is_expected.to contain_package('php') }
            it {
              is_expected.to contain_file('php5.load').with(
                content: "LoadModule php5_module modules/libphp5.so\n",
              )
            }
          end
          context 'with alternative package name' do
            let :pre_condition do
              'class { "apache": }'
            end
            let :params do
              { package_name: 'php54' }
            end

            it { is_expected.to contain_package('php54') }
          end
          context 'with alternative path' do
            let :pre_condition do
              'class { "apache": }'
            end
            let :params do
              { path: 'alternative-path' }
            end

            it {
              is_expected.to contain_file('php5.load').with(
                content: "LoadModule php5_module alternative-path\n",
              )
            }
          end
          context 'with alternative extensions' do
            let :pre_condition do
              'class { "apache": }'
            end
            let :params do
              { extensions: ['.php', '.php5'] }
            end

            it { is_expected.to contain_file('php5.conf').with_content(Regexp.new(Regexp.escape('<FilesMatch ".+(\.php|\.php5)$">'))) }
          end
          context 'with specific version' do
            let :pre_condition do
              'class { "apache": }'
            end
            let :params do
              { package_ensure: '5.3.13' }
            end

            it {
              is_expected.to contain_package('php').with(
                ensure: '5.3.13',
              )
            }
          end
          context 'with mpm_module => prefork' do
            let :pre_condition do
              'class { "apache": mpm_module => prefork, }'
            end

            it { is_expected.to contain_class('apache::params') }
            it { is_expected.to contain_class('apache::mod::prefork') }
            it { is_expected.to contain_apache__mod('php5') }
            it { is_expected.to contain_package('php') }
            it {
              is_expected.to contain_file('php5.load').with(
                content: "LoadModule php5_module modules/libphp5.so\n",
              )
            }
          end
          context 'with mpm_module => itk' do
            let :pre_condition do
              'class { "apache": mpm_module => itk, }'
            end

            it { is_expected.to contain_class('apache::params') }
            it { is_expected.to contain_class('apache::mod::itk') }
            it { is_expected.to contain_apache__mod('php5') }
            it { is_expected.to contain_package('php') }
            it {
              is_expected.to contain_file('php5.load').with(
                content: "LoadModule php5_module modules/libphp5.so\n",
              )
            }
          end
        end
      when 'FreeBSD'
        describe 'on a FreeBSD OS' do
          context 'with mpm_module => prefork' do
            let :pre_condition do
              'class { "apache": mpm_module => prefork, }'
            end

            it { is_expected.to contain_class('apache::params') }
            it { is_expected.to contain_apache__mod('php5') }
            it { is_expected.to contain_package('www/mod_php5') }
            it { is_expected.to contain_file('php5.load') }
          end
          context 'with mpm_module => itk' do
            let :pre_condition do
              'class { "apache": mpm_module => itk, }'
            end

            it { is_expected.to contain_class('apache::params') }
            it { is_expected.to contain_class('apache::mod::itk') }
            it { is_expected.to contain_apache__mod('php5') }
            it { is_expected.to contain_package('www/mod_php5') }
            it { is_expected.to contain_file('php5.load') }
          end
        end
      when 'Gentoo'
        describe 'on a Gentoo OS' do
          context 'with mpm_module => prefork' do
            let :pre_condition do
              'class { "apache": mpm_module => prefork, }'
            end

            it { is_expected.to contain_class('apache::params') }
            it { is_expected.to contain_apache__mod('php5') }
            it { is_expected.to contain_package('dev-lang/php') }
            it { is_expected.to contain_file('php5.load') }
          end
          context 'with mpm_module => itk' do
            let :pre_condition do
              'class { "apache": mpm_module => itk, }'
            end

            it { is_expected.to contain_class('apache::params') }
            it { is_expected.to contain_class('apache::mod::itk') }
            it { is_expected.to contain_apache__mod('php5') }
            it { is_expected.to contain_package('dev-lang/php') }
            it { is_expected.to contain_file('php5.load') }
          end
        end
      end

      # all the following tests are for legacy php/apache versions. They don't work on modern ubuntu
      next if facts[:os]['release']['major'].to_i > 15 && facts[:os]['name'] == 'Ubuntu'

      describe 'OS independent tests' do
        context 'with content param' do
          let :pre_condition do
            'class { "apache": mpm_module => prefork, }'
          end
          let :params do
            { content: 'somecontent' }
          end

          it {
            is_expected.to contain_file('php5.conf').with(
              content: 'somecontent',
            )
          }
        end
        context 'with template param' do
          let :pre_condition do
            'class { "apache": mpm_module => prefork, }'
          end
          let :params do
            { template: 'apache/mod/php.conf.erb' }
          end

          it {
            is_expected.to contain_file('php5.conf').with(
              content: %r{^# PHP is an HTML-embedded scripting language which attempts to make it},
            )
          }
        end
        context 'with source param' do
          let :pre_condition do
            'class { "apache": mpm_module => prefork, }'
          end
          let :params do
            { source: 'some-path' }
          end

          it {
            is_expected.to contain_file('php5.conf').with(
              source: 'some-path',
            )
          }
        end
        context 'content has priority over template' do
          let :pre_condition do
            'class { "apache": mpm_module => prefork, }'
          end
          let :params do
            {
              template: 'apache/mod/php5.conf.erb',
              content: 'somecontent',
            }
          end

          it {
            is_expected.to contain_file('php5.conf').with(
              content: 'somecontent',
            )
          }
        end
        context 'source has priority over template' do
          let :pre_condition do
            'class { "apache": mpm_module => prefork, }'
          end
          let :params do
            {
              template: 'apache/mod/php5.conf.erb',
              source: 'some-path',
            }
          end

          it {
            is_expected.to contain_file('php5.conf').with(
              source: 'some-path',
            )
          }
        end
        context 'source has priority over content' do
          let :pre_condition do
            'class { "apache": mpm_module => prefork, }'
          end
          let :params do
            {
              content: 'somecontent',
              source: 'some-path',
            }
          end

          it {
            is_expected.to contain_file('php5.conf').with(
              source: 'some-path',
            )
          }
        end
        context 'with mpm_module => worker' do
          let :pre_condition do
            'class { "apache": mpm_module => worker, }'
          end

          it 'raises an error' do
            expect { expect(subject).to contain_apache__mod('php5') }.to raise_error Puppet::Error, %r{mpm_module => 'prefork' or mpm_module => 'itk'}
          end
        end
      end
    end
  end
end
