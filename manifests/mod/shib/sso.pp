define apache::mod::shib::sso(
  $discoveryURL       = undef,
  $idpURL             = undef,
  $discoveryProtocol  = 'SAMLDS',
  $ecp_support        = false
){

  if $discoveryURL and $idpURL {
    err('apache::mod::shib::sso must have one of discoveryURL or idpURL set, not both.')
  } elsif !$discoveryURL and !$idpURL {
    err('apache::mod::shib::sso must have one of discoveryURL or idpURL set, not neither.')
  } else {

    if $idpURL {
      $entityID_aug = "set SSO/#attribute/entityID ${idpURL}"
    } else {
      $entityID_aug = 'rm SSO/#attribute/entityID'
    }

    if $discoveryURL {
      $discoveryURL_aug = "set SSO/#attribute/discoveryURL ${discoveryURL}"
    } else {
      $discoveryURL_aug = 'rm SSO/#attribute/discoveryURL'
    }

    augeas{"shib_sso_${name}_attributes":
      lens    => 'Xml.lns',
      incl    => $apache::mod::shib::shib_conf,
      context => "/files${apache::mod::shib::shib_conf}/SPConfig/ApplicationDefaults/Sessions",
      changes => [
        $entityID_aug,
        $discoveryURL_aug,
        "set SSO/#attribute/discoveryProtocol ${discoveryProtocol}",
        "set SSO/#attribute/ECP ${ecp_support}",
      ],
      notify  => Service['httpd','shibd'],
    }
  }
}