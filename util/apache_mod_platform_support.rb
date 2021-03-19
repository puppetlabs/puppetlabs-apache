# frozen_string_literal: true

require 'json'
# Helper class to facilitate exclusion of tests that use an Apache MOD on platforms it isn't supported on.
# All Apache MOD classes are defined under 'manifests/mod'. The exclusion should be in the format:
#
# @note Unsupported platforms: OS: ver, ver; OS: ver, ver, ver; OS: all'
# class apache::mod::foobar {
# ...
#
# For example:
# @note Unsupported platforms: RedHat: 5, 6; Ubuntu: 14.04; SLES: all; Scientific: 11 SP1'
# class apache::mod::actions {
#   apache::mod { 'actions': }
# }
#
# Filtering is then performed during the test using RSpec's filtering, like so:
#
# describe 'auth_oidc', unless: mod_unsupported_on_platform('apache::mod::auth_openidc') do
# ...
# it 'applies cleanly', unless: mod_unsupported_on_platform('apache::mod::auth_openidc') do
# ...
class ApacheModPlatformCompatibility
  ERROR_MSG = {
    tag_parse:  'OS and version information in incorrect format:',
    os_parse:   'OS name is not present in metadata.json:',
  }.freeze

  def initialize
    @os = {}
    @mapping = {}
    @manifest_errors = []
    @compatible_platform_versions = {}
    @mod_platform_compatibility_mapping = {}
  end

  def register_running_platform(os)
    @os = { family: os[:family], release: os[:release].to_i }
  end

  def generate_supported_platforms_versions
    metadata = JSON.parse(File.read('metadata.json'))
    metadata['operatingsystem_support'].each do |os|
      @compatible_platform_versions[os['operatingsystem'].downcase] = os['operatingsystemrelease'].map(&:to_i)
    end
  end

  # Class to hold the details of an error whilst parsing an unsupported tag
  class ManifestError
    attr_reader :manifest, :line_num, :error_type, :error_detail

    def initialize(manifest, line_num, error_type, error_detail)
      @manifest = manifest
      @line_num = line_num
      @error_type = error_type
      @error_detail = error_detail
    end
  end

  def print_parsing_errors
    return if @manifest_errors.empty?
    $stderr.puts "The following errors were encountered when trying to parse the 'Unsupported platforms' tag(s) in 'manifests/mod':\n"
    @manifest_errors.each do |manifest_error|
      $stderr.puts " * #{manifest_error.manifest} (line #{manifest_error.line_num}): #{ERROR_MSG[manifest_error.error_type]} #{manifest_error.error_detail}"
    end
    File.readlines('util/_resources/tag_format_help_msg.txt').each do |line|
      $stderr.puts line
    end
  end

  def valid_os?(os)
    @compatible_platform_versions.key?(os)
  end

  def register_error(manifest, line_num, error_type, error_detail)
    @manifest_errors << ManifestError.new(manifest, line_num, error_type, error_detail)
  end

  def register_unsupported_platforms(manifest, line_num, mod, platforms_versions)
    platforms_versions.each_key do |os|
      unless valid_os?(os)
        register_error(manifest, line_num, :os_parse, os)
        next
      end
      if @mod_platform_compatibility_mapping.key? mod
        @mod_platform_compatibility_mapping[mod].merge!(platforms_versions)
      else
        @mod_platform_compatibility_mapping[mod] = platforms_versions
      end
    end
  end

  def extract_os_ver_pairs(line)
    platforms_versions = {}
    os_ver_groups = line.delete(' ').downcase
    # E.g. "debian:5,6;centos:5;sles:11sp1,12;scientific:all;ubuntu:14.04,16.04"
    if %r{^((?:\w+:(?:(?:\d+(?:\.\d+|sp\d+)?|all),?)+;?)+)$}i.match?(os_ver_groups)
      os_ver_groups.split(';').each do |os_vers|
        os, vers = os_vers.split(':')
        vers.gsub!(%r{sp\d+}, '') # Remove SP ver as we cannot determine this level of granularity from values from Litmus
        platforms_versions[os] = vers.split(',').map(&:to_i) # 'all' will be converted to 0
      end
    end
    platforms_versions
  end

  def process_line(line)
    data = {}
    return data unless %r{@note\sUnsupported\splatforms?:\s?|class\sapache::mod}i.match?(line)
    if (match = %r{@note\sUnsupported\splatforms?:\s?(?<os_vers>.*)$}i.match(line))
      data[:type] = :unsupported_platform_declaration
      data[:value] = match[:os_vers]
    elsif (match = %r{class\s(?<mod>apache::mod::\w+)}i.match(line))
      data[:type] = :class_declaration
      data[:value] = match[:mod]
    end
    data
  end

  def generate_mod_platform_exclusions
    Dir.glob('manifests/mod/*.pp').each do |manifest|
      platforms_versions = []
      line_num = 0
      File.readlines(manifest).each do |line|
        line_num += 1
        data = process_line(line)
        next if data.empty?
        if data[:type] == :unsupported_platform_declaration
          platforms_versions = extract_os_ver_pairs(data[:value])
          register_error(manifest, line_num, :tag_parse, line) if platforms_versions.empty?
          next
        elsif data[:type] == :class_declaration
          register_unsupported_platforms(manifest, line_num, data[:value], platforms_versions) unless platforms_versions.empty?
          break # Once we detect the class declaration, we can move on
        end
      end
    end
  end

  # Called from within the context of a test run, making use of RSpec's filtering, e.g.:
  # it 'should do some test', if: mod_supported_on_platform('apache::mod::foobar')
  def mod_supported_on_platform?(mod)
    return true if @mod_platform_compatibility_mapping.empty?
    return true unless @mod_platform_compatibility_mapping.key? mod
    return true unless @mod_platform_compatibility_mapping[mod].key? @os[:family]
    return false if @mod_platform_compatibility_mapping[mod][@os[:family]] == [0]
    !@mod_platform_compatibility_mapping[mod][@os[:family]].include? @os[:release]
  end
end
