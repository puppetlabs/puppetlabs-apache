# @summary DEPRECATED.  Use the namespaced function [`apache::bool2httpd`](#apachebool2httpd) instead.
Puppet::Functions.create_function(:bool2httpd) do
  dispatch :deprecation_gen do
    repeated_param 'Any', :args
  end
  def deprecation_gen(*args)
    call_function('deprecation', 'bool2httpd', 'This function is deprecated, please use apache::bool2httpd instead.')
    call_function('apache::bool2httpd', *args)
  end
end
