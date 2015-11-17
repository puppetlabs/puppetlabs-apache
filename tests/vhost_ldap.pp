# Base class. Declares default vhost on port 80 and default ssl
# vhost on port 443 listening on all interfaces and serving
# $apache::docroot
class { 'apache': }

# location test
apache::vhost { 'location.example.net':
  docroot     => '/var/www/location',
  directories => [
    {
      'path'                     => '/location',
      'provider'                 => 'location',
      'auth_require'             => 'ldap-group cn=Administrators, o=Example'
      'auth_type'                => 'Basic',
      'auth_basic_provider'      => 'ldap',
      'auth_ldap_bind_dn'        => 'apache@example.com',
      'auth_ldap_bind_password'  => 'password',
      'auth_ldap_url'            => 'ldap://ldap.example.com/?userPrincipalName?sub',
    },
  ],
}
