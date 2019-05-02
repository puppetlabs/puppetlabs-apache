# @summary
#   Installs `mod_suexec`.
#
# @see https://httpd.apache.org/docs/current/mod/mod_suexec.html for additional documentation.
#
class apache::mod::suexec {
  ::apache::mod { 'suexec': }
}
