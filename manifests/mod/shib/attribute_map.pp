define apache::mod::shib::attribute_map(
	$attribute_map_uri,
	$attribute_map_dir 	= $apache::mod::shib::shib_conf_dir,
	$attribute_map_name = inline_template("<%= attribute_map_uri.split('/').last  %>"),
	$max_age	= '21'
){

	require apache::mod::shib

	$attribute_map = "${attribute_map_dir}/${attribute_map_name}"

	# Download the attribute map, refresh after $max_age days
	exec{"get_${name}_attribute_map":
		path	=> ['/usr/bin'],
		command => "wget ${attribute_map_uri} -O ${attribute_map}",
		unless	=> "test `find ${attribute_map} -mtime +${max_age}`",
		notify	=> Service['httpd'],
	}

	# Make sure the shibboleth config is pointing at the attribute map
	augeas{"shib_${name}_attribute_map":
		lens		=> 'Xml.lns',
		incl		=> $apache::mod::shib::shib_conf,
		context => "/files${apache::mod::shib::shib_conf}/SPConfig/ApplicationDefaults",
		changes => [
			"set AttributeExtractor/#attribute/path ${attribute_map_name}",
		],
		notify	=> Service['httpd'],
		require => Exec["get_${name}_attribute_map"],
	}

}