# @summary
#   Installs `mod_socache_shmcb`.
#
# @see https://httpd.apache.org/docs/current/mod/mod_socache_shmcb.html for additional documentation.
#
class apache::mod::socache_shmcb {
    ::apache::mod { 'socache_shmcb': }
}
