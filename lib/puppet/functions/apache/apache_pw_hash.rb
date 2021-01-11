# frozen_string_literal: true

# @summary DEPRECATED.  Use the function [`apache::pw_hash`](#apachepw_hash) instead.
Puppet::Functions.create_function(:'apache::apache_pw_hash') do
  dispatch :deprecation_gen do
    repeated_param 'Any', :args
  end
  def deprecation_gen(*args)
    call_function('deprecation', 'apache::apache_pw_hash', 'This function is deprecated, please use apache::pw_hash instead.')
    call_function('apache::pw_hash', *args)
  end
end
