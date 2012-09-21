define apache::mod::shib::metadata(
	$provider_uri,
	$cert_uri,
	$backing_file_dir 	= $apache::mod::shib::shib_conf_dir,
	$backing_file_name 	= inline_template("<%= provider_uri.split('/').last  %>")
){

	require apache::mod::shib

	$backing_file = "${backing_file_dir}/${backing_file_name}"



}