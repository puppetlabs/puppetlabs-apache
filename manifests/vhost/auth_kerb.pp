
define apache::vhost::auth_kerb (
  Boolean $auth_kerb                                                                = false,
  $krb_method_negotiate                                                             = 'on',
  $krb_method_k5passwd                                                              = 'on',
  $krb_authoritative                                                                = 'on',
  $krb_auth_realms                                                                  = [],
  $krb_5keytab                                                                      = undef,
  $krb_local_user_mapping                                                           = undef,
  $krb_verify_kdc                                                                   = 'on',
  $krb_servicename                                                                  = 'HTTP',
  $krb_save_credentials                                                             = 'off',
  Optional[String] $vhost                                                           = $name,
) {

  if $auth_kerb {
    include ::apache::mod::auth_kerb
  }

  # Template uses:
  # - $auth_kerb
  # - $krb_method_negotiate
  # - $krb_method_k5passwd
  # - $krb_authoritative
  # - $krb_auth_realms
  # - $krb_5keytab
  # - $krb_local_user_mapping
  # - $krb_verify_kdc
  # - $krb_servicename
  # - $krb_save_credentials
  if $auth_kerb {
    concat::fragment { "${vhost}-auth_kerb":
      target  => "apache::vhost::${vhost}",
      order   => 230,
      content => template('apache/vhost/_auth_kerb.erb'),
    }
  }
}
