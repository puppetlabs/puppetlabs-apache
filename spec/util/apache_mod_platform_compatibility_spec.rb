# frozen_string_literal: true

require 'rspec'
require 'rspec-puppet-facts'
require_relative '../../util/apache_mod_platform_support'
require_relative '_resources/test_metadata_json'

describe ApacheModPlatformCompatibility do
  foobar_pp = 'foobar.pp'
  foobar_mod = 'apache::mod::foobar'
  foobar_class = "class #{foobar_mod}"
  foobar_linux = 'foobar_linux'

  expected_compatible_platform_versions = {
    'redhat' => [6, 7, 8],
    'centos' => [6, 7, 8],
    'oraclelinux' => [6, 7],
    'scientific' => [6, 7],
    'debian' => [8, 9, 10],
    'sles' => [11, 12, 15],
    'ubuntu' => [14, 16, 18],
  }

  context 'when initialized' do
    describe '#process_line' do
      ampc = described_class.new
      it 'returns an empty hash when given garbage line' do
        expect(ampc.process_line('foobar')).to eq({})
      end
      it 'returns a hash with type: :unsupported_platform_declaration and extracted value' do
        expect(ampc.process_line('# @note Unsupported platforms: foobar')).to eq(type: :unsupported_platform_declaration, value: 'foobar')
      end
      it 'returns a hash with type: :class_declaration and extracted value' do
        expect(ampc.process_line(foobar_class)).to eq(type: :class_declaration, value: foobar_mod)
      end
    end

    describe '#extract_os_ver_pairs' do
      ampc = described_class.new
      it 'handles single OS with single Version' do
        expect(ampc.extract_os_ver_pairs('Debian: 5')).to eq('debian' => [5])
      end
      it 'handles single OS with multiple Versions' do
        expect(ampc.extract_os_ver_pairs('Debian: 5, 6, 7')).to eq('debian' => [5, 6, 7])
      end
      it 'handles multiple OSs with multiple Versions' do
        expect(ampc.extract_os_ver_pairs('Debian: 5, 6, 7; CentOS: 5,6,7')).to eq('debian' => [5, 6, 7], 'centos' => [5, 6, 7])
      end
      it 'handles Versions in \d+\.\d+ format' do
        expect(ampc.extract_os_ver_pairs('Ubuntu: 14.04, 16.04')).to eq('ubuntu' => [14, 16])
      end
      it 'handles Versions with "SP"' do
        expect(ampc.extract_os_ver_pairs('SLES: 11 SP1, 12')).to eq('sles' => [11, 12])
      end
      it 'returns an empty Hash when given data in an entirely invalid format' do
        expect(ampc.extract_os_ver_pairs('foobar')).to eq({})
      end
      it 'returns an empty Hash when given data with incorrect OS/Version group separator' do
        expect(ampc.extract_os_ver_pairs('Ubuntu#14.04, 16.04')).to eq({})
      end
      it 'returns an empty Hash when given data with incorrect OS + Version separator' do
        expect(ampc.extract_os_ver_pairs('CentOS:5,6#Debian:5,6')).to eq({})
      end
      it 'returns an empty Hash when given data with incorrect Version separator' do
        expect(ampc.extract_os_ver_pairs('CentOS:5@6')).to eq({})
      end
    end

    describe '#register_unsupported_platforms' do
      ampc = described_class.new
      it 'registers a valid unsupported platform' do
        ampc.register_running_platform(family: 'debian', release: '8.11', arch: 'x86_64')
        expect(ampc).to receive(:valid_os?).with('debian').and_return(true)
        ampc.register_unsupported_platforms(foobar_pp, 1, foobar_mod, 'debian' => [8])
        expect(ampc.mod_supported_on_platform?(foobar_mod)).to be(false)
      end
      it 'registers multiple valid unsupported platforms' do
        expect(ampc).to receive(:valid_os?).with('debian').and_return(true)
        expect(ampc).to receive(:valid_os?).with('ubuntu').and_return(true)
        ampc.register_unsupported_platforms(foobar_pp, 1, foobar_mod, 'debian' => [8])
        ampc.register_unsupported_platforms(foobar_pp, 1, foobar_mod, 'ubuntu' => [14])
        ampc.register_running_platform(family: 'debian', release: '8.11', arch: 'x86_64')
        expect(ampc.mod_supported_on_platform?(foobar_mod)).to be(false)
        ampc.register_running_platform(family: 'ubuntu', release: '14.04', arch: 'x86_64')
        expect(ampc.mod_supported_on_platform?(foobar_mod)).to be(false)
      end
      it 'registers an :os_parse error when given an invalid platform' do
        expect(ampc).to receive(:valid_os?).with(foobar_linux).and_return(false)
        expect(ampc).to receive(:register_error).with(foobar_pp, 1, :os_parse, foobar_linux)
        ampc.register_unsupported_platforms(foobar_pp, 1, foobar_mod, foobar_linux => [1])
        ampc.register_running_platform(family: 'debian', release: '8.11', arch: 'x86_64')
      end
    end

    describe '#generate_supported_platforms_versions' do
      ampc = described_class.new

      before(:each) do
        allow(File).to receive(:read).and_call_original
        allow(File).to receive(:read).with('../../metadata.json').and_return(METADATA_JSON)
        ampc.generate_supported_platforms_versions
        ampc.register_unsupported_platforms(foobar_pp, 1, foobar_mod, foobar_linux => [1])
      end

      context 'after parsing the metadata.json' do
        expected_compatible_platform_versions.each do |os, vers|
          vers.each do |ver|
            it "states #{os} version #{ver} IS a compatible platform" do
              ampc.register_running_platform(family: os, version: ver)
              expect(ampc.mod_supported_on_platform?(foobar_mod)).to be(true)
            end
          end
        end
      end
    end

    describe '#mod_unsupported_on_platform' do
      ampc = described_class.new
      before(:each) do
        allow(File).to receive(:read).and_call_original
        allow(File).to receive(:read).with('../../metadata.json').and_return(METADATA_JSON)
        ampc = described_class.new
        ampc.generate_supported_platforms_versions
      end

      ubuntu_14_04_os = { family: 'ubuntu', release: '14.04' }

      it 'returns false when running on an OS with all versions incompatible' do
        ampc.register_running_platform(ubuntu_14_04_os)
        ampc.register_unsupported_platforms(foobar_pp, 1, foobar_mod, 'ubuntu' => [0])
        expect(ampc.mod_supported_on_platform?(foobar_mod)).to be(false)
      end
      it 'returns false when running on an OS with one specific version incompatible' do
        ampc.register_running_platform(ubuntu_14_04_os)
        ampc.register_unsupported_platforms(foobar_pp, 1, foobar_mod, 'ubuntu' => [14])
        expect(ampc.mod_supported_on_platform?(foobar_mod)).to be(false)
      end
      it 'returns true when running on an OS with no versions marked as incompatible' do
        ampc.register_running_platform(ubuntu_14_04_os)
        ampc.register_unsupported_platforms(foobar_pp, 1, foobar_mod, 'debian' => [6, 7])
        expect(ampc.mod_supported_on_platform?(foobar_mod)).to be(true)
      end
      it 'returns true when running on an OS version not marked as incompatible' do
        ampc.register_running_platform(ubuntu_14_04_os)
        ampc.register_unsupported_platforms(foobar_pp, 1, foobar_mod, 'ubuntu' => [16, 18])
        expect(ampc.mod_supported_on_platform?(foobar_mod)).to be(true)
      end
    end

    describe '#print_parsing_errors' do
      ampc = described_class.new
      abc_pp = 'abc.pp'
      abc_pp_error_line = 1
      abc_pp_error_type = :tag_parse
      abc_pp_error_type_msg = 'OS and version information in incorrect format:'
      abc_pp_error_detail = 'Bad line'
      def_pp = 'def.pp'
      def_pp_error_line = 2
      def_pp_error_type = :os_parse
      def_pp_error_type_msg = 'OS name is not present in metadata.json:'
      def_pp_error_detail = foobar_linux

      tag_format_help_msg_txt = ['succint', 'warning']

      expected_stderr_msg = "The following errors were encountered when trying to parse the 'Unsupported platforms' tag(s) in 'manifests/mod':\n" \
                            " * #{abc_pp} (line #{abc_pp_error_line}): #{abc_pp_error_type_msg} #{abc_pp_error_detail}\n" \
                            " * #{def_pp} (line #{def_pp_error_line}): #{def_pp_error_type_msg} #{def_pp_error_detail}\n" \
                            "#{tag_format_help_msg_txt[0]}\n" \
                            "#{tag_format_help_msg_txt[1]}\n"

      context 'given a number of errors were discovered when parsing the manifests' do
        ampc.register_error(abc_pp, abc_pp_error_line, abc_pp_error_type, abc_pp_error_detail)
        ampc.register_error(def_pp, def_pp_error_line, def_pp_error_type, def_pp_error_detail)
        it 'prints the expected warnings to $stderr' do
          allow(File).to receive(:readlines).with('util/_resources/tag_format_help_msg.txt').and_return(tag_format_help_msg_txt)
          expect { ampc.print_parsing_errors }.to output(expected_stderr_msg).to_stderr
        end
      end
    end
  end
end
