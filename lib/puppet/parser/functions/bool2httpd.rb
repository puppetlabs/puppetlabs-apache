Puppet::Parser::Functions.newfunction(:bool2httpd, type: :rvalue, doc: <<-DOC
  @summary
    Transform a supposed boolean to On or Off. Pass all other values through.

  Given a nil value (undef), bool2httpd will return 'Off'
  Example:
  ```
  $trace_enable     = false
  $server_signature = 'mail'
  bool2httpd($trace_enable)
  => 'Off'
  bool2httpd($server_signature)
  => 'mail'
  bool2httpd(undef)
  => 'Off'
  ```

  @param arg
    The value to be converted into a string.

  @return
    Will return either `On` or `Off` if given a boolean value. Return's a string of any
    other given value.
DOC
                                     ) do |args|
  raise(Puppet::ParseError, "bool2httpd() wrong number of arguments. Given: #{args.size} for 1)") if args.size != 1

  arg = args[0]
  return 'Off' if arg.nil? || arg == false || arg =~ %r{false}i || arg == :undef
  return 'On' if arg == true || arg =~ %r{true}i
  return arg.to_s
end
