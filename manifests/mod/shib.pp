class apache::mod::shib(
	$shib_admin			= $apache::serveradmin,
	$shib_conf_dir	= '/etc/shibboleth',
	$shib_conf_file	= 'shibboleth2.xml'
){

	$shib_conf = "${shib_conf_dir}/${shib_conf_file}"
	$mod_shib	 = $operatingsystem ? {
		Ubuntu	=> 'shib2',
	}

	require apache

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
}