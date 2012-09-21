define apache::mod::shib::sso(
	$directoryURL				= undef,
	$idpURL							= undef,
	$discoveryProtocol	= "SAMLDS"
){

	require apache::mod::shib

	if $discoveryURL and $idpURL {
		err("apache::mod::shib::sso must have one of discoveryURL or idpURL set, not both.")
	} elsif !$discoveryURL and !$idpURL {
		err("apache::mod::shib::sso must have one of discoveryURL or idpURL set, not neither.")
	} else {

		augeas{"shib_SPconfig_sso_entityID":
			lens		=> 'Xml.lns',
			incl		=> $shib_conf,
			context => "/files${shib_conf}/ApplicationDefaults/Sessions",
			changes => $idpURL ?{
				false 		=> ["rm SSO/#attribute/entityID",],
				default 	=> ["set SSO/#attribute/entityID ${idpURL}",],
			},
			notify	=> Service['httpd'],
		}

		augeas{"shib_SPconfig_sso_discoveryURL":
			lens		=> 'Xml.lns',
			incl		=> $shib_conf,
			context => "/files${shib_conf}/ApplicationDefaults/Sessions",
			changes => $discoveryURL ?{
				false 		=> ["rm SSO/#attribute/discoveryURL",],
				default 	=> ["set SSO/#attribute/discoveryURL ${discoveryURL}",],
			},
			notify	=> Service['httpd'],
		}

		augeas{"shib_SPconfig_sso_discoveryProtocol":
			lens		=> 'Xml.lns',
			incl		=> $shib_conf,
			context => "/files${shib_conf}/ApplicationDefaults/Sessions",
			changes => ["set SSO/#attribute/discoveryURL ${discoveryURL}",],
			notify	=> Service['httpd'],
		}
	}
}