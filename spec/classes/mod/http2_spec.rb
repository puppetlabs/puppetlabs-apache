require 'spec_helper'

describe 'apache::mod::http2', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters on a Debian OS' do
    let :facts do
      {
        lsbdistcodename: 'jessie',
        osfamily: 'Debian',
        operatingsystemrelease: '8',
        id: 'root',
        kernel: 'Linux',
        operatingsystem: 'Debian',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::mod::http2') }
    context 'with default values' do
      let(:expected_content) do
        <<EOT
# The http2 Apache module configuration file is being
# managed by Puppet and changes will be overwritten.

EOT
      end

      it { is_expected.to contain_file('http2.conf').with(content: expected_content) }
    end

    context 'with all values set' do
      let(:params) do
        {
          h2_copy_files: false,
          h2_direct: true,
          h2_early_hints: false,
          h2_max_session_streams: 100,
          h2_max_worker_idle_seconds: 600,
          h2_max_workers: 20,
          h2_min_workers: 10,
          h2_modern_tls_only: true,
          h2_push: true,
          h2_push_diary_size: 256,
          h2_push_priority: [
            'application/json 32',
            'image/jpeg before',
            'text/css   interleaved',
          ],
          h2_push_resource: [
            '/xxx.css',
            '/xxx.js',
          ],
          h2_serialize_headers: true,
          h2_stream_max_mem_size: 128_000,
          h2_tls_cool_down_secs: 0,
          h2_tls_warm_up_size: 0,
          h2_upgrade: false,
          h2_window_size: 128_000,

          apache_version: '2.4',
        }
      end

      let(:expected_content) do
        <<EOT
# The http2 Apache module configuration file is being
# managed by Puppet and changes will be overwritten.

H2CopyFiles Off
H2Direct On
H2EarlyHints Off
H2MaxSessionStreams 100
H2MaxWorkerIdleSeconds 600
H2MaxWorkers 20
H2MinWorkers 10
H2ModernTLSOnly On
H2Push On
H2PushDiarySize 256
H2PushPriority application/json 32
H2PushPriority image/jpeg before
H2PushPriority text/css   interleaved
H2PushResource /xxx.css
H2PushResource /xxx.js
H2SerializeHeaders On
H2StreamMaxMemSize 128000
H2TLSCoolDownSecs 0
H2TLSWarmUpSize 0
H2Upgrade Off
H2WindowSize 128000
EOT
      end

      it { is_expected.to contain_file('http2.conf').with(content: expected_content) }
    end
  end
end
