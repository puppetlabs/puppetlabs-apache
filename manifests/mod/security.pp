# @summary
#   Installs and configures `mod_security`.
# 
# @param version
#   Manage mod_security or mod_security2
#
# @param logroot
#   Configures the location of audit and debug logs.
# 
# @param crs_package
#   Name of package that installs CRS rules.
# 
# @param activated_rules
#   An array of rules from the modsec_crs_path or absolute to activate via symlinks.
#
# @param custom_rules
# 
# @param custom_rules_set
#
# @param modsec_dir
#   Defines the path where Puppet installs the modsec configuration and activated rules links.
# 
# @param modsec_secruleengine
#   Configures the rules engine.
# 
# @param audit_log_relevant_status
#   Configures which response status code is to be considered relevant for the purpose of audit logging.
# 
# @param audit_log_parts
#   Defines which parts of each transaction are going to be recorded in the audit log. Each part is assigned a single letter; when a
#   letter appears in the list then the equivalent part will be recorded.
# 
# @param audit_log_type
#   Defines the type of audit logging mechanism to be used.
#
# @param audit_log_format
#   Defines what format the logs should be written in. Accepts `Native` and `JSON`.
#   Default value: Native
# 
# @param audit_log_storage_dir
#   Defines the directory where concurrent audit log entries are to be stored. This directive is only needed when concurrent audit logging is used.
# 
# @param secpcrematchlimit
#   Sets the match limit in the PCRE library.
# 
# @param secpcrematchlimitrecursion
#   Sets the match limit recursion in the PCRE library.
# 
# @param allowed_methods
#   A space-separated list of allowed HTTP methods.
# 
# @param content_types
#   A list of one or more allowed MIME types.
# 
# @param restricted_extensions
#   A space-sparated list of prohibited file extensions.
# 
# @param restricted_headers
#   A list of restricted headers separated by slashes and spaces.
# 
# @param secdefaultaction
#   Defines the default list of actions, which will be inherited by the rules in the same configuration context.
# 
# @param inbound_anomaly_threshold
#   Sets the scoring threshold level of the inbound blocking rules for the Collaborative Detection Mode in the OWASP ModSecurity Core Rule Set.
# 
# @param outbound_anomaly_threshold
#   Sets the scoring threshold level of the outbound blocking rules for the Collaborative Detection Mode in the OWASP ModSecurity Core Rule Set.
# 
# @param critical_anomaly_score
#   Sets the Anomaly Score for rules assigned with a critical severity.
# 
# @param error_anomaly_score
#   Sets the Anomaly Score for rules assigned with a error severity.
# 
# @param warning_anomaly_score
#   Sets the Anomaly Score for rules assigned with a warning severity.
# 
# @param notice_anomaly_score
#   Sets the Anomaly Score for rules assigned with a notice severity.
# 
# @param paranoia_level
#   Sets the paranoia level in the OWASP ModSecurity Core Rule Set.
# 
# @param executing_paranoia_level
#   Sets the executing paranoia level in the OWASP ModSecurity Core Rule Set.
#   The default is equal to, and cannot be lower than, $paranoia_level.
# 
# @param secrequestmaxnumargs
#   Sets the maximum number of arguments in the request.
# 
# @param secrequestbodylimit
#   Sets the maximum request body size ModSecurity will accept for buffering.
# 
# @param secrequestbodynofileslimit
#   Configures the maximum request body size ModSecurity will accept for buffering, excluding the size of any files being transported 
#   in the request.
# 
# @param secrequestbodyinmemorylimit
#   Configures the maximum request body size that ModSecurity will store in memory.
# 
# @param secrequestbodyaccess
#   Toggle SecRequestBodyAccess On or Off
# 
# @param secrequestbodylimitaction
#   Controls what happens once a request body limit, configured with
#   SecRequestBodyLimit, is encountered
# 
# @param secresponsebodyaccess
#   Toggle SecResponseBodyAccess On or Off
#
# @param secresponsebodylimitaction
#   Controls what happens once a response body limit, configured with
#   SecResponseBodyLimitAction, is encountered. 
# 
# @param manage_security_crs
#   Toggles whether to manage ModSecurity Core Rule Set 
#
# @param enable_dos_protection
#   Toggles the optional OWASP ModSecurity Core Rule Set DOS protection rule
#   (rule id 900700)
#
# @param dos_burst_time_slice
#   Configures time in which a burst is measured for the OWASP ModSecurity Core Rule Set DOS protection rule
#   (rule id 900700)
#
# @param dos_counter_threshold
#   Configures the amount of requests that can be made within dos_burst_time_slice before it is considered a burst in
#   the OWASP ModSecurity Core Rule Set DOS protection rule (rule id 900700)
#
# @param dos_block_timeout
#   Configures how long the client should be blocked when the dos_counter_threshold is exceeded in the OWASP
#   ModSecurity Core Rule Set DOS protection rule (rule id 900700)
#
# @see https://github.com/SpiderLabs/ModSecurity/wiki for additional documentation.
# @see https://coreruleset.org/docs/ for addional documentation
#
class apache::mod::security (
  Stdlib::Absolutepath $logroot                                = $apache::params::logroot,
  Integer $version                                             = $apache::params::modsec_version,
  Optional[String] $crs_package                                = $apache::params::modsec_crs_package,
  Array[String] $activated_rules                               = $apache::params::modsec_default_rules,
  Boolean $custom_rules                                        = $apache::params::modsec_custom_rules,
  Optional[Array[String]] $custom_rules_set                    = $apache::params::modsec_custom_rules_set,
  Stdlib::Absolutepath $modsec_dir                             = $apache::params::modsec_dir,
  String $modsec_secruleengine                                 = $apache::params::modsec_secruleengine,
  String $audit_log_relevant_status                            = '^(?:5|4(?!04))',
  String $audit_log_parts                                      = $apache::params::modsec_audit_log_parts,
  String $audit_log_type                                       = $apache::params::modsec_audit_log_type,
  Enum['Native', 'JSON'] $audit_log_format                     = $apache::params::modsec_audit_log_format,
  Optional[Stdlib::Absolutepath] $audit_log_storage_dir        = undef,
  Integer $secpcrematchlimit                                   = $apache::params::secpcrematchlimit,
  Integer $secpcrematchlimitrecursion                          = $apache::params::secpcrematchlimitrecursion,
  String $allowed_methods                                      = 'GET HEAD POST OPTIONS',
  String $content_types                                        = 'application/x-www-form-urlencoded|multipart/form-data|text/xml|application/xml|application/x-amf',
  String $restricted_extensions                                = '.asa/ .asax/ .ascx/ .axd/ .backup/ .bak/ .bat/ .cdx/ .cer/ .cfg/ .cmd/ .com/ .config/ .conf/ .cs/ .csproj/ .csr/ .dat/ .db/ .dbf/ .dll/ .dos/ .htr/ .htw/ .ida/ .idc/ .idq/ .inc/ .ini/ .key/ .licx/ .lnk/ .log/ .mdb/ .old/ .pass/ .pdb/ .pol/ .printer/ .pwd/ .resources/ .resx/ .sql/ .sys/ .vb/ .vbs/ .vbproj/ .vsdisco/ .webinfo/ .xsd/ .xsx/',
  String $restricted_headers                                   = '/Proxy-Connection/ /Lock-Token/ /Content-Range/ /Translate/ /via/ /if/',
  String $secdefaultaction                                     = 'deny',
  Integer $inbound_anomaly_threshold                           = 5,
  Integer $outbound_anomaly_threshold                          = 4,
  Integer $critical_anomaly_score                              = 5,
  Integer $error_anomaly_score                                 = 4,
  Integer $warning_anomaly_score                               = 3,
  Integer $notice_anomaly_score                                = 2,
  Integer $secrequestmaxnumargs                                = 255,
  Integer $secrequestbodylimit                                 = 13107200,
  Integer $secrequestbodynofileslimit                          = 131072,
  Integer $secrequestbodyinmemorylimit                         = 131072,
  Integer[1,4] $paranoia_level                                 = 1,
  Integer[1,4] $executing_paranoia_level                       = $paranoia_level,
  Apache::OnOff $secrequestbodyaccess                          = 'On',
  Apache::OnOff $secresponsebodyaccess                         = 'Off',
  Enum['Reject', 'ProcessPartial'] $secrequestbodylimitaction  = 'Reject',
  Enum['Reject', 'ProcessPartial'] $secresponsebodylimitaction = 'ProcessPartial',
  Boolean $manage_security_crs                                 = true,
  Boolean $enable_dos_protection                               = true,
  Integer[1, default] $dos_burst_time_slice                    = 60,
  Integer[1, default] $dos_counter_threshold                   = 100,
  Integer[1, default] $dos_block_timeout                       = 600,
) inherits apache::params {
  include apache

  $_secdefaultaction = $secdefaultaction ? {
    /log/   => $secdefaultaction, # it has log or nolog,auditlog or log,noauditlog
    default => "${secdefaultaction},log",
  }

  if $facts['os']['family'] == 'FreeBSD' {
    fail('FreeBSD is not currently supported')
  }

  if ($facts['os']['family'] == 'Suse' and versioncmp($facts['os']['release']['major'], '11') < 0) {
    fail('SLES 10 is not currently supported.')
  }

  if ($executing_paranoia_level < $paranoia_level) {
    fail('Executing paranoia level cannot be lower than paranoia level')
  }

  case $version {
    1: {
      $mod_name = 'security'
      $mod_conf_name = 'security.conf'
    }
    2: {
      $mod_name = 'security2'
      $mod_conf_name = 'security2.conf'
    }
    default: {
      fail('Unsuported version for mod security')
    }
  }
  ::apache::mod { $mod_name:
    id  => 'security2_module',
    lib => 'mod_security2.so',
  }

  ::apache::mod { 'unique_id':
    id  => 'unique_id_module',
    lib => 'mod_unique_id.so',
  }

  if $crs_package {
    package { $crs_package:
      ensure => 'installed',
      before => [
        File[$apache::confd_dir],
        File[$modsec_dir],
      ],
    }
  }

  # Template uses:
  # - logroot
  # - $modsec_dir
  # - $audit_log_parts
  # - $audit_log_type
  # - $audit_log_storage_dir
  # - secpcrematchlimit
  # - secpcrematchlimitrecursion
  # - secrequestbodylimit
  # - secrequestbodynofileslimit
  # - secrequestbodyinmemorylimit
  # - secrequestbodyaccess
  # - secresponsebodyaccess
  # - secrequestbodylimitaction
  # - secresponsebodylimitaction
  $security_conf_parameters = {
    'modsec_secruleengine'        => $modsec_secruleengine,
    'secrequestbodyaccess'        => $secrequestbodyaccess,
    'custom_rules'                => $custom_rules,
    'modsec_dir'                  => $modsec_dir,
    'secrequestbodylimit'         => $secrequestbodylimit,
    'secrequestbodynofileslimit'  => $secrequestbodynofileslimit,
    'secrequestbodyinmemorylimit' => $secrequestbodyinmemorylimit,
    'secrequestbodylimitaction'   => $secrequestbodylimitaction,
    'secpcrematchlimit'           => $secpcrematchlimit,
    'secpcrematchlimitrecursion'  => $secpcrematchlimitrecursion,
    'secresponsebodyaccess'       => $secresponsebodyaccess,
    'secresponsebodylimitaction'  => $secresponsebodylimitaction,
    'audit_log_relevant_status'   => $audit_log_relevant_status,
    'audit_log_parts'             => $audit_log_parts,
    'audit_log_type'              => $audit_log_type,
    'audit_log_format'            => $audit_log_format,
    'audit_log_storage_dir'       => $audit_log_storage_dir,
    'logroot'                     => $logroot,
  }

  file { 'security.conf':
    ensure  => file,
    content => epp('apache/mod/security.conf.epp', $security_conf_parameters),
    mode    => $apache::file_mode,
    path    => "${apache::mod_dir}/${mod_conf_name}",
    owner   => $apache::params::user,
    group   => $apache::params::group,
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }

  file { $modsec_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    purge   => true,
    force   => true,
    recurse => true,
    require => Package['httpd'],
  }

  file { "${modsec_dir}/activated_rules":
    ensure  => directory,
    owner   => $apache::params::user,
    group   => $apache::params::group,
    mode    => '0555',
    purge   => true,
    force   => true,
    recurse => true,
    notify  => Class['apache::service'],
  }

  if $custom_rules {
    # Template to add custom rule and included in security configuration
    file { "${modsec_dir}/custom_rules":
      ensure  => directory,
      owner   => $apache::params::user,
      group   => $apache::params::group,
      mode    => $apache::file_mode,
      require => File[$modsec_dir],
    }

    file { "${modsec_dir}/custom_rules/custom_01_rules.conf":
      ensure  => file,
      owner   => $apache::params::user,
      group   => $apache::params::group,
      mode    => $apache::file_mode,
      content => epp('apache/mod/security_custom.conf.epp', { 'custom_rules_set'  => $custom_rules_set, }),
      require => File["${modsec_dir}/custom_rules"],
      notify  => Class['apache::service'],
    }
  }

  if $manage_security_crs {
    # Template uses:
    # - $_secdefaultaction
    # - $critical_anomaly_score
    # - $error_anomaly_score
    # - $warning_anomaly_score
    # - $notice_anomaly_score
    # - $inbound_anomaly_threshold
    # - $outbound_anomaly_threshold
    # - $paranoia_level
    # - $executing_paranoia_level
    # - $allowed_methods
    # - $content_types
    # - $restricted_extensions
    # - $restricted_headers
    # - $secrequestmaxnumargs
    # - $enable_dos_protection
    # - $dos_burst_time_slice
    # - $dos_counter_threshold
    # - $dos_block_timeout
    $security_crs_parameters = {
      '_secdefaultaction'           => $_secdefaultaction,
      'critical_anomaly_score'      => $critical_anomaly_score,
      'error_anomaly_score'         => $error_anomaly_score,
      'warning_anomaly_score'       => $warning_anomaly_score,
      'notice_anomaly_score'        => $notice_anomaly_score,
      'inbound_anomaly_threshold'   => $inbound_anomaly_threshold,
      'outbound_anomaly_threshold'  => $outbound_anomaly_threshold,
      'secrequestmaxnumargs'        => $secrequestmaxnumargs,
      'allowed_methods'             => $allowed_methods,
      'content_types'               => $content_types,
      'restricted_extensions'       => $restricted_extensions,
      'restricted_headers'          => $restricted_headers,
      'paranoia_level'              => $paranoia_level,
      'executing_paranoia_level'    => $executing_paranoia_level,
      'enable_dos_protection'       => $enable_dos_protection,
      'dos_burst_time_slice'        => $dos_burst_time_slice,
      'dos_counter_threshold'       => $dos_counter_threshold,
      'dos_block_timeout'           => $dos_block_timeout,
    }

    file { "${modsec_dir}/security_crs.conf":
      ensure  => file,
      content => template('apache/mod/security_crs.conf.erb'),
      require => File[$modsec_dir],
      notify  => Class['apache::service'],
    }

    unless $facts['os']['name'] == 'SLES' or $facts['os']['name'] == 'Debian' or $facts['os']['name'] == 'Ubuntu' {
      apache::security::rule_link { $activated_rules: }
    }
  }
}
