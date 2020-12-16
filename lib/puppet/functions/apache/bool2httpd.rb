# frozen_string_literal: true

# @summary
#   Transform a supposed boolean to On or Off. Passes all other values through.
#
Puppet::Functions.create_function(:'apache::bool2httpd') do
  # @param arg
  #   The value to be converted into a string.
  #
  # @return
  #   Will return either `On` or `Off` if given a boolean value. Returns a string of any
  #   other given value.
  # @example
  #   $trace_enable     = false
  #   $server_signature = 'mail'
  #
  #   apache::bool2httpd($trace_enable) # returns 'Off'
  #   apache::bool2httpd($server_signature) # returns 'mail'
  #   apache::bool2httpd(undef) # returns 'Off'
  #
  def bool2httpd(arg)
    return 'Off' if arg.nil? || arg == false || matches_string?(arg, %r{false}i) || arg == :undef
    return 'On' if arg == true || matches_string?(arg, %r{true}i)
    arg.to_s
  end

  private

  def matches_string?(value, matcher)
    if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.4.0')
      value =~ matcher
    else
      value.is_a?(String) && value.match?(matcher)
    end
  end
end
