class apache::mod::shib(
  $shib_admin         = $apache::serveradmin,
  $shib_hostname      = $::fqdn,
  $logoLocation       = '/shibboleth-sp/logo.jpg',
  $styleSheet         = '/shibboleth-sp/main.css',
  $shib_conf_dir      = '/etc/shibboleth',
  $shib_conf_file     = 'shibboleth2.xml',
  $shib_sp_cert       = 'sp-cert.pem',
  $shib_bin_dir       = '/usr/sbin',
  $handlerSSL         = true,
  $consistent_address = true
){

  $shib_conf = "${shib_conf_dir}/${shib_conf_file}"
  $mod_shib = 'shib2'

  apache::mod {$mod_shib:
    id => 'mod_shib',
  }

  # by requiring the Apache::Mod, this should wait for the package
  # to create the directory and not need to manage it
  file{$shib_conf_dir:
    ensure  => 'directory',
    require => Apache::Mod[$mod_shib]
  }

  # by requiring the Apache::Mod, this will just define the file
  # created when installing the package.
  file{$shib_conf:
    ensure  => 'file',
    replace => false,
    require => [Apache::Mod[$mod_shib],File[$shib_conf_dir]],
  }

  # augeas should auto-require the file $shib_conf
  augeas{'shib_SPconfig_errors':
    lens    => 'Xml.lns',
    incl    => $shib_conf,
    context => "/files${shib_conf}/SPConfig/ApplicationDefaults",
    changes => [
      "set Errors/#attribute/supportContact ${shib_admin}",
      "set Errors/#attribute/logoLocation ${logoLocation}",
      "set Errors/#attribute/styleSheet ${styleSheet}",
    ],
    notify  => Service['httpd','shibd'],
  }

  augeas{'shib_SPconfig_consistent_address':
    lens    => 'Xml.lns',
    incl    => $shib_conf,
    context => "/files${shib_conf}/SPConfig/ApplicationDefaults",
    changes => [
      "set Sessions/#attribute/consistentAddress ${consistent_address}",
    ],
    notify  => Service['httpd','shibd'],
  }

  augeas{'shib_SPconfig_hostname':
    lens    => 'Xml.lns',
    incl    => $shib_conf,
    context => "/files${shib_conf}/SPConfig/ApplicationDefaults",
    changes => [
      "set #attribute/entityID https://${shib_hostname}/shibboleth",
      "set Sessions/#attribute/handlerURL https://${shib_hostname}/Shibboleth.sso",
    ],
    notify  => Service['httpd','shibd'],
  }

  augeas{'shib_SPconfig_handlerSSL':
    lens    => 'Xml.lns',
    incl    => $shib_conf,
    context => "/files${shib_conf}/SPConfig/ApplicationDefaults",
    changes => ["set Sessions/#attribute/handlerSSL ${handlerSSL}",],
    notify  => Service['httpd','shibd'],
  }

  service{'shibd':
    ensure      => 'running',
    enable      => true,
    hasrestart  => true,
    hasstatus   => true,
    require     => Apache::Mod[$mod_shib],
  }

}