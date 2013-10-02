class apache::mod::fastcgi {
  apache::mod { 'fastcgi': 
    package => 'libapache2-mod-fastcgi'}
}
