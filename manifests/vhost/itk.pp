
define apache::vhost::itk (
  Hash $itk,
  Optional[String] $vhost                                                           = $name,
) {
  # Template uses:
  # - $itk
  # - $::kernelversion
  concat::fragment { "${vhost}-itk":
    target  => "apache::vhost::${vhost}",
    order   => 30,
    content => template('apache/vhost/_itk.erb'),
  }
}
