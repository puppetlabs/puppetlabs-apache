class apache::mod::shib(
	$shib_admin			= $apache::serveradmin,
	$logoLocation		= "/shibboleth-sp/logo.jpg",
	$styleSheet			= "/shibboleth-sp/main.css",
	$shib_conf_dir	= '/etc/shibboleth',
	$shib_conf_file	= 'shibboleth2.xml'
){

	$shib_conf = "${shib_conf_dir}/${shib_conf_file}"
	$mod_shib = 'shib2'

	apache::mod {$mod_shib: }

	file{$shib_conf_dir:
		ensure	=> directory,
		require => Apache::Mod[$mod_shib]
	}

	file{$shib_conf:
		ensure	=> file,
		replace	=> false,
		require => [Apache::Mod[$mod_shib],File[$shib_conf_dir]],
	}

	augeas{"shib_SPconfig_errors":
		lens		=> 'Xml.lns',
		incl		=> $shib_conf,
		context => "/files${shib_conf}/SPConfig/ApplicationDefaults",
		changes => [
			"set Errors/#attribute/supportContact ${shib_admin}",
			"set Errors/#attribute/logoLocation ${logoLocation}",
			"set Errors/#attribute/styleSheet ${styleSheet}",
		]
	}

}