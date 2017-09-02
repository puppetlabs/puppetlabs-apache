
define apache::vhost::wsgi (
  $wsgi_application_group                                                           = undef,
  $wsgi_daemon_process                                                              = undef,
  Optional[Hash] $wsgi_daemon_process_options                                       = undef,
  $wsgi_import_script                                                               = undef,
  Optional[Hash] $wsgi_import_script_options                                        = undef,
  $wsgi_process_group                                                               = undef,
  Optional[Enum['on', 'off', 'On', 'Off']] $wsgi_pass_authorization                 = undef,
  $wsgi_chunked_request                                                             = undef,
  Optional[String] $vhost                                                           = $name,
) {

  if $wsgi_daemon_process {
    include ::apache::mod::wsgi
  }

  # Template uses:
  # - $wsgi_application_group
  # - $wsgi_daemon_process
  # - $wsgi_daemon_process_options
  # - $wsgi_import_script                                                                                                             # - $wsgi_import_script_options
  # - $wsgi_process_group
  # - $wsgi_pass_authorization
  # - $wsgi_chunked_request
  if $wsgi_application_group or $wsgi_daemon_process or ($wsgi_import_script and $wsgi_import_script_options) or $wsgi_process_group or $wsgi_pass_authorization or $wsgi_chunked_request {
    concat::fragment { "${vhost}-wsgi":
      target  => "apache::vhost::${vhost}",
      order   => 260,
      content => template('apache/vhost/_wsgi.erb'),
    }
  }
}
