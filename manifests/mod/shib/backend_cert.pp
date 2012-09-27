class apache::mod::shib::backend_cert(
	$sp_hostname		= $fqdn
){

	require apache::mod::shib

	$sp_cert = "${apache::mod::shib::shib_conf_dir}/${apache::mod::shib::shib_sp_cert}"

	exec{"shib_keygen_${sp_hostname}":
		path 		=> [$apache::mod::shib::shib_bin_dir,'/usr/bin','/bin'],
		command	=> "shib-keygen -h ${sp_hostname} -e https://${sp_hostname}/shibbloeth",
		unless	=> "openssl x509 -noout -in ${sp_cert} -issuer|grep ${sp_hostname}",
	}
}