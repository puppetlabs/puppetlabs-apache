# @summary
#   This class enables Apache mod_authn_file
# 
# See [`Apache mod_authn_file`](https://httpd.apache.org/docs/2.4/mod/mod_authn_file.html) 
# for more information.
class apache::mod::authn_file {
  ::apache::mod { 'authn_file': }
}
