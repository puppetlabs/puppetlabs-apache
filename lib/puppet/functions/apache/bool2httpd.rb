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
    if arg.nil? or arg == false or arg =~ /false/i or arg == :undef
      return 'Off'
    elsif arg == true or arg =~ /true/i
      return 'On'
    end

    return arg.to_s
  end
end
