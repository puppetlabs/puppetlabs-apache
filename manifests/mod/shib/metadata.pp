define apache::mod::shib::metadata(
	$provider_uri,
	$cert_uri,
	$backing_file_dir 				= $apache::mod::shib::shib_conf_dir,
	$backing_file_name 				= inline_template("<%= provider_uri.split('/').last  %>"),
	$cert_dir									= $apache::mod::shib::shib_conf_dir,
	$cert_file_name						= inline_template("<%= cert_uri.split('/').last  %>"),
	$provider_type						= 'XML',
	$provider_reload_interval	= "7200",
	$metadata_filter_max_validity_interval	= "2419200"	
){

	require apache::mod::shib

	$backing_file = "${backing_file_dir}/${backing_file_name}"
	$cert_file		= "${cert_dir}/${cert_file_name}"

	exec{'get_${name}_metadata_cert':
		path	=> ['/usr/bin'],
		command => "wget ${cert_uri} -O ${cert_file}",
		creates => $cert_file,
		notify	=> Service['httpd'],
	}

	augeas{"shib_${name}_metadata_provider":
		lens		=> 'Xml.lns',
		incl		=> $apache::mod::shib::shib_conf,
		context => "/files${apache::mod::shib::shib_conf}/SPConfig/ApplicationDefaults",
		changes => [
			"ins MetadataProvider[last()+1] after Errors",
			"set MetadataProvider[last()]/#attribute/type ${provider_type} ",
			"set MetadataProvider[last()]/#attribute/uri ${provider_uri}",
			"set MetadataProvider[last()]/#attribute/backingFilePath ${backing_file}",
			"set MetadataProvider[last()]/#attribute/reloadInterva ${provide_reload_interval}",
			"ins MetadataProvide[last()]/MetadataFilter[last()+1]"
			"set MetadataProvider[last()]/MetadataFilter[last()]/#attribute/type RequireValidUntil",
			"set MetadataProvider[last()]/MetadataFilter[last()]/#attribute/maxValidityInterval ${metadata_filter_max_validity_interval}",
			"ins MetadataProvide[last()]/MetadataFilter[last()+1]"
			"set MetadataProvider[last()]/MetadataFilter[last()]/#attribute/type Signature",
			"set MetadataProvider[last()]/MetadataFilter[last()]/#attribute/certificate ${cert_file}",
		],
		notify	=> Service['httpd'],
		require => Exec['get_${name}_metadata_cert'],
	}

}