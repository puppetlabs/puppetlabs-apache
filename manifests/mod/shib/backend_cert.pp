class apache::mod::shib::backend_cert(
	$hostname		= $fqdn
){

	require apache::mod::shib

	# The test should not be that the file exists, but that the file has
	# the correct hostname in it
	exec{"shib_keygen_${hostname}":
		path 		=> $apache::mod::shib::shib_bin_dir,
		command	=> "shib-keygen -h ${hostname} -e https://${hostname}/shibbloeth",
		creates => "${apache::mod::shib::shib_conf_dir}/${apache::mod::shib::shib_sp_cert}",
	}
}