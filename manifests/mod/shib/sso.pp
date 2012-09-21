define apache::mod::shib::sso(
	$discoveryURL				= undef,
	$idpURL							= undef,
	$discoveryProtocol	= "SAMLDS"
){

	require apache::mod::shib

	info("The shibboleth configuration file is ${apache::mod::shib::shib_conf}")

	if $discoveryURL and $idpURL {
		err("apache::mod::shib::sso must have one of discoveryURL or idpURL set, not both.")
	} elsif !$discoveryURL and !$idpURL {
		err("apache::mod::shib::sso must have one of discoveryURL or idpURL set, not neither.")
	} else {

		if $idpURL {
			$entityID_aug = "set SSO/#attribute/entityID ${idpURL}"
		} else {
			$entityID_aug = "rm SSO/#attribute/entityID"
		}

		info("The entityID augaes change is ${entityID_aug}")

		augeas{"shib_SPconfig_sso_entityID":
			lens		=> 'Xml.lns',
			incl		=> $apache::mod::shib::shib_conf,
			context => "/files${apache::mod::shib::shib_conf}/SPConfig/ApplicationDefaults/Sessions",
			changes => [$entityID_aug,],
			notify	=> Service['httpd'],
		}

		if $discoveryURL {
			$discoveryURL_aug = "set SSO/#attribute/discoveryURL ${discoveryURL}"
		} else {
			$discoveryURL_aug = "rm SSO/#attribute/discoveryURL"
		}

		info("The discoveryURL augeas change is ${discoveryURL_aug}")

		augeas{"shib_SPconfig_sso_discoveryURL":
			lens		=> 'Xml.lns',
			incl		=> $apache::mod::shib::shib_conf,
			context => "/files${apache::mod::shib::shib_conf}/SPConfig/ApplicationDefaults/Sessions",
			changes => [$discoveryURL_aug,],
			notify	=> Service['httpd'],
		}

		augeas{"shib_SPconfig_sso_discoveryProtocol":
			lens		=> 'Xml.lns',
			incl		=> $apache::mod::shib::shib_conf,
			context => "/files${apache::mod::shib::shib_conf}/SPConfig/ApplicationDefaults/Sessions",
			changes => ["set SSO/#attribute/discoveryProtocol ${discoveryProtocol}",],
			notify	=> Service['httpd'],
		}
	}
}