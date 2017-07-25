
define apache::vhost::docroot (
  Optional[Variant[Boolean,String]] $docroot                                        = false,
  Optional[Variant[Boolean,String]] $virtual_docroot                                = false,
  Optional[String] $vhost                                                           = $name,
) {

  if $docroot == true {
    fail("Apache::Vhost::Docroot[${name}]: docroot parameter must either be a directory path or the boolean literal 'false'")
  }

  if $virtual_docroot == true {
    fail("Apache::Vhost::Docroot[${name}]: virtual_docroot parameter must either be a directory path or the boolean literal 'false'")
  }

  if !($docroot or $virtual_docroot) {
    fail("Apache::Vhost::Docroot[${name}]: Either docroot or virtual_docroot must be specified")
  }

  if $virtual_docroot {
    if ! defined(Class['apache::mod::vhost_alias']) {
      include ::apache::mod::vhost_alias
    }
  }

  # Template uses:
  # - $virtual_docroot
  # - $docroot
  concat::fragment { "${vhost}-docroot":
    target  => "apache::vhost::${vhost}",
    order   => 10,
    content => template('apache/vhost/_docroot.erb'),
  }
}
