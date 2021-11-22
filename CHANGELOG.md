# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v7.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v7.0.0) (2021-10-11)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.5.1...v7.0.0)

### Changed

- Drop Debian \< 8 and Ubuntu \< 14.04 code [\#2189](https://github.com/puppetlabs/puppetlabs-apache/pull/2189) ([ekohl](https://github.com/ekohl))
- Drop support and compatibility for Debian \< 9 and Ubuntu \< 16.04 [\#2123](https://github.com/puppetlabs/puppetlabs-apache/pull/2123) ([ekohl](https://github.com/ekohl))

### Added

- pdksync - \(IAC-1751\) - Add Support for Rocky 8 [\#2196](https://github.com/puppetlabs/puppetlabs-apache/pull/2196) ([david22swan](https://github.com/david22swan))
- Allow `docroot` with `mod_vhost_alias` `virtual_docroot` [\#2195](https://github.com/puppetlabs/puppetlabs-apache/pull/2195) ([yakatz](https://github.com/yakatz))

### Fixed

- Restore Ubuntu 14.04 support in suphp [\#2193](https://github.com/puppetlabs/puppetlabs-apache/pull/2193) ([ekohl](https://github.com/ekohl))
- add double quote on scope parameter [\#2191](https://github.com/puppetlabs/puppetlabs-apache/pull/2191) ([aba-rechsteiner](https://github.com/aba-rechsteiner))
- Debian 11: fix typo in `versioncmp()` / set default php to 7.4 [\#2186](https://github.com/puppetlabs/puppetlabs-apache/pull/2186) ([bastelfreak](https://github.com/bastelfreak))

## [v6.5.1](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.5.1) (2021-08-25)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.5.0...v6.5.1)

### Fixed

- \(maint\) Allow stdlib 8.0.0 [\#2184](https://github.com/puppetlabs/puppetlabs-apache/pull/2184) ([smortex](https://github.com/smortex))

## [v6.5.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.5.0) (2021-08-24)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.4.0...v6.5.0)

### Added

- pdksync - \(IAC-1709\) - Add Support for Debian 11 [\#2180](https://github.com/puppetlabs/puppetlabs-apache/pull/2180) ([david22swan](https://github.com/david22swan))

## [v6.4.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.4.0) (2021-08-02)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.3.1...v6.4.0)

### Added

- \(MODULES-11075\) Improve future version handling for RHEL [\#2174](https://github.com/puppetlabs/puppetlabs-apache/pull/2174) ([mwhahaha](https://github.com/mwhahaha))
- Allow custom userdir directives [\#2164](https://github.com/puppetlabs/puppetlabs-apache/pull/2164) ([hunner](https://github.com/hunner))
- Add feature to reload apache service when content of ssl files has changed [\#2157](https://github.com/puppetlabs/puppetlabs-apache/pull/2157) ([timdeluxe](https://github.com/timdeluxe))

## [v6.3.1](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.3.1) (2021-07-22)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.3.0...v6.3.1)

### Fixed

- \(MODULES-10899\) Load php module with the right libphp file [\#2166](https://github.com/puppetlabs/puppetlabs-apache/pull/2166) ([sheenaajay](https://github.com/sheenaajay))
- \(maint\) Fix puppet-strings docs on apache::vhost [\#2165](https://github.com/puppetlabs/puppetlabs-apache/pull/2165) ([ekohl](https://github.com/ekohl))

## [v6.3.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.3.0) (2021-06-22)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/kps_ssl_reload_and_cache_disk_combined_tag...v6.3.0)

### Added

- The default disk\_cache.conf.erb caches everything.  [\#2142](https://github.com/puppetlabs/puppetlabs-apache/pull/2142) ([Pawa2NR](https://github.com/Pawa2NR))

### Fixed

- Update the default version of Apache for Amazon Linux 2 [\#2158](https://github.com/puppetlabs/puppetlabs-apache/pull/2158) ([turnopil](https://github.com/turnopil))
- Only warn about servername logging if relevant [\#2154](https://github.com/puppetlabs/puppetlabs-apache/pull/2154) ([ekohl](https://github.com/ekohl))

## [kps_ssl_reload_and_cache_disk_combined_tag](https://github.com/puppetlabs/puppetlabs-apache/tree/kps_ssl_reload_and_cache_disk_combined_tag) (2021-06-14)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.2.0...kps_ssl_reload_and_cache_disk_combined_tag)

## [v6.2.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.2.0) (2021-05-24)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.1.0...v6.2.0)

### Added

- \(MODULES-11068\) Allow apache::vhost ssl\_honorcipherorder to take boolean parameter [\#2152](https://github.com/puppetlabs/puppetlabs-apache/pull/2152) ([davidc](https://github.com/davidc))

## [v6.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.1.0) (2021-05-17)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.0.1...v6.1.0)

### Added

- support for uri for severname with use\_servername\_for\_filenames [\#2150](https://github.com/puppetlabs/puppetlabs-apache/pull/2150) ([Zarne](https://github.com/Zarne))
- \(MODULES-11061\) mod\_security custom rule functionality [\#2145](https://github.com/puppetlabs/puppetlabs-apache/pull/2145) ([k2patel](https://github.com/k2patel))

## [v6.0.1](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.0.1) (2021-05-10)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.0.0...v6.0.1)

### Fixed

- Fix HEADER\* and README\* wildcards in IndexIgnore [\#2138](https://github.com/puppetlabs/puppetlabs-apache/pull/2138) ([keto](https://github.com/keto))
- Fix dav\_svn for Debian 10 [\#2135](https://github.com/puppetlabs/puppetlabs-apache/pull/2135) ([martijndegouw](https://github.com/martijndegouw))

## [v6.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.0.0) (2021-03-02)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.10.0...v6.0.0)

### Changed

- pdksync - \(MAINT\) Remove SLES 11 support [\#2132](https://github.com/puppetlabs/puppetlabs-apache/pull/2132) ([sanfrancrisko](https://github.com/sanfrancrisko))
- pdksync - Remove Puppet 5 from testing and bump minimal version to 6.0.0 [\#2125](https://github.com/puppetlabs/puppetlabs-apache/pull/2125) ([carabasdaniel](https://github.com/carabasdaniel))

## [v5.10.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.10.0) (2021-02-17)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.9.0...v5.10.0)

### Added

- \(IAC-1186\) Add $use\_port\_for\_filenames parameter [\#2122](https://github.com/puppetlabs/puppetlabs-apache/pull/2122) ([smortex](https://github.com/smortex))

### Fixed

- \(MODULES-10899\) Handle PHP8 MOD package naming convention changes [\#2121](https://github.com/puppetlabs/puppetlabs-apache/pull/2121) ([sanfrancrisko](https://github.com/sanfrancrisko))

## [v5.9.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.9.0) (2021-01-25)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.8.0...v5.9.0)

### Added

- Add ssl\_user\_name vhost parameter [\#2093](https://github.com/puppetlabs/puppetlabs-apache/pull/2093) ([bodgit](https://github.com/bodgit))
- Add support for mod\_md [\#2090](https://github.com/puppetlabs/puppetlabs-apache/pull/2090) ([smortex](https://github.com/smortex))

### Fixed

- \(FIX\) Correct PHP packages on Ubuntu 16.04 [\#2111](https://github.com/puppetlabs/puppetlabs-apache/pull/2111) ([ekohl](https://github.com/ekohl))

## [v5.8.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.8.0) (2020-12-07)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.7.0...v5.8.0)

### Added

- \(MODULES-10887\) Set `use_servername_for_filenames` for defaults [\#2103](https://github.com/puppetlabs/puppetlabs-apache/pull/2103) ([towo](https://github.com/towo))
- pdksync - \(feat\) Add support for Puppet 7 [\#2101](https://github.com/puppetlabs/puppetlabs-apache/pull/2101) ([daianamezdrea](https://github.com/daianamezdrea))
- \(feat\) Add support for apreq2 MOD on Debian 9, 10 [\#2085](https://github.com/puppetlabs/puppetlabs-apache/pull/2085) ([TigerKriika](https://github.com/TigerKriika))

### Fixed

- \(fix\) Convert unnecessary multi line warnings to single lines [\#2104](https://github.com/puppetlabs/puppetlabs-apache/pull/2104) ([rj667](https://github.com/rj667))
- Fix bool2httpd function call for older ruby versions [\#2102](https://github.com/puppetlabs/puppetlabs-apache/pull/2102) ([carabasdaniel](https://github.com/carabasdaniel))
- Use Ruby 2.7 compatible string matching [\#2060](https://github.com/puppetlabs/puppetlabs-apache/pull/2060) ([ekohl](https://github.com/ekohl))

## [v5.7.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.7.0) (2020-11-24)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.6.0...v5.7.0)

### Added

- Add cas\_cookie\_path in vhosts [\#2089](https://github.com/puppetlabs/puppetlabs-apache/pull/2089) ([yakatz](https://github.com/yakatz))
- \(IAC-1186\) Add new $use\_servername\_for\_filenames parameter [\#2086](https://github.com/puppetlabs/puppetlabs-apache/pull/2086) ([sanfrancrisko](https://github.com/sanfrancrisko))
- Allow relative paths in oidc\_redirect\_uri [\#2082](https://github.com/puppetlabs/puppetlabs-apache/pull/2082) ([sanfrancrisko](https://github.com/sanfrancrisko))
- Improve SSLVerify options [\#2081](https://github.com/puppetlabs/puppetlabs-apache/pull/2081) ([bovy89](https://github.com/bovy89))
- Change icon path [\#2079](https://github.com/puppetlabs/puppetlabs-apache/pull/2079) ([yakatz](https://github.com/yakatz))
- Support mod\_auth\_gssapi parameters [\#2078](https://github.com/puppetlabs/puppetlabs-apache/pull/2078) ([traylenator](https://github.com/traylenator))
- Add ssl\_proxy\_machine\_cert\_chain param to vhost class [\#2072](https://github.com/puppetlabs/puppetlabs-apache/pull/2072) ([AbelNavarro](https://github.com/AbelNavarro))

### Fixed

- Use Ruby 2.7 compatible string matching [\#2074](https://github.com/puppetlabs/puppetlabs-apache/pull/2074) ([sanfrancrisko](https://github.com/sanfrancrisko))

## [v5.6.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.6.0) (2020-10-01)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.5.0...v5.6.0)

### Added

- Configure default shared lib path for mod\_wsgi on RHEL8 [\#2063](https://github.com/puppetlabs/puppetlabs-apache/pull/2063) ([nbarrientos](https://github.com/nbarrientos))
- Various enhancements to apache::mod::passenger [\#2058](https://github.com/puppetlabs/puppetlabs-apache/pull/2058) ([smortex](https://github.com/smortex))

### Fixed

- make apache::mod::fcgid redhat 8 compatible [\#2071](https://github.com/puppetlabs/puppetlabs-apache/pull/2071) ([creativefre](https://github.com/creativefre))
- pdksync - \(feat\) - Removal of inappropriate terminology [\#2062](https://github.com/puppetlabs/puppetlabs-apache/pull/2062) ([pmcmaw](https://github.com/pmcmaw))
- Use python3-mod\_wsgi instead of mod\_wsgi on CentOS8 [\#2052](https://github.com/puppetlabs/puppetlabs-apache/pull/2052) ([kajinamit](https://github.com/kajinamit))

## [v5.5.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.5.0) (2020-07-03)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.4.0...v5.5.0)

### Added

- Allow IPv6 CIDRs for proxy\_protocol\_exceptions in mod remoteip [\#2033](https://github.com/puppetlabs/puppetlabs-apache/pull/2033) ([thechristschn](https://github.com/thechristschn))
- \(IAC-746\) - Add ubuntu 20.04 support [\#2032](https://github.com/puppetlabs/puppetlabs-apache/pull/2032) ([david22swan](https://github.com/david22swan))
- Replace legacy `bool2httpd()` function with shim [\#2025](https://github.com/puppetlabs/puppetlabs-apache/pull/2025) ([alexjfisher](https://github.com/alexjfisher))
- Tidy up `pw_hash` function [\#2024](https://github.com/puppetlabs/puppetlabs-apache/pull/2024) ([alexjfisher](https://github.com/alexjfisher))
- Replace validate\_apache\_loglevel\(\) with data type [\#2023](https://github.com/puppetlabs/puppetlabs-apache/pull/2023) ([alexjfisher](https://github.com/alexjfisher))
- Add ProxyIOBufferSize option [\#2014](https://github.com/puppetlabs/puppetlabs-apache/pull/2014) ([jplindquist](https://github.com/jplindquist))
- Add support for SetInputFilter directive [\#2007](https://github.com/puppetlabs/puppetlabs-apache/pull/2007) ([HoucemEddine](https://github.com/HoucemEddine))
- \[MODULES-10530\] Add request limiting directives on virtual host level [\#1996](https://github.com/puppetlabs/puppetlabs-apache/pull/1996) ([aursu](https://github.com/aursu))
- \[MODULES-10528\] Add ErrorLogFormat directive on virtual host level [\#1995](https://github.com/puppetlabs/puppetlabs-apache/pull/1995) ([aursu](https://github.com/aursu))
- Add template variables and parameters for ModSecurity Audit Logs [\#1988](https://github.com/puppetlabs/puppetlabs-apache/pull/1988) ([jplindquist](https://github.com/jplindquist))
- \(MODULES-10432\) Add mod\_auth\_openidc support [\#1987](https://github.com/puppetlabs/puppetlabs-apache/pull/1987) ([asieraguado](https://github.com/asieraguado))

### Fixed

- \(MODULES-10712\) Fix mod\_ldap on RH/CentOS 5 and 6 [\#2041](https://github.com/puppetlabs/puppetlabs-apache/pull/2041) ([h-haaks](https://github.com/h-haaks))
- Update mod\_dir, alias\_icons\_path, error\_documents\_path for CentOS 8 [\#2038](https://github.com/puppetlabs/puppetlabs-apache/pull/2038) ([initrd](https://github.com/initrd))
- Ensure switching of thread module works on Debian 10 / Ubuntu 20.04 [\#2034](https://github.com/puppetlabs/puppetlabs-apache/pull/2034) ([tuxmea](https://github.com/tuxmea))
- MODULES-10586 Centos 8: wrong package used to install mod\_authnz\_ldap [\#2021](https://github.com/puppetlabs/puppetlabs-apache/pull/2021) ([farebers](https://github.com/farebers))
- Re-add package for fcgid on debian/ubuntu machines [\#2006](https://github.com/puppetlabs/puppetlabs-apache/pull/2006) ([vStone](https://github.com/vStone))
- Use ldap\_trusted\_mode in conditional [\#1999](https://github.com/puppetlabs/puppetlabs-apache/pull/1999) ([dacron](https://github.com/dacron))
- Typo in oidcsettings.pp [\#1997](https://github.com/puppetlabs/puppetlabs-apache/pull/1997) ([asieraguado](https://github.com/asieraguado))
- Fix proxy\_html Module to work on Debian 10 [\#1994](https://github.com/puppetlabs/puppetlabs-apache/pull/1994) ([buchstabensalat](https://github.com/buchstabensalat))
- \(MODULES-10360\) Fix icon paths for RedHat systems [\#1991](https://github.com/puppetlabs/puppetlabs-apache/pull/1991) ([2and3makes23](https://github.com/2and3makes23))
- SSLProxyEngine on has to be set before any Proxydirective using it [\#1989](https://github.com/puppetlabs/puppetlabs-apache/pull/1989) ([zivis](https://github.com/zivis))

## [v5.4.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.4.0) (2020-01-22)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.3.0...v5.4.0)

### Added

- Add an apache::vhost::fragment define [\#1980](https://github.com/puppetlabs/puppetlabs-apache/pull/1980) ([ekohl](https://github.com/ekohl))

### Fixed

- \(MODULES-10391\) ssl\_protocol includes SSLv2 and SSLv3 on all platforms [\#1990](https://github.com/puppetlabs/puppetlabs-apache/pull/1990) ([legooolas](https://github.com/legooolas))

## [v5.3.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.3.0) (2019-12-11)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.2.0...v5.3.0)

### Added

- \(FM-8672\) - Addition of Support for CentOS 8 [\#1977](https://github.com/puppetlabs/puppetlabs-apache/pull/1977) ([david22swan](https://github.com/david22swan))
- \(MODULES-9948\) Allow switching of thread modules [\#1961](https://github.com/puppetlabs/puppetlabs-apache/pull/1961) ([tuxmea](https://github.com/tuxmea))

### Fixed

- Fix newline being added before proxy params [\#1984](https://github.com/puppetlabs/puppetlabs-apache/pull/1984) ([oxc](https://github.com/oxc))
- When using mod jk, we expect the libapache2-mod-jk package to be installed [\#1979](https://github.com/puppetlabs/puppetlabs-apache/pull/1979) ([tuxmea](https://github.com/tuxmea))
- move unless into manage\_security\_corerules [\#1976](https://github.com/puppetlabs/puppetlabs-apache/pull/1976) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- Change mod\_proxy's ProxyTimeout to follow Apache's global timeout [\#1975](https://github.com/puppetlabs/puppetlabs-apache/pull/1975) ([gcoxmoz](https://github.com/gcoxmoz))
- \(FM-8721\) fix php version and ssl error on redhat8 [\#1973](https://github.com/puppetlabs/puppetlabs-apache/pull/1973) ([sheenaajay](https://github.com/sheenaajay))

## [v5.2.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.2.0) (2019-11-01)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.1.0...v5.2.0)

### Added

- Add parameter version for mod security [\#1953](https://github.com/puppetlabs/puppetlabs-apache/pull/1953) ([tuxmea](https://github.com/tuxmea))
- add possibility to define variables inside VirtualHost definition [\#1947](https://github.com/puppetlabs/puppetlabs-apache/pull/1947) ([trefzer](https://github.com/trefzer))

### Fixed

- \(FM-8662\) Correction in manifests/mod/ssl.pp for SLES 11 [\#1963](https://github.com/puppetlabs/puppetlabs-apache/pull/1963) ([sanfrancrisko](https://github.com/sanfrancrisko))
- always quote ExpiresDefault in vhost::directories [\#1958](https://github.com/puppetlabs/puppetlabs-apache/pull/1958) ([evgeni](https://github.com/evgeni))
- MODULES-9904 Fix lbmethod module load order [\#1956](https://github.com/puppetlabs/puppetlabs-apache/pull/1956) ([optiz0r](https://github.com/optiz0r))
- Add owner, group, file\_mode and show\_diff to apache::custom\_config [\#1942](https://github.com/puppetlabs/puppetlabs-apache/pull/1942) ([treydock](https://github.com/treydock))
- Add shibboleth support for Debian 10 [\#1939](https://github.com/puppetlabs/puppetlabs-apache/pull/1939) ([fabbks](https://github.com/fabbks))

## [v5.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.1.0) (2019-09-13)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.0.0...v5.1.0)

### Added

- \(FM-8393\) add support on Debian 10 [\#1945](https://github.com/puppetlabs/puppetlabs-apache/pull/1945) ([ThoughtCrhyme](https://github.com/ThoughtCrhyme))
- FM-8140 Add Redhat 8 support [\#1941](https://github.com/puppetlabs/puppetlabs-apache/pull/1941) ([sheenaajay](https://github.com/sheenaajay))
- \(FM-8214\) converted to use litmus [\#1938](https://github.com/puppetlabs/puppetlabs-apache/pull/1938) ([tphoney](https://github.com/tphoney))
- \(MODULES-9668 \) Please make ProxyRequests setting in vhost.pp configurable [\#1935](https://github.com/puppetlabs/puppetlabs-apache/pull/1935) ([aukesj](https://github.com/aukesj))
- Added unmanaged\_path and custom\_fragment options to userdir [\#1931](https://github.com/puppetlabs/puppetlabs-apache/pull/1931) ([GeorgeCox](https://github.com/GeorgeCox))
- Add LDAP parameters to httpd.conf [\#1930](https://github.com/puppetlabs/puppetlabs-apache/pull/1930) ([daveseff](https://github.com/daveseff))
- Add LDAPReferrals configuration parameter [\#1928](https://github.com/puppetlabs/puppetlabs-apache/pull/1928) ([HT43-bqxFqB](https://github.com/HT43-bqxFqB))

### Fixed

- \(MODULES-9104\) Add file\_mode to config files. [\#1922](https://github.com/puppetlabs/puppetlabs-apache/pull/1922) ([stevegarn](https://github.com/stevegarn))
- \(bugfix\) Add default package name for mod\_ldap [\#1913](https://github.com/puppetlabs/puppetlabs-apache/pull/1913) ([turnopil](https://github.com/turnopil))
- Remove event mpm when using prefork, worker or itk [\#1905](https://github.com/puppetlabs/puppetlabs-apache/pull/1905) ([tuxmea](https://github.com/tuxmea))

## [v5.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.0.0) (2019-05-20)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/4.1.0...v5.0.0)

### Changed

- pdksync - \(MODULES-8444\) - Raise lower Puppet bound [\#1908](https://github.com/puppetlabs/puppetlabs-apache/pull/1908) ([david22swan](https://github.com/david22swan))

### Added

- \(FM-7923\) Implement Puppet Strings [\#1916](https://github.com/puppetlabs/puppetlabs-apache/pull/1916) ([eimlav](https://github.com/eimlav))
- Define SCL package name for mod\_ldap [\#1893](https://github.com/puppetlabs/puppetlabs-apache/pull/1893) ([treydock](https://github.com/treydock))

### Fixed

- \(MODULES-9014\) Improve SSLSessionTickets handling [\#1923](https://github.com/puppetlabs/puppetlabs-apache/pull/1923) ([FredericLespez](https://github.com/FredericLespez))
- \(MODULES-8931\) Fix stahnma/epel failures [\#1914](https://github.com/puppetlabs/puppetlabs-apache/pull/1914) ([eimlav](https://github.com/eimlav))
- Fix wsgi\_daemon\_process to support hash data type [\#1884](https://github.com/puppetlabs/puppetlabs-apache/pull/1884) ([mdechiaro](https://github.com/mdechiaro))

## [4.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/4.1.0) (2019-04-05)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/4.0.0...4.1.0)

### Added

- \(MODULES-7196\) Allow setting CASRootProxiedAs per virtualhost \(replaces \#1857\) [\#1900](https://github.com/puppetlabs/puppetlabs-apache/pull/1900) ([Lavinia-Dan](https://github.com/Lavinia-Dan))
- \(feat\) - Amazon Linux 2 compatibility added [\#1898](https://github.com/puppetlabs/puppetlabs-apache/pull/1898) ([david22swan](https://github.com/david22swan))
- \(MODULES-8731\) Allow CIDRs for proxy\_ips/internal\_proxy in remoteip [\#1891](https://github.com/puppetlabs/puppetlabs-apache/pull/1891) ([JAORMX](https://github.com/JAORMX))
- Manage all mod\_remoteip parameters supported by Apache [\#1882](https://github.com/puppetlabs/puppetlabs-apache/pull/1882) ([johanfleury](https://github.com/johanfleury))
- MODULES-8541 : Allow HostnameLookups to be modified [\#1881](https://github.com/puppetlabs/puppetlabs-apache/pull/1881) ([k2patel](https://github.com/k2patel))
- Add support for mod\_http2 [\#1867](https://github.com/puppetlabs/puppetlabs-apache/pull/1867) ([smortex](https://github.com/smortex))
- Added code to paramertize the libphp prefix [\#1852](https://github.com/puppetlabs/puppetlabs-apache/pull/1852) ([grahamuk2018](https://github.com/grahamuk2018))
- Added WSGI Options WSGIApplicationGroup and WSGIPythonOptimize [\#1847](https://github.com/puppetlabs/puppetlabs-apache/pull/1847) ([emetriqLikedeeler](https://github.com/emetriqLikedeeler))

### Fixed

- \(bugfix\) set kernel for facter version test [\#1895](https://github.com/puppetlabs/puppetlabs-apache/pull/1895) ([tphoney](https://github.com/tphoney))
- \(MODULES-5990\) - Managing conf\_enabled [\#1875](https://github.com/puppetlabs/puppetlabs-apache/pull/1875) ([david22swan](https://github.com/david22swan))

## [4.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/4.0.0) (2019-01-10)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/3.5.0...4.0.0)

### Changed

- default server\_tokens to prod - more secure default [\#1746](https://github.com/puppetlabs/puppetlabs-apache/pull/1746) ([juju4](https://github.com/juju4))

### Added

- \(Modules 8141/Modules 8379\) - Addition of support for SLES 15 [\#1862](https://github.com/puppetlabs/puppetlabs-apache/pull/1862) ([david22swan](https://github.com/david22swan))
- SCL support for httpd and php7.1 [\#1822](https://github.com/puppetlabs/puppetlabs-apache/pull/1822) ([mmoll](https://github.com/mmoll))

### Fixed

- \(MODULES-5990\) - conf-enabled defaulted to undef [\#1869](https://github.com/puppetlabs/puppetlabs-apache/pull/1869) ([david22swan](https://github.com/david22swan))
- pdksync - \(FM-7655\) Fix rubygems-update for ruby \< 2.3 [\#1866](https://github.com/puppetlabs/puppetlabs-apache/pull/1866) ([tphoney](https://github.com/tphoney))

## [3.5.0](https://github.com/puppetlabs/puppetlabs-apache/tree/3.5.0) (2018-12-17)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/3.4.0...3.5.0)

### Added

- \(MODULES-5990\) Addition of 'IncludeOptional conf-enabled/\*.conf' to apache2.conf' on Debian Family OS [\#1851](https://github.com/puppetlabs/puppetlabs-apache/pull/1851) ([david22swan](https://github.com/david22swan))
- \(MODULES-8107\) - Support added for Ubuntu 18.04. [\#1850](https://github.com/puppetlabs/puppetlabs-apache/pull/1850) ([david22swan](https://github.com/david22swan))
- \(MODULES-8108\) - Support added for Debian 9 [\#1849](https://github.com/puppetlabs/puppetlabs-apache/pull/1849) ([david22swan](https://github.com/david22swan))
- Add option to add comments to the header of a vhost file [\#1841](https://github.com/puppetlabs/puppetlabs-apache/pull/1841) ([jovandeginste](https://github.com/jovandeginste))

### Fixed

- \(FM-7605\) - Disabling conf\_enabled on Ubuntu 18.04  by default as it conflicts with Shibboleth causing errors with apache2. [\#1856](https://github.com/puppetlabs/puppetlabs-apache/pull/1856) ([david22swan](https://github.com/david22swan))
- \(MODULES-8429\) Update GPG key for phusion passenger [\#1848](https://github.com/puppetlabs/puppetlabs-apache/pull/1848) ([abottchen](https://github.com/abottchen))
- Fix default vhost priority in readme [\#1843](https://github.com/puppetlabs/puppetlabs-apache/pull/1843) ([HT43-bqxFqB](https://github.com/HT43-bqxFqB))
- fix apache::mod::jk example typo and add link for more info [\#1812](https://github.com/puppetlabs/puppetlabs-apache/pull/1812) ([xorpaul](https://github.com/xorpaul))
- MODULES-7379: Fixing syntax by adding newline [\#1803](https://github.com/puppetlabs/puppetlabs-apache/pull/1803) ([wimvr](https://github.com/wimvr))
- ensure mpm\_event is disabled under debian 9 if mpm itk is used [\#1766](https://github.com/puppetlabs/puppetlabs-apache/pull/1766) ([zivis](https://github.com/zivis))

## [3.4.0](https://github.com/puppetlabs/puppetlabs-apache/tree/3.4.0) (2018-09-27)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/3.3.0...3.4.0)

### Added

- pdksync - \(FM-7392\) - Puppet 6 Testing Changes [\#1838](https://github.com/puppetlabs/puppetlabs-apache/pull/1838) ([pmcmaw](https://github.com/pmcmaw))
- pdksync - \(MODULES-6805\) metadata.json shows support for puppet 6 [\#1836](https://github.com/puppetlabs/puppetlabs-apache/pull/1836) ([tphoney](https://github.com/tphoney))

### Fixed

- Fix "audit\_log\_relevant\_status" typo in README.md [\#1830](https://github.com/puppetlabs/puppetlabs-apache/pull/1830) ([smokris](https://github.com/smokris))

## [3.3.0](https://github.com/puppetlabs/puppetlabs-apache/tree/3.3.0) (2018-09-11)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/3.2.0...3.3.0)

### Added

- pdksync - \(MODULES-7705\) - Bumping stdlib dependency from \< 5.0.0 to \< 6.0.0 [\#1821](https://github.com/puppetlabs/puppetlabs-apache/pull/1821) ([pmcmaw](https://github.com/pmcmaw))
- Add support for ProxyTimeout [\#1805](https://github.com/puppetlabs/puppetlabs-apache/pull/1805) ([agoodno](https://github.com/agoodno))
- \(MODULES-7343\) - Allow overrides by adding mod\_libs in apache class [\#1800](https://github.com/puppetlabs/puppetlabs-apache/pull/1800) ([karelyatin](https://github.com/karelyatin))
- Rework passenger VHost and Directories [\#1778](https://github.com/puppetlabs/puppetlabs-apache/pull/1778) ([smortex](https://github.com/smortex))

### Fixed

- MODULES-7575 reverse sort the aliases [\#1808](https://github.com/puppetlabs/puppetlabs-apache/pull/1808) ([k2patel](https://github.com/k2patel))
- fixes for OpenSUSE ans SLES [\#1783](https://github.com/puppetlabs/puppetlabs-apache/pull/1783) ([tuxmea](https://github.com/tuxmea))

## 3.2.0
### Summary
This is a clean release to prepare for several planned backwards incompatible changes.

#### Changed
- Parameter `passenger_pre_start` has been moved outside of `<VirtualHost>`.
- Apache version fact has been enabled on FreeBSD.
- Parameter `ssl_proxyengine` has had it's default changed to false.

#### Added
- Parameter `passenger_group` can now be set in `apache::vhost`.
- Multiple `passenger_pre_start` URIs can now be set at once.
- Manifest `mod::auth_gssapi` has been added to allow the deployment of authorisation with kerberos, through GSSAPI.

#### Removed
- Scientific 5 and Debian 7 are no longer supported on Apache.

## Supported Release [3.1.0]
### Summary
This release includes the module being converted using version 1.4.1 of the PDK. It also includes a couple of additional parameters added.

#### Added
- Module has been pdk converted with version 1.4.1 ([MODULES-6331](https://tickets.puppet.com/browse/MODULES-6331))
- Parameter `ssl_cert` to provide a SSLCertificateFile option for use with SSL, optional of type String.
- Parameter `ssl_key` to provide a SSLCertificateKey option for use with SSL, optional of type String.

#### Fixed
- Documentation updates.
- Updates to the Japanese translation based on documentation update.

## Supported Release [3.0.0]
### Summary
This major release changes the default value of `keepalive` to `On`. It also includes many other features and bugfixes.

#### Changed
- Default `apache::keepalive` from `Off` to `On`.

#### Added
- Class `apache::mod::data`
- Function `apache::apache_pw_hash` function (puppet 4 port of `apache_pw_hash()`)
- Function `apache::bool2httpd` function (puppet 4 port of `bool2httpd()`)
- Function `apache::validate_apache_log_level` function (puppet 4 port of `validate_apache_log_level()`)
- Parameter `apache::balancer::options` for additional directives.
- Parameter `apache::limitreqfields` setting the LimitRequestFields directive to 100.
- Parameter `apache::use_canonical_name` to control how httpd uses self-referential URLs.
- Parameter `apache::mod::disk_cache::cache_ignore_headers` to ignore cache headers.
- Parameter `apache::mod::itk::enablecapabilities` to manage ITK capabilities.
- Parameter `apache::mod::ldap::ldap_trusted_mode` to manage trusted mode.
- Parameters for `apache::mod::passenger`:
  - `passenger_allow_encoded_slashes`
  - `passenger_app_group_name`
  - `passenger_app_root`
  - `passenger_app_type`
  - `passenger_base_uri`
  - `passenger_buffer_response`
  - `passenger_buffer_upload`
  - `passenger_concurrency_model`
  - `passenger_debug_log_file`
  - `passenger_debugger`
  - `passenger_default_group`
  - `passenger_default_user`
  - `passenger_disable_security_update_check`
  - `passenger_enabled`
  - `passenger_error_override`
  - `passenger_file_descriptor_log_file`
  - `passenger_fly_with`
  - `passenger_force_max_concurrent_requests_per_process`
  - `passenger_friendly_error_pages`
  - `passenger_group`
  - `passenger_installed_version`
  - `passenger_instance_registry_dir`
  - `passenger_load_shell_envvars`
  - `passenger_lve_min_uid`
  - `passenger_max_instances`
  - `passenger_max_preloader_idle_time`
  - `passenger_max_request_time`
  - `passenger_memory_limit`
  - `passenger_meteor_app_settings`
  - `passenger_nodejs`
  - `passenger_pre_start`
  - `passenger_python`
  - `passenger_resist_deployment_errors`
  - `passenger_resolve_symlinks_in_document_root`
  - `passenger_response_buffer_high_watermark`
  - `passenger_restart_dir`
  - `passenger_rolling_restarts`
  - `passenger_security_update_check_proxy`
  - `passenger_show_version_in_header`
  - `passenger_socket_backlog`
  - `passenger_start_timeout`
  - `passenger_startup_file`
  - `passenger_sticky_sessions`
  - `passenger_sticky_sessions_cookie_name`
  - `passenger_thread_count`
  - `passenger_user`
  - `passenger_user_switching`
  - `rack_auto_detect`
  - `rack_base_uri`
  - `rack_env`
  - `rails_allow_mod_rewrite`
  - `rails_app_spawner_idle_time`
  - `rails_auto_detect`
  - `rails_base_uri`
  - `rails_default_user`
  - `rails_env`
  - `rails_framework_spawner_idle_time`
  - `rails_ruby`
  - `rails_spawn_method`
  - `rails_user_switching`
  - `wsgi_auto_detect`
- Parameter `apache::mod::prefork::listenbacklog` to set the listen backlog to 511.
- Parameter `apache::mod::python::loadfile_name` to workaround python.load filename conflicts.
- Parameter `apache::mod::ssl::ssl_cert` to manage the client auth cert.
- Parameter `apache::mod::ssl::ssl_key` to manage the client auth key.
- Parameter `apache::mod::status::requires` as an alternative to `apache::mod::status::allow_from`
- Parameter `apache::vhost::ssl_proxy_cipher_suite` to manage that directive.
- Parameter `apache::vhost::shib_compat_valid_user` to manage that directive.
- Parameter `apache::vhost::use_canonical_name` to manage that directive.
- Parameter value `mellon_session_length` for `apache::vhost::directories`

### Fixed
- `apache_version` is confined to just Linux to avoid erroring on AIX.
- Parameter `apache::mod::jk::workers_file_content` docs typo of "mantain" instead of maintain.
- Deduplicate `apache::mod::ldap` managing `File['ldap.conf']` to avoid resource conflicts.
- ITK package name on Debian 9
- Dav_svn package for SLES
- Log client IP instead of loadbalancer IP when behind a loadbalancer.
- `apache::mod::remoteip` now notifies the `Class['apache::service']` class instead of `Service['httpd']` to avoid restarting the service when `apache::service_manage` is false.
- `apache::vhost::cas_scrub_request_headers` actually manages the directive.

## Supported Release [2.3.1]
### Summary
This release fixes CVE-2018-6508 which is a potential arbitrary code execution via tasks.

### Fixed
- Fix init task for arbitrary remote code

## Supported Release [2.3.0]
### Summary
This is a feature release. It includes a task that will reload the apache service.

#### Added
- Add a task that allows the reloading of the Apache service.

## Supported Release [2.2.0]
### Summary
This is a maintainence and feature release. It will include updates to translations in Japanese, some maintainence and adding `PassengerSpawnMethod` to vhost.

#### Added
- `PassengerSpawnMethod` added to `vhost`.

#### Changed
- Improve version match fact for `apache_version`
- Update to prefork.conf params for Apache 2.4
- Updates to `CONTRIBUTING.md`
- Do not install mod_fastcgi on el7
- Include mod_wsgi when using wsgi options

## Supported Release [2.1.0]
### Summary
This is a feature release including a security patch (CVE-2017-2299)

#### Added
- `apache::mod::jk` class for managing the mod_jk connector
- `apache_pw_hash` function
- the ProxyPass directive in location contexts
- more Puppet 4 type validation
- `apache::mod::macro` class for managing mod_macro

#### Changed
- $ssl_certs_dir default to `undef` for all platorms
- $ssl_verify_client must now be set to use any of the following: `$ssl_certs_dir`, `$ssl_ca`, `$ssl_crl_path`, `$ssl_crl`, `$ssl_verify_depth`, `$ssl_crl_check`

#### Fixed
- issue where mod_alias was not being loaded when RedirectMatch* directives were being used ([MODULES-3942](https://tickets.puppet.com/browse/MODULES-3942))
- issue with `$directories` parameter in `apache::vhost`
- issue in UserDir template where the UserDir path did not match the Directory path
- **Issue where the $ssl_certs_dir default set Apache to implicitly trust all client certificates that were issued by any CA in that directory**

#### Removed
- support for EOL platforms: Ubuntu 10.04, 12.04 and Debian 6 (Squeeze)

## Supported Release [2.0.0]
### Summary
Major release **removing Puppet 3 support** and other backwards-incompatible changes.

#### Added
- support for FileETag directive configurable with the `file_e_tag` parameter
- ability to configure multiple ports per vhost
- RequestHeader directive to vhost template ([MODULES-4156](https://tickets.puppet.com/browse/MODULES-4156))
- customizability for AllowOverride directive in userdir.conf ([MODULES-4516](https://tickets.puppet.com/browse/MODULES-4516))
- AdvertiseFrequency directive for cluster.conf ([MODULES-4500](https://tickets.puppet.com/browse/MODULES-4500))
- `ssl_proxy_protocol` and `ssl_sessioncache` parameters for mod::ssl ([MODULES-4737](https://tickets.puppet.com/browse/MODULES-4737))
- SSLCACertificateFile directive in ssl.conf configurable with `ssl_ca` parameter
- mod::authnz_pam 
- mod::intercept_form_submit 
- mod::lookup_identity
- Suse compatibility for mod::proxy_html
- support for AddCharset directive configurable with `add_charset` parameter
- support for SSLProxyVerifyDepth and SSLProxyCACertificateFile directives configurable with `ssl_proxy_verify_depth` and `ssl_proxy_ca_cert` respectively
- `manage_security_crs` parameter for mod::security
- support for LimitExcept directive configurable with `limit_except` parameter
- support for WSGIRestrictEmbedded directive configurable with `wsgi_restrict_embedded` parameter
- support for custom UserDir path ([MODULES-4933](https://tickets.puppet.com/browse/MODULES-4933))
- support for PassengerMaxRequests directive configurable with `passenger_max_requests`
- option to override module package names with `mod_packages` parameter ([MODULES-3838](https://tickets.puppet.com/browse/MODULES-3838))

#### Removed
- enclose_ipv6 as it was added to puppetlabs-stdlib
- deprecated `$verifyServerCert` parameter from the `apache::mod::authnz_ldap` class ([MODULES-4445](https://tickets.puppet.com/browse/MODULES-4445))

#### Changed
- `keepalive` default to 'On' from 'Off'
- Puppet version compatibility to ">= 4.7.0 < 6.0.0"
- puppetlabs-stdlib dependency to ">= 4.12.0 < 5.0.0"
- `ssl_cipher` to explicitly disable 3DES because of Sweet32

#### Fixed
- various issues in the vhost template
- use of deprecated `include_src` parameter in vhost_spec
- management of ssl.conf on RedHat systems
- various SLES/Suse params
- mod::cgi ordering for FreeBSD
- issue where ProxyPreserveHost could not be set without other Proxy* directives
- the module attempting to install proxy_html on Ubuntu Xenial and Debian Stretch

## Supported Release [1.11.1]
#### Summary
This is a security patch release (CVE-2017-2299). These changes are also in version 2.1.0 and higher.

#### Changed
- $ssl_certs_dir default to `undef` for all platorms
- $ssl_verify_client must now be set to use any of the following: `$ssl_certs_dir`, `$ssl_ca`, `$ssl_crl_path`, `$ssl_crl`, `$ssl_verify_depth`, `$ssl_crl_check`

#### Fixed
- **Issue where the $ssl_certs_dir default set Apache to implicitly trust all client certificates that were issued by any CA in that directory** ([MODULES-5471](https://tickets.puppet.com/browse/MODULES-5471))

## Supported Release [1.11.0]
### Summary
This release adds SLES12 Support and many more features and bugfixes.

#### Features
- (MODULES-4049) Adds SLES 12 Support
- Adds additional directories options for LDAP Auth
  - `auth_ldap_url`
  - `auth_ldap_bind_dn`
  - `auth_ldap_bind_password`
  - `auth_ldap_group_attribute`
  - `auth_ldap_group_attribute_is_dn`
- Allows `mod_event` parameters to be unset
- Allows management of default root directory access rights
- Adds class `apache::vhosts` to create apache::vhost resources
- Adds class `apache::mod::proxy_wstunnel`
- Adds class `apache::mod::dumpio`
- Adds class `apache::mod::socache_shmcb`
- Adds class `apache::mod::authn_dbd`
- Adds support for apache 2.4 on Amazon Linux
- Support the newer `mod_auth_cas` config options
- Adds `wsgi_script_aliases_match` parameter to `apache::vhost`
- Allow to override all SecDefaultAction attributes
- Add audit_log_relevant_status parameter to apache::mod::security
- Allow absolute path to $apache::mod::security::activated_rules
- Allow setting SecAuditLog
- Adds `passenger_max_instances_per_app` to `mod::passenger`
- Allow the proxy_via setting to be configured
- Allow no_proxy_uris to be used within proxy_pass
- Add rpaf.conf template parameter to `mod::rpaf`
- Allow user to specify alternative package and library names for shibboleth module
- Allows configuration of shibboleth lib path
- Adds parameter `passenger_data_buffer_dir` to `mod::passenger`
- Adds SSL stapling 
- Allows use of `balance_manager` with `mod_proxy_balancer`
- Raises lower bound of `stdlib` dependency to version 4.2
- Adds support for Passenger repo on Amazon Linux
- Add ability to set SSLStaplingReturnResponderErrors on server level 
- (MODULES-4213) Allow global rewrite rules inheritance in vhosts
- Moves `mod_env` to its own class and load it when required

#### Bugfixes
- Deny access to .ht and .hg, which are created by mercurial hg.
- Instead of failing, include apache::mod::prefork in manifests/mod/itk.pp instead.
- Only set SSLCompression when it is set to true.
- Remove duplicate shib2 hash element
- (MODULES-3388) Include mpm_module classes instead of class declaration
- Updates `apache::balancer` to respect `apache::confd_dir`
- Wrap mod_security directives in an IfModule
- Fixes to various mods for Ubuntu Xenial
- Fix /etc/modsecurity perms to match package
- Fix PassengerRoot under Debian stretch
- (MODULES-3476) Updates regex in apache_version custom fact to work with EL5
- Dont sql_injection_attacks.data
- Add force option to confd file resource to purge directory without warnings
- Patch httpoxy through mod_security
- Fixes config ordering of IncludeOptional
- Fixes bug where port numbers were unquoted
- Fixes bug where empty servername for vhost were written to template
- Auto-load `slotmem_shm` and `lbmethod_byrequests` with `proxy_balancer` on 2.4
- Simplify MPM setup on FreeBSD
- Adds requirement for httpd package
- Do not set ssl_certs_dir on FreeBSD
- Fixes bug that produces a duplicate `Listen 443` after a package update on EL7
- Fixes bug where custom facts break structured facts
- Avoid relative classname inclusion
- Fixes a failure in `vhost` if the first element of `$rewrites` is not a hash
- (MODULES-3744) Process $crs_package before $modsec_dir
- (MODULES-1491) Adds `::apache` include to mods that need it

## Supported Release [1.10.0]
#### Summary
This release fixes backwards compatibility bugs introduced in 1.9.0. Also includes a new mod class and a new vhost feature.

#### Features
- Allow setting KeepAlive related options per vhost
  - `apache::vhost::keepalive`
  - `apache::vhost::keepalive_timeout`
  - `apache::vhost::max_keepalive_requests`
- Adds new class `apache::mod::cluster`

#### Bugfixes
- MODULES-2890: Allow php_version != 5
- MODULES-2890: mod::php: Explicit test on jessie
- MODULES-2890: Fix PHP on Debian stretch and Ubuntu Xenial
- MODULES-2890: Fix mod_php SetHandler and cleanup
- Fixed trailing slash in lib_path on Suse
- Revert "MODULES-2956: Enable options within location block on proxy_match". Bug introduced in release 1.9.0.
- Revert "changed rpaf Configuration Directives: RPAF -> RPAF_". Bug introduced in release 1.9.0.
- Set actual path to apachectl on FreeBSD. Fixes snippets verification.

## Supported Release [1.9.0] [DELETED]
#### Features
- Added `apache_version` fact
- Added `apache::balancer::target` attribute
- Added `apache::fastcgi::server::pass_header` attribute
- Added ability for `apache::fastcgi::server::host` using sockets
- Added `apache::root_directory_options` attribute
- Added for `apache::mod::ldap`:
  - `ldap_shared_cache_size`
  - `ldap_cache_entries`
  - `ldap_cache_ttl`
  - `ldap_opcache_entries`
  - `ldap_opcache_ttl`
- Added `apache::mod::pagespeed::package_ensure` attribute
- Added `apache::mod::passenger` attributes:
  - `passenger_log_level`
  - `manage_repo`
- Added upstream repo for `apache::mod::passenger`
- Added `apache::mod::proxy_fcgi` class
- Added `apache::mod::security` attributes:
  - `audit_log_parts`
  - `secpcrematchlimit`
  - `secpcrematchlimitrecursion`
  - `secdefaultaction`
  - `anomaly_score_blocking`
  - `inbound_anomaly_threshold`
  - `outbound_anomaly_threshold`
- Added `apache::mod::ssl` attributes:
  - `ssl_mutex`
  - `apache_version`
- Added ubuntu 16.04 support
- Added `apache::mod::authnz_ldap::package_name` attribute
- Added `apache::mod::ldap::package_name` attribute
- Added `apache::mod::proxy::package_name` attribute
- Added `apache::vhost` attributes:
  - `ssl_proxy_check_peen_expire`
  - `ssl_proxy_protocol`
  - `logroot_owner`
  - `logroot_group`
  - `setenvifnocase`
  - `passenger_user`
  - `passenger_high_performance`
  - `jk_mounts`
  - `fastcgi_idle_timeout`
  - `modsec_disable_msgs`
  - `modsec_disable_tags`
- Added ability for 2.4-style `RequireAll|RequireNone|RequireAny` directory permissions
- Added ability for includes in vhost directory
- Added directory values:
  - `AuthMerging`
  - `MellonSPMetadataFile`
- Adds Configurability of Collaborative Detection Severity Levels for OWASP Core Rule Set to `apache::mod::security` class
  - `critical_anomaly_score`
  - `error_anomaly_score`
  - `warning_anomaly_score`
  - `notice_anomaly_score`
- Adds ability to configure `info_path` in `apache::mod::info` class
- Adds ability to configure `verify_config` in `apache::vhost::custom`

#### Bugfixes
- Fixed apache mod setup for event/worker failing syntax
- Fixed concat deprecation warnings
- Fixed pagespeed mod
- Fixed service restart on mod update
- Fixed mod dir purging to happen after package installs
- Fixed various `apache::mod::*` file modes
- Fixed `apache::mod::authnz_ldap` parameter `verifyServerCert` to be `verify_server_cert`
- Fixed loadfile name in `apache::mod::fcgid`
- Fixed `apache::mod::remoteip` to fail on apache < 2.4 (because it is not available)
- Fixed `apache::mod::ssl::ssl_honorcipherorder` interpolation
- Lint fixes
- Strict variable fixes
- Fixed `apache::vhost` attribute `redirectmatch_status` to be optional
- Fixed SSLv3 on by default in mod\_nss
- Fixed mod\_rpaf directive names in template
- Fixed mod\_worker needing MaxClients with ThreadLimit
- Fixed quoting on vhost php\_value
- Fixed xml2enc for proxy\_html on debian
- Fixed a problem where the apache service restarts too fast

## Supported Release [1.8.1]
### Summary
This release includes bug fixes and a documentation update.

#### Bugfixes
- Fixes a bug that occurs when using the module in combination with puppetlabs-concat 2.x.
- Fixes a bug where passenger.conf was vulnerable to purging.
- Removes the pin of the concat module dependency.

## Supported Release [1.8.0]
### Summary
This release includes a lot of bug fixes and feature updates, including support for Debian 8, as well as many test improvements.

#### Features
- Debian 8 Support.
- Added the 'file_mode' property to allow a custom permission setting for config files.
- Enable 'PassengerMaxRequestQueueSize' to be set for mod_passenger.
- MODULES-2956: Enable options within location block on proxy_match.
- Support itk on redhat.
- Support the mod_ssl SSLProxyVerify directive.
- Support ProxPassReverseCookieDomain directive (mod_proxy).
- Support proxy provider for vhost directories.
- Added new 'apache::vhost::custom' resource.

#### Bugfixes
- Fixed ProxyPassReverse configuration.
- Fixed error in Amazon operatingsystem detection.
- Fixed mod_security catalog ordering issues for RedHat 7.
- Fixed paths and packages for the shib2 apache module on Debian pre Jessie.
- Fixed EL7 directory path for apache modules.
- Fixed validation error when empty array is passed for the rewrites parameter.
- Idempotency fixes with regards to '::apache::mod_enable_dir'.
- ITK fixes.
- (MODULES-2865) fix $mpm_module logic for 'false'.
- Set SSLProxy directives even if ssl is false, due to issue with RewriteRules and ProxyPass directives.
- Enable setting LimitRequestFieldSize globally, and remove it from vhost.

#### Improvements
- apache::mod::php now uses FilesMatch to configure the php handler. This is following the recommended upstream configuration guidelines (http://php.net/manual/en/install.unix.apache2.php#example-20) and distribution's default config (e.g.: http://bazaar.launchpad.net/~ubuntu-branches/ubuntu/vivid/php5/vivid/view/head:/debian/php5.conf). It avoids inadvertently exposing the PHP handler to executing uploads with names like 'file.php.jpg', but might impact setups with unusual requirements.
- Improved compatibility for Gentoo.
- Vhosts can now be supplied with a wildcard listen value.
- Numerous test improvements.
- Removed workarounds for https://bz.apache.org/bugzilla/show_bug.cgi?id=38864 as the issues have been fixed in Apache.
- Documentation updates.
- Ensureed order of ProxyPass and ProxyPassMatch parameters.
- Ensure that ProxyPreserveHost is set to off mode explicitly if not set in manifest.
- Put headers and request headers before proxy with regards to template generation.
- Added X-Forwarded-For into log_formats defaults.
- (MODULES-2703) Allow mod pagespeed to take an array of lines as additional_configuration.

## Supported Release [1.7.1]
###Summary

Small release for support of newer PE versions. This increments the version of PE in the metadata.json file.

## Supported Release [1.7.0]
### Summary
This release includes many new features and bugfixes. There are test, documentation and misc improvements.

#### Features
- allow groups with - like vhost-users 
- ability to enable/disable the secruleengine through a parameter
- add mod_auth_kerb parameters to vhost
- client auth for reverse proxy
- support for mod_auth_mellon
- change SSLProtocol in apache::vhost to be space separated
- RewriteLock support

#### Bugfixes
- fix apache::mod::cgid so it can be used with the event MPM 
- load unixd before fcgid on all operating systems
- fixes conditional in vhost aliases
- corrects mod_cgid worker/event defaults
- ProxyPassMatch parameters were ending up on a newline
- catch that mod_authz_default has been removed in Apache 2.4
- mod::ssl fails on SLES
- fix typo of MPM_PREFORK for FreeBSD package install 
- install all modules before adding custom configs
- fix acceptance testing for SSLProtocol behaviour for real
- fix ordering issue with conf_file and ports_file 

#### Known Issues
- mod_passenger is having issues installing on Redhat/Centos 6, This is due to package dependency issues.

#### Improvements
- added docs for forcetype directive
- removes ruby 1.8.7 from the travisci test matrix
- readme reorganisation, minor fixups
- support the mod_proxy ProxyPassReverseCookiePath directive
- the purge_vhost_configs parameter is actually called purge_vhost_dir
- add ListenBacklog for mod worker
- deflate application/json by default 
- install mod_authn_alias as default mod in debian for apache < 2.4
- optionally set LimitRequestFieldSize on an apache::vhost
- add SecUploadDir parameter to support file uploads with mod_security
- optionally set parameters for mod_ext_filter module
- allow SetOutputFilter to be set on a directory
- RC4 is deprecated
- allow empty docroot
- add option to configure the include pattern for the vhost_enable dir
- allow multiple IP addresses per vhost
- default document root update for Ubuntu 14.04 and Debian 8 

## Supported Release [1.6.0]
### Summary
This release includes a couple of new features, along with test and documentation updates, and support for the latest AIO puppet builds.

#### Features
- Add `scan_proxy_header_field` parameter to `apache::mod::geoip`
- Add `ssl_openssl_conf_cmd` parameter to `apache::vhost` and `apache::mod::ssl`
- Add `filters` parameter to `apache::vhost`

#### Bugfixes
- Test updates
- Do not use systemd on Amazon Linux
- Add missing docs for `timeout` parameter (MODULES-2148)

## Supported Release [1.5.0]
### Summary
This release primarily adds Suse compatibility. It also adds a handful of other
parameters for greater configuration control.

#### Features
- Add `apache::lib_path` parameter
- Add `apache::service_restart` parameter
- Add `apache::vhost::geoip_enable` parameter
- Add `apache::mod::geoip` class
- Add `apache::mod::remoteip` class
- Add parameters to `apache::mod::expires` class
- Add `index_style_sheet` handling to `apache::vhost::directories`
- Add some compatibility for SLES 11
- Add `apache::mod::ssl::ssl_sessioncachetimeout` parameter
- Add `apache::mod::ssl::ssl_cryptodevice` parameter
- Add `apache::mod::ssl::ssl_honorcipherorder` parameter
- Add `apache::mod::userdir::options` parameter

#### Bugfixes
- Document `apache::user` parameter
- Document `apache::group` parameter
- Fix apache::dev on FreeBSD
- Fix proxy\_connect on apache >= 2.2
- Validate log levels better
- Fix `apache::apache_name` for package and vhost
- Fix Debian Jessie mod\_prefork package name
- Fix alias module being declared even when vhost is absent
- Fix proxy\_pass\_match handling in vhost's proxy template
- Fix userdir access permissions
- Fix issue where the module was trying to use systemd on Amazon Linux.

## Supported Release [1.4.1]

This release corrects a metadata issue that has been present since release 1.2.0. The refactoring of `apache::vhost` to use `puppetlabs-concat` requires a version of concat newer than the version required in PE. If you are using PE 3.3.0 or earlier you will need to use version 1.1.1 or earlier of the `puppetlabs-apache` module.

## Supported Release [1.4.0]
###Summary

This release fixes the issue where the docroot was still managed even if the default vhosts were disabled and has many other features and bugfixes including improved support for 'deny' and 'require' as arrays in the 'directories' parameter under `apache::vhost`

#### Features
- New parameters to `apache`
  - `default_charset`
  - `default_type`
- New parameters to `apache::vhost`
  - `proxy_error_override`
  - `passenger_app_env` (MODULES-1776)
  - `proxy_dest_match`
  - `proxy_dest_reverse_match`
  - `proxy_pass_match`
  - `no_proxy_uris_match`
- New parameters to `apache::mod::passenger`
  - `passenger_app_env`
  - `passenger_min_instances`
- New parameter to `apache::mod::alias`
  - `icons_options`
- New classes added under `apache::mod::*`
  - `authn_file`
  - `authz_default`
  - `authz_user`
- Added support for 'deny' as an array in 'directories' under `apache::vhost`
- Added support for RewriteMap
- Improved support for FreeBSD. (Note: If using apache < 2.4.12, see the discussion [here](https://github.com/puppetlabs/puppetlabs-apache/pull/1030))
- Added check for deprecated options in directories and fail when they are unsupported
- Added gentoo compatibility
- Added proper array support for `require` in the `directories` parameter in `apache::vhost`
- Added support for `setenv` inside proxy locations

### Bugfixes
- Fix issue in `apache::vhost` that was preventing the scriptalias fragment from being included (MODULES-1784)
- Install required `mod_ldap` package for EL7 (MODULES-1779)
- Change default value of `maxrequestworkers` in `apache::mod::event` to be a multiple of the default `ThreadsPerChild` of 25.
- Use the correct `mod_prefork` package name for trusty and jessie
- Don't manage docroot when default vhosts are disabled
- Ensure resources notify `Class['Apache::Service']` instead of `Service['httpd']` (MODULES-1829)
- Change the loadfile name for `mod_passenger` so `mod_proxy` will load by default before `mod_passenger`
- Remove old Debian work-around that removed `passenger_extra.conf`

## Supported Release [1.3.0]
### Summary

This release has many new features and bugfixes, including the ability to optionally not trigger service restarts on config changes.

#### Features
- New parameters - `apache`
  - `service_manage`
  - `use_optional_includes`
- New parameters - `apache::service`
  - `service_manage`
- New parameters - `apache::vhost`
  - `access_logs`
  - `php_flags`
  - `php_values`
  - `modsec_disable_vhost`
  - `modsec_disable_ids`
  - `modsec_disable_ips`
  - `modsec_body_limit`
- Improved FreeBSD support
- Add ability to omit priority prefix if `$priority` is set to false
- Add `apache::security::rule_link` define
- Improvements to `apache::mod::*`
  - Add `apache::mod::auth_cas` class
  - Add `threadlimit`, `listenbacklog`, `maxrequestworkers`, `maxconnectionsperchild` parameters to `apache::mod::event`
  - Add `apache::mod::filter` class
  - Add `root_group` to `apache::mod::php`
  - Add `apache::mod::proxy_connect` class
  - Add `apache::mod::security` class
  - Add `ssl_pass_phrase_dialog` and `ssl_random_seed_bytes` parameters to `apache::mod::ssl` (MODULES-1719)
  - Add `status_path` parameter to `apache::mod::status`
  - Add `apache_version` parameter to `apache::mod::version`
  - Add `package_name` and `mod_path` parameters to `apache::mod::wsgi` (MODULES-1458)
- Improved SCL support
  - Add support for specifying the docroot
- Updated `_directories.erb` to add support for SetEnv
- Support multiple access log directives (MODULES-1382)
- Add passenger support for Debian Jessie
- Add support for not having puppet restart the apache service (MODULES-1559)

#### Bugfixes
- For apache 2.4 `mod_itk` requires `mod_prefork` (MODULES-825)
- Allow SSLCACertificatePath to be unset in `apache::vhost` (MODULES-1457)
- Load fcgid after unixd on RHEL7
- Allow disabling default vhost for Apache 2.4
- Test fixes
- `mod_version` is now built-in (MODULES-1446)
- Sort LogFormats for idempotency
- `allow_encoded_slashes` was omitted from `apache::vhost`
- Fix documentation bug (MODULES-1403, MODULES-1510)
- Sort `wsgi_script_aliases` for idempotency (MODULES-1384)
- lint fixes
- Fix automatic version detection for Debian Jessie
- Fix error docs and icons path for RHEL7-based systems (MODULES-1554)
- Sort php_* hashes for idempotency (MODULES-1680)
- Ensure `mod::setenvif` is included if needed (MODULES-1696)
- Fix indentation in `vhost/_directories.erb` template (MODULES-1688)
- Create symlinks on all distros if `vhost_enable_dir` is specified

## Supported Release [1.2.0]
### Summary

This release features many improvements and bugfixes, including several new defines, a reworking of apache::vhost for more extensibility, and many new parameters for more customization. This release also includes improved support for strict variables and the future parser.

#### Features
- Convert apache::vhost to use concat for easier extensions
- Test improvements
- Synchronize files with modulesync
- Strict variable and future parser support
- Added apache::custom_config defined type to allow validation of configs before they are created
- Added bool2httpd function to convert true/false to apache 'On' and 'Off'. Intended for internal use in the module.
- Improved SCL support
  - allow overriding of the mod_ssl package name
- Add support for reverse_urls/ProxyPassReverse in apache::vhost
- Add satisfy directive in apache::vhost::directories
- Add apache::fastcgi::server defined type
- New parameters - apache
  - allow_encoded_slashes
  - apache_name
  - conf_dir
  - default_ssl_crl_check
  - docroot
  - logroot_mode
  - purge_vhost_dir
- New parameters - apache::vhost
  - add_default_charset
  - allow_encoded_slashes
  - logroot_ensure
  - logroot_mode
  - manage_docroot
  - passenger_app_root
  - passenger_min_instances
  - passenger_pre_start
  - passenger_ruby
  - passenger_start_timeout
  - proxy_preserve_host
  - proxy_requests
  - redirectmatch_dest
  - ssl_crl_check
  - wsgi_chunked_request
  - wsgi_pass_authorization
- Add support for ScriptAlias and ScriptAliasMatch in the apache::vhost::aliases parameter
- Add support for rewrites in the apache::vhost::directories parameter
- If the service_ensure parameter in apache::service is set to anything other than true, false, running, or stopped, ensure will not be passed to the service resource, allowing for the service to not be managed by puppet
- Turn of SSLv3 by default
- Improvements to apache::mod*
  - Add restrict_access parameter to apache::mod::info
  - Add force_language_priority and language_priority parameters to apache::mod::negotiation
  - Add threadlimit parameter to apache::mod::worker
  - Add content, template, and source parameters to apache::mod::php
  - Add mod_authz_svn support via the authz_svn_enabled parameter in apache::mod::dav_svn
  - Add loadfile_name parameter to apache::mod
  - Add apache::mod::deflate class
  - Add options parameter to apache::mod::fcgid
  - Add timeouts parameter to apache::mod::reqtimeout
  - Add apache::mod::shib
  - Add apache_version parameter to apache::mod::ldap
  - Add magic_file parameter to apache::mod::mime_magic
  - Add apache_version parameter to apache::mod::pagespeed
  - Add passenger_default_ruby parameter to apache::mod::passenger
  - Add content, template, and source parameters to apache::mod::php
  - Add apache_version parameter to apache::mod::proxy
  - Add loadfiles parameter to apache::mod::proxy_html
  - Add ssl_protocol and package_name parameters to apache::mod::ssl
  - Add apache_version parameter to apache::mod::status
  - Add apache_version parameter to apache::mod::userdir
  - Add apache::mod::version class

#### Bugfixes
- Set osfamily defaults for wsgi_socket_prefix
- Support multiple balancermembers with the same url
- Validate apache::vhost::custom_fragment
- Add support for itk with mod_php
- Allow apache::vhost::ssl_certs_dir to not be set
- Improved passenger support for Debian
- Improved 2.4 support without mod_access_compat
- Support for more than one 'Allow from'-directive in _directories.erb
- Don't load systemd on Amazon linux based on CentOS6 with apache 2.4
- Fix missing newline in ModPagespeed filter and memcached servers directive
- Use interpolated strings instead of numbers where required by future parser
- Make auth_require take precedence over default with apache 2.4
- Lint fixes
- Set default for php_admin_flags and php_admin_values to be empty hash instead of empty array
- Correct typo in mod::pagespeed
- spec_helper fixes
- Install mod packages before dealing with the configuration
- Use absolute scope to check class definition in apache::mod::php
- Fix dependency loop in apache::vhost
- Properly scope variables in the inline template in apache::balancer
- Documentation clarification, typos, and formatting
- Set apache::mod::ssl::ssl_mutex to default for debian on apache >= 2.4
- Strict variables fixes
- Add authn_core mode to Ubuntu trusty defaults
- Keep default loadfile for authz_svn on Debian
- Remove '.conf' from the site-include regexp for better Ubuntu/Debian support
- Load unixd before fcgid for EL7
- Fix RedirectMatch rules
- Fix misleading error message in apache::version

#### Known Bugs
* By default, the version of Apache that ships with Ubuntu 10.04 does not work with `wsgi_import_script`.
* SLES is unsupported.

## Supported Release [1.1.1]
### Summary

This release merely updates metadata.json so the module can be uninstalled and
upgraded via the puppet module command.

## Supported Release [1.1.0]

### Summary

This release primarily focuses on extending the httpd 2.4 support, tested
through adding RHEL7 and Ubuntu 14.04 support.  It also includes Passenger 
4 support, as well as several new modules and important bugfixes.

#### Features

- Add support for RHEL7 and Ubuntu 14.04
- More complete apache24 support
- Passenger 4 support
- Add support for max_keepalive_requests and log_formats parameters
- Add mod_pagespeed support
- Add mod_speling support
- Added several parameters for mod_passenger
- Added ssl_cipher parameter to apache::mod::ssl
- Improved examples in documentation
- Added docroot_mode, action, and suexec_user_group parameters to apache::vhost
- Add support for custom extensions for mod_php
- Improve proxy_html support for Debian

#### Bugfixes

- Remove NameVirtualHost directive for apache >= 2.4
- Order proxy_set option so it doesn't change between runs
- Fix inverted SSL compression
- Fix missing ensure on concat::fragment resources
- Fix bad dependencies in apache::mod and apache::mod::mime

#### Known Bugs
* By default, the version of Apache that ships with Ubuntu 10.04 does not work with `wsgi_import_script`.
* SLES is unsupported.

## Supported Release [1.0.1]
### Summary

This is a supported release.  This release removes a testing symlink that can
cause trouble on systems where /var is on a seperate filesystem from the
modulepath.

#### Features
#### Bugfixes
#### Known Bugs
* By default, the version of Apache that ships with Ubuntu 10.04 does not work with `wsgi_import_script`.
* SLES is unsupported.
 
## Supported Release [1.0.0]
### Summary

This is a supported release. This release introduces Apache 2.4 support for
Debian and RHEL based osfamilies.

#### Features

- Add apache24 support
- Add rewrite_base functionality to rewrites
- Updated README documentation
- Add WSGIApplicationGroup and WSGIImportScript directives

#### Bugfixes

- Replace mutating hashes with merge() for Puppet 3.5
- Fix WSGI import_script and mod_ssl issues on Lucid

#### Known Bugs
* By default, the version of Apache that ships with Ubuntu 10.04 does not work with `wsgi_import_script`.
* SLES is unsupported.

---

## Supported Release [0.11.0]
### Summary:

This release adds preliminary support for Windows compatibility and multiple rewrite support.

#### Backwards-incompatible Changes:

- The rewrite_rule parameter is deprecated in favor of the new rewrite parameter
  and will be removed in a future release.

#### Features:

- add Match directive
- quote paths for windows compatibility
- add auth_group_file option to README.md
- allow AuthGroupFile directive for vhosts
- Support Header directives in vhost context
- Don't purge mods-available dir when separate enable dir is used
- Fix the servername used in log file name
- Added support for mod_include
- Remove index parameters.
- Support environment variable control for CustomLog
- added redirectmatch support
- Setting up the ability to do multiple rewrites and conditions.
- Convert spec tests to beaker.
- Support php_admin_(flag|value)s

#### Bugfixes:

- directories are either a Hash or an Array of Hashes
- Configure Passenger in separate .conf file on RH so PassengerRoot isn't lost
- (docs) Update list of `apache::mod::[name]` classes
- (docs) Fix apache::namevirtualhost example call style
- Fix $ports_file reference in apache::listen.
- Fix $ports_file reference in Namevirtualhost.


## Supported Release [0.10.0]
### Summary:

This release adds FreeBSD osfamily support and various other improvements to some mods.

#### Features:

- Add suPHP_UserGroup directive to directory context
- Add support for ScriptAliasMatch directives
- Set SSLOptions StdEnvVars in server context
- No implicit <Directory> entry for ScriptAlias path
- Add support for overriding ErrorDocument
- Add support for AliasMatch directives
- Disable default "allow from all" in vhost-directories
- Add WSGIPythonPath as an optional parameter to mod_wsgi. 
- Add mod_rpaf support
- Add directives: IndexOptions, IndexOrderDefault
- Add ability to include additional external configurations in vhost
- need to use the provider variable not the provider key value from the directory hash for matches
- Support for FreeBSD and few other features
- Add new params to apache::mod::mime class
- Allow apache::mod to specify module id and path
- added $server_root parameter
- Add Allow and ExtendedStatus support to mod_status
- Expand vhost/_directories.pp directive support
- Add initial support for nss module (no directives in vhost template yet)
- added peruser and event mpms
- added $service_name parameter
- add parameter for TraceEnable
- Make LogLevel configurable for server and vhost
- Add documentation about $ip
- Add ability to pass ip (instead of wildcard) in default vhost files

#### Bugfixes:

- Don't listen on port or set NameVirtualHost for non-existent vhost
- only apply Directory defaults when provider is a directory
- Working mod_authnz_ldap support on Debian/Ubuntu

## Supported Release [0.9.0]
### Summary:
This release adds more parameters to the base apache class and apache defined
resource to make the module more flexible. It also adds or enhances SuPHP,
WSGI, and Passenger mod support, and support for the ITK mpm module.

#### Backwards-incompatible Changes:
- Remove many default mods that are not normally needed.
- Remove `rewrite_base` `apache::vhost` parameter; did not work anyway.
- Specify dependencies on stdlib >=2.4.0 (this was already the case, but
making explicit)
- Deprecate `a2mod` in favor of the `apache::mod::*` classes and `apache::mod`
defined resource.

#### Features:
- `apache` class
  - Add `httpd_dir` parameter to change the location of the configuration
  files.
  - Add `logroot` parameter to change the logroot
  - Add `ports_file` parameter to changes the `ports.conf` file location
  - Add `keepalive` parameter to enable persistent connections
  - Add `keepalive_timeout` parameter to change the timeout
  - Update `default_mods` to be able to take an array of mods to enable.
- `apache::vhost`
  - Add `wsgi_daemon_process`, `wsgi_daemon_process_options`,
  `wsgi_process_group`, and `wsgi_script_aliases` parameters for per-vhost
  WSGI configuration.
  - Add `access_log_syslog` parameter to enable syslogging.
  - Add `error_log_syslog` parameter to enable syslogging of errors.
  - Add `directories` hash parameter. Please see README for documentation.
  - Add `sslproxyengine` parameter to enable SSLProxyEngine
  - Add `suphp_addhandler`, `suphp_engine`, and `suphp_configpath` for
  configuring SuPHP.
  - Add `custom_fragment` parameter to allow for arbitrary apache
  configuration injection. (Feature pull requests are prefered over using
  this, but it is available in a pinch.)
- Add `apache::mod::suphp` class for configuring SuPHP.
- Add `apache::mod::itk` class for configuring ITK mpm module.
- Update `apache::mod::wsgi` class for global WSGI configuration with
`wsgi_socket_prefix` and `wsgi_python_home` parameters.
- Add README.passenger.md to document the `apache::mod::passenger` usage.
Added `passenger_high_performance`, `passenger_pool_idle_time`,
`passenger_max_requests`, `passenger_stat_throttle_rate`, `rack_autodetect`,
and `rails_autodetect` parameters.
- Separate the httpd service resource into a new `apache::service` class for
dependency chaining of `Class['apache'] -> <resource> ~>
Class['apache::service']`
- Added `apache::mod::proxy_balancer` class for `apache::balancer`

#### Bugfixes:
- Change dependency to puppetlabs-concat
- Fix ruby 1.9 bug for `a2mod`
- Change servername to be `$::hostname` if there is no `$::fqdn`
- Make `/etc/ssl/certs` the default ssl certs directory for RedHat non-5.
- Make `php` the default php package for RedHat non-5.
- Made `aliases` able to take a single alias hash instead of requiring an
array.

## Supported Release [0.8.1]
#### Bugfixes:
- Update `apache::mpm_module` detection for worker/prefork
- Update `apache::mod::cgi` and `apache::mod::cgid` detection for
worker/prefork

## Supported Release [0.8.0]
#### Features:
- Add `servername` parameter to `apache` class
- Add `proxy_set` parameter to `apache::balancer` define

#### Bugfixes:
- Fix ordering for multiple `apache::balancer` clusters
- Fix symlinking for sites-available on Debian-based OSs
- Fix dependency ordering for recursive confdir management
- Fix `apache::mod::*` to notify the service on config change
- Documentation updates

## Supported Release [0.7.0]
#### Changes:
- Essentially rewrite the module -- too many to list
- `apache::vhost` has many abilities -- see README.md for details
- `apache::mod::*` classes provide httpd mod-loading capabilities
- `apache` base class is much more configurable

#### Bugfixes:
- Many. And many more to come

## Supported Release [0.6.0]
- update travis tests (add more supported versions)
- add access log_parameter
- make purging of vhost dir configurable

## Supported Release [0.4.0]
#### Changes:
- `include apache` is now required when using `apache::mod::*`

#### Bugfixes:
- Fix syntax for validate_re
- Fix formatting in vhost template
- Fix spec tests such that they pass

## Supported Release [0.0.4]
* e62e362 Fix broken tests for ssl, vhost, vhost::*
* 42c6363 Changes to match style guide and pass puppet-lint without error
* 42bc8ba changed name => path for file resources in order to name namevar by it's name
* 72e13de One end too much
* 0739641 style guide fixes: 'true' <> true, $operatingsystem needs to be $::operatingsystem, etc.
* 273f94d fix tests
* a35ede5 (#13860) Make a2enmod/a2dismo commands optional
* 98d774e (#13860) Autorequire Package['httpd']
* 05fcec5 (#13073) Add missing puppet spec tests
* 541afda (#6899) Remove virtual a2mod definition
* 976cb69 (#13072) Move mod python and wsgi package names to params
* 323915a (#13060) Add .gitignore to repo
* fdf40af (#13060) Remove pkg directory from source tree
* fd90015 Add LICENSE file and update the ModuleFile
* d3d0d23 Re-enable local php class
* d7516c7 Make management of firewalls configurable for vhosts
* 60f83ba Explicitly lookup scope of apache_name in templates.
* f4d287f (#12581) Add explicit ordering for vdir directory
* 88a2ac6 (#11706) puppetlabs-apache depends on puppetlabs-firewall
* a776a8b (#11071) Fix to work with latest firewall module
* 2b79e8b (#11070) Add support for Scientific Linux
* 405b3e9 Fix for a2mod
* 57b9048 Commit apache::vhost::redirect Manifest
* 8862d01 Commit apache::vhost::proxy Manifest
* d5c1fd0 Commit apache::mod::wsgi Manifest
* a825ac7 Commit apache::mod::python Manifest
* b77062f Commit Templates
* 9a51b4a Vhost File Declarations
* 6cf7312 Defaults for Parameters
* 6a5b11a Ensure installed
* f672e46 a2mod fix
* 8a56ee9 add pthon support to apache

[3.2.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/3.1.0...3.2.0
[3.1.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/3.0.0...3.1.0
[3.0.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/2.3.1...3.0.0
[2.3.1]:https://github.com/puppetlabs/puppetlabs-apache/compare/2.3.0...2.3.1
[2.3.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/2.2.0...2.3.0
[2.2.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/2.1.0...2.2.0
[2.1.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/2.0.0...2.1.0
[2.0.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.11.0...2.0.0
[1.11.1]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.11.0...1.11.1
[1.11.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.10.0...1.11.0
[1.10.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.9.0...1.10.0
[1.9.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.8.1...1.9.0
[1.8.1]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.8.0...1.8.1
[1.8.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.7.1...1.8.0
[1.7.1]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.7.0...1.7.1
[1.7.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.6.0...1.7.0
[1.6.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.5.0...1.6.0
[1.5.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.4.1...1.5.0
[1.4.1]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.4.0...1.4.1
[1.4.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.3.0...1.4.0
[1.3.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.2.0...1.3.0
[1.2.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.1.1...1.2.0
[1.1.1]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.1.0...1.1.1
[1.1.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.0.1...1.1.0
[1.0.1]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.0.0...1.0.1
[1.0.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/0.11.0...1.0.0
[0.11.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.10.0...0.11.0
[0.10.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.9.0...0.10.0
[0.9.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/1.8.1...0.9.0
[0.8.1]:https://github.com/puppetlabs/puppetlabs-apache/compare/0.8.0...0.8.1
[0.8.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/0.7.0...0.8.0
[0.7.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/0.6.0...0.7.0
[0.6.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/0.5.0-rc1...0.6.0
[0.5.0-rc1]:https://github.com/puppetlabs/puppetlabs-apache/compare/0.4.0...0.5.0-rc1
[0.4.0]:https://github.com/puppetlabs/puppetlabs-apache/compare/0.3.0...0.4.0
[0.0.4]:https://github.com/puppetlabs/puppetlabs-apache/commits/0.0.4


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
