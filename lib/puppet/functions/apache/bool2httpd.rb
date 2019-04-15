# @summary
#   Transform a supposed boolean to On or Off. Passes all other values through.
#
# Given a nil value (undef), bool2httpd will return 'Off'
#
# Example:
# ```
# $trace_enable     = false
# $server_signature = 'mail'
# 
# bool2httpd($trace_enable)
# => 'Off'
# bool2httpd($server_signature)
# => 'mail'
# bool2httpd(undef)
# => 'Off'
# ```
Puppet::Functions.create_function(:'apache::bool2httpd') do
  # @param arg
  #   The value to be converted into a string.
  # 
  # @return
  #   Will return either `On` or `Off` if given a boolean value. Return's a string of any 
  #   other given value.
  def bool2httpd(arg)
    return 'Off' if arg.nil? || arg == false || arg =~ %r{false}i || arg == :undef
    return 'On' if arg == true || arg =~ %r{true}i
    arg.to_s
  end
end
