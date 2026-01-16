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
# @param md_certificate_file
#   Specify a static certificate file for the MD.
#
# @param md_certificate_key_file
#   Specify a static private key for for the static cerrtificate.
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
# @param md_challenge_dns01_version
#   Set the type of arguments to call MDChallengeDns01 with
#
# @param md_check_interval
#   Determines how often certificates are checked
#
# @param md_contact_email
#   The ACME protocol requires you to give a contact url when you sign up.
#
# @param md_external_account_binding
#   Set the external account binding keyid and hmac values to use at CA
#
# @param md_http_proxy
#   Define a proxy for outgoing connections.
#
# @param md_initial_delay
#   How long to delay the first certificate check.
#
# @param md_match_names
#   Determines how DNS names are matched to vhosts
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
# @param md_profile
#   Use a specific ACME profile from the CA
#
# @param md_profile_mandatory
#   Control if an MDProfile is mandatory.
#
# @param md_renew_mode
#   Controls if certificates shall be renewed.
#
# @param md_renew_via_ari
#   usage of the ACME ARI extension (rfc9773).
#
# @param md_renew_window
#   Control when a certificate will be renewed.
#
# @param md_require_https
#   Redirects http: traffic to https: for Managed Domains.
#   An http: Virtual Host must nevertheless be setup for that domain.
#
# @param md_retry_delay
#   Time length for first retry, doubled on every consecutive error.
#
# @param md_retry_failover
#   The number of errors before a failover to another CA is triggered
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
# @param md_store_locks
#   Configure locking of store for updates
#
# @param md_warn_window
#  Define the time window when you want to be warned about an expiring
#  certificate.
#
# @see https://httpd.apache.org/docs/current/mod/mod_md.html for additional documentation.
#
# @note Unsupported platforms: CentOS: 6, 7; OracleLinux: all; RedHat: 6, 7; Scientific: all; SLES: all; Ubuntu: 18
class apache::mod::md (
  Optional[String]                                          $md_activation_delay       = undef,
  Optional[Apache::OnOff]                                   $md_base_server            = undef,
  Optional[Array[Enum['dns-01', 'http-01', 'tls-alpn-01']]] $md_ca_challenges          = undef,
  Optional[Enum['accepted']]                                $md_certificate_agreement  = undef,
  Optional[Stdlib::HTTPUrl]                                 $md_certificate_authority  = undef,
  Optional[String]                                          $md_certificate_check      = undef, # undocumented
  Optional[Stdlib::Absolutepath]                            $md_certificate_file       = undef,
  Optional[Stdlib::Absolutepath]                            $md_certificate_key_file   = undef,
  Optional[String]                                          $md_certificate_monitor    = undef,
  Optional[Enum['ACME']]                                    $md_certificate_protocol   = undef,
  Optional[Apache::OnOff]                                   $md_certificate_status     = undef,
  Optional[Stdlib::Absolutepath]                            $md_challenge_dns01        = undef,
  Optional[Integer[1,2]]                                    $md_challenge_dns01_version = undef,
  Optional[String]                                          $md_check_interval         = undef,
  Optional[String]                                          $md_contact_email          = undef,
  Optional[String]                                          $md_external_account_binding = undef,
  Optional[Stdlib::HTTPUrl]                                 $md_http_proxy             = undef,
  Optional[String]                                          $md_initial_delay          = undef,
  Optional[String]                                          $md_match_names            = undef,
  Optional[Enum['auto', 'manual']]                          $md_members                = undef,
  Optional[Stdlib::Absolutepath]                            $md_message_cmd            = undef,
  Optional[Apache::OnOff]                                   $md_must_staple            = undef,
  Optional[Stdlib::Absolutepath]                            $md_notify_cmd             = undef,
  Optional[String]                                          $md_port_map               = undef,
  Optional[String]                                          $md_private_keys           = undef,
  Optional[String]                                          $md_profile                = undef,
  Optional[Apache::OnOff]                                   $md_profile_mandatory      = undef,
  Optional[Enum['always', 'auto', 'manual']]                $md_renew_mode             = undef,
  Optional[Apache::OnOff]                                   $md_renew_via_ari          = undef,
  Optional[String]                                          $md_renew_window           = undef,
  Optional[Enum['off', 'permanent', 'temporary']]           $md_require_https          = undef,
  Optional[String]                                          $md_retry_delay            = undef,
  Optional[Integer[0]]                                      $md_retry_failover         = undef,
  Optional[Apache::OnOff]                                   $md_server_status          = undef,
  Optional[Apache::OnOff]                                   $md_staple_others          = undef,
  Optional[Apache::OnOff]                                   $md_stapling               = undef,
  Optional[String]                                          $md_stapling_keep_response = undef,
  Optional[String]                                          $md_stapling_renew_window  = undef,
  Optional[Stdlib::Absolutepath]                            $md_store_dir              = undef,
  Optional[String]                                          $md_store_locks            = undef,
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
