# Transform a supposed boolean to On or Off. Pass all other values through.
# Given a nil value (undef), bool2httpd will return 'Off'
#
# Example:
#
#    $trace_enable     = false
#    $server_signature = 'mail'
#
#    bool2httpd($trace_enable)
#    # => 'Off'
#    bool2httpd($server_signature)
#    # => 'mail'
#    bool2httpd(undef)
#    # => 'Off'
Puppet::Functions.create_function(:'apache::bool2httpd') do
  def bool2httpd(arg)
    return 'Off' if arg.nil? || arg == false || arg =~ %r{false}i || arg == :undef
    return 'On' if arg == true || arg =~ %r{true}i
    arg.to_s
  end
end
