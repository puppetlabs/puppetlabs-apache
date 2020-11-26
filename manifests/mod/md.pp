# @summary
#   Installs and configures `mod_md`.
#
# @param md_activation_delay
#   -
#
# @param md_base_server
#   Control if base server may be managed or only virtual hosts.
#
# @param md_ca_challenges
#   Type of ACME challenge used to prove domain ownership.
#
# @param md_certificate_agreement
#   You confirm that you accepted the Terms of Service of the Certificate
#   Authority.
#
# @param md_certificate_authority
#   The URL of the ACME Certificate Authority service.
#
# @param md_certificate_check
#   -
#
# @param md_certificate_monitor
#   The URL of a certificate log monitor.
#
# @param md_certificate_protocol
#   The protocol to use with the Certificate Authority.
#
# @param md_certificate_status
#   Exposes public certificate information in JSON.
#
# @param md_challenge_dns01
#   Define a program to be called when the `dns-01` challenge needs to be
#   setup/torn down. 
#
# @param md_contact_email
#   The ACME protocol requires you to give a contact url when you sign up.
#
# @param md_http_proxy
#   Define a proxy for outgoing connections.
#
# @param md_members
#   Control if the alias domain names are automatically added.
#
# @param md_message_cmd
#   Handle events for Manage Domains.
#
# @param md_must_staple
#   Control if new certificates carry the OCSP Must Staple flag.
#
# @param md_notify_cmd
#   Run a program when a Managed Domain is ready.
#
# @param md_port_map
#   Map external to internal ports for domain ownership verification.
#
# @param md_private_keys
#   Set type and size of the private keys generated.
#
# @param md_renew_mode
#   Controls if certificates shall be renewed.
#
# @param md_renew_window
#   Control when a certificate will be renewed.
#
# @param md_require_https
#   Redirects http: traffic to https: for Managed Domains.
#   An http: Virtual Host must nevertheless be setup for that domain.
#
# @param md_server_status
#   Control if Managed Domain information is added to server-status.
#
# @param md_staple_others
#   Enable stapling for certificates not managed by mod_md.
#
# @param md_stapling
#   Enable stapling for all or a particular MDomain.
#
# @param md_stapling_keep_response
#   Controls when old responses should be removed.
#
# @param md_stapling_renew_window
#   Control when the stapling responses will be renewed.
#
# @param md_store_dir
#   Path on the local file system to store the Managed Domains data.
#
# @param md_warn_window
#  Define the time window when you want to be warned about an expiring
#  certificate.
#
# @see https://httpd.apache.org/docs/current/mod/mod_md.html for additional documentation.
#
# @note Unsupported platforms: CentOS: 6, 7; Debian: 8, 9; OracleLinux: all; RedHat: 6, 7; Scientific: all; SLES: all; Ubuntu: 14, 16, 18
class apache::mod::md (
  Optional[String]                                          $md_activation_delay       = undef,
  Optional[Enum['on', 'off']]                               $md_base_server            = undef,
  Optional[Array[Enum['dns-01', 'http-01', 'tls-alpn-01']]] $md_ca_challenges          = undef,
  Optional[Enum['accepted']]                                $md_certificate_agreement  = undef,
  Optional[Stdlib::HTTPUrl]                                 $md_certificate_authority  = undef,
  Optional[String]                                          $md_certificate_check      = undef, # undocumented
  Optional[String]                                          $md_certificate_monitor    = undef,
  Optional[Enum['ACME']]                                    $md_certificate_protocol   = undef,
  Optional[Enum['on', 'off']]                               $md_certificate_status     = undef,
  Optional[Stdlib::Absolutepath]                            $md_challenge_dns01        = undef,
  Optional[String]                                          $md_contact_email          = undef,
  Optional[Stdlib::HTTPUrl]                                 $md_http_proxy             = undef,
  Optional[Enum['auto', 'manual']]                          $md_members                = undef,
  Optional[Stdlib::Absolutepath]                            $md_message_cmd            = undef,
  Optional[Enum['on', 'off']]                               $md_must_staple            = undef,
  Optional[Stdlib::Absolutepath]                            $md_notify_cmd             = undef,
  Optional[String]                                          $md_port_map               = undef,
  Optional[String]                                          $md_private_keys           = undef,
  Optional[Enum['always', 'auto', 'manual']]                $md_renew_mode             = undef,
  Optional[String]                                          $md_renew_window           = undef,
  Optional[Enum['off', 'permanent', 'temporary']]           $md_require_https          = undef,
  Optional[Enum['on', 'off']]                               $md_server_status          = undef,
  Optional[Enum['on', 'off']]                               $md_staple_others          = undef,
  Optional[Enum['on', 'off']]                               $md_stapling               = undef,
  Optional[String]                                          $md_stapling_keep_response = undef,
  Optional[String]                                          $md_stapling_renew_window  = undef,
  Optional[Stdlib::Absolutepath]                            $md_store_dir              = undef,
  Optional[String]                                          $md_warn_window            = undef,
) {
  include apache
  include apache::mod::watchdog

  apache::mod { 'md':
  }

  file { 'md.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/md.conf",
    mode    => $apache::file_mode,
    content => epp('apache/mod/md.conf.epp'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
