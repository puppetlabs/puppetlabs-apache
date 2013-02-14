class apache::mod::passenger (
	$passengerhighperformance 	= off,
	$passengermaxpoolsize				= 6,
	$passengerpoolidletime			= 300,
	$passengermaxrequests				= 0,
	$passengerstatthrottlerate	= 0,
	$rackautodetect							= on,
	$railsautodetect						= on
) {
  include 'apache'

  # Could do some sanity checking of the parameters here.

  # you could just do this, but no options would be configured!
  apache::mod { 'passenger': }

  # The default passenger.conf file will run Passenger with the default
  # settings. This may not be suitable for production systems.

  file{"${apache::params::mod_dir}/passenger.conf":
  	ensure 	=> file,
  	content	=> template('apache/mod/passenger.conf.erb'),
  	notify 	=> Service['httpd'],
  	require	=> Apache::Mod['passenger'],
	}
}
