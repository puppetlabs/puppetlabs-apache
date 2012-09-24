# Currently this can only create a _single_ metadata provider
# it will need to be modified to permit multiple metadata providers
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

	# Get the Metadata signing certificate
	exec{'get_${name}_metadata_cert':
		path	=> ['/usr/bin'],
		command => "wget ${cert_uri} -O ${cert_file}",
		creates => $cert_file,
		notify	=> Service['httpd'],
	}

	# This puts the MetadataProvider entry in the 'right' place
	augeas{"shib_${name}_create_metadata_provider":
		lens		=> 'Xml.lns',
		incl		=> $apache::mod::shib::shib_conf,
		context => "/files${apache::mod::shib::shib_conf}/SPConfig/ApplicationDefaults",
		changes => [
			"ins MetadataProvider after Errors",
		],
		onlyif	=> 'match MetadataProvider/#attribute/uri size == 0',
		notify	=> Service['httpd'],
		require => Exec['get_${name}_metadata_cert'],
	}

	# This will update the attributes and child nodes if they change
	augeas{"shib_${name}_metadata_provider":
		lens		=> 'Xml.lns',
		incl		=> $apache::mod::shib::shib_conf,
		context => "/files${apache::mod::shib::shib_conf}/SPConfig/ApplicationDefaults",
		changes => [
			"set MetadataProvider/#attribute/type ${provider_type}",
			"set MetadataProvider/#attribute/uri ${provider_uri}",
			"set MetadataProvider/#attribute/backingFilePath ${backing_file}",
			"set MetadataProvider/#attribute/reloadInterva ${provider_reload_interval}",
			"set MetadataProvider/MetadataFilter[1]/#attribute/type RequireValidUntil",
			"set MetadataProvider/MetadataFilter[1]/#attribute/maxValidityInterval ${metadata_filter_max_validity_interval}",
			"set MetadataProvider/MetadataFilter[2]/#attribute/type Signature",
			"set MetadataProvider/MetadataFilter[2]/#attribute/certificate ${cert_file}",
		],
		notify	=> Service['httpd'],
		require => [Exec['get_${name}_metadata_cert'],Augeas["shib_${name}_create_metadata_provider"]],
	}

}