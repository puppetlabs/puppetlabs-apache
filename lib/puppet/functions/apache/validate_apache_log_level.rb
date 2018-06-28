#    Perform simple validation of a string against the list of known log
#    levels as per http://httpd.apache.org/docs/current/mod/core.html#loglevel
#        validate_apache_loglevel('info')
#
#    Modules maybe specified with their own levels like these:
#        validate_apache_loglevel('warn ssl:info')
#        validate_apache_loglevel('warn mod_ssl.c:info')
#        validate_apache_loglevel('warn ssl_module:info')
#
#    Expected to be used from the main or vhost.
#    Might be used from directory too later as apache supports that
Puppet::Functions.create_function(:'apache::validate_apache_log_level') do
  dispatch :validate_apache_log_level do
    required_param 'String', :log_level
  end

  def validate_apache_log_level(log_level)
    msg = "Log level '${log_level}' is not one of the supported Apache HTTP Server log levels."
    raise Puppet::ParseError, msg unless log_level =~ Regexp.compile('(emerg|alert|crit|error|warn|notice|info|debug|trace[1-8])')
  end
end
