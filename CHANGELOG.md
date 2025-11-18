<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v13.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v13.1.0) - 2025-11-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v13.0.0...v13.1.0)

### Added

- Add Debian 13 support [#2603](https://github.com/puppetlabs/puppetlabs-apache/pull/2603) ([weaselp](https://github.com/weaselp))

## [v13.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v13.0.0) - 2025-09-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v12.3.1...v13.0.0)

### Changed

- (MODULES-11606) Remove apache::mod::info as a default module for FreeBSD [#2610](https://github.com/puppetlabs/puppetlabs-apache/pull/2610) ([shubhamshinde360](https://github.com/shubhamshinde360))
- (CAT-2360) Prepare module for Puppetcore / Drop Support for Puppet 7 [#2600](https://github.com/puppetlabs/puppetlabs-apache/pull/2600) ([david22swan](https://github.com/david22swan))

### Fixed

- (MAINT) Remove enforced Ubuntu runner from ci [#2606](https://github.com/puppetlabs/puppetlabs-apache/pull/2606) ([LukasAud](https://github.com/LukasAud))

### Other

- (CAT-2296) Update github runner image to ubuntu-24.04 [#2599](https://github.com/puppetlabs/puppetlabs-apache/pull/2599) ([shubhamshinde360](https://github.com/shubhamshinde360))

## [v12.3.1](https://github.com/puppetlabs/puppetlabs-apache/tree/v12.3.1) - 2025-03-31

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v12.3.0...v12.3.1)

### Fixed

- Install mod_http2 on EL if required [#2593](https://github.com/puppetlabs/puppetlabs-apache/pull/2593) ([ekohl](https://github.com/ekohl))

## [v12.3.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v12.3.0) - 2025-03-05

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v12.2.0...v12.3.0)

### Added

- Allow configuring RemoteIPProxyProtocol at VHost level [#2582](https://github.com/puppetlabs/puppetlabs-apache/pull/2582) ([smortex](https://github.com/smortex))
- (CAT-2100) Add Debian 12 support [#2572](https://github.com/puppetlabs/puppetlabs-apache/pull/2572) ([shubhamshinde360](https://github.com/shubhamshinde360))
- Feature: Allow to set the verbosity of the debug [#2523](https://github.com/puppetlabs/puppetlabs-apache/pull/2523) ([JGodin-C2C](https://github.com/JGodin-C2C))

### Fixed

- (CAT-2158) Upgrade rexml to address CVE-2024-49761 [#2579](https://github.com/puppetlabs/puppetlabs-apache/pull/2579) ([amitkarsale](https://github.com/amitkarsale))
- Update types/oidcsettings UserInfoRefreshInterval to allow Integers again [#2578](https://github.com/puppetlabs/puppetlabs-apache/pull/2578) ([gcoxmoz](https://github.com/gcoxmoz))

### Other

- Fix mod_headers load for headers in directory #2590 [#2591](https://github.com/puppetlabs/puppetlabs-apache/pull/2591) ([uoe-pjackson](https://github.com/uoe-pjackson))
- Adding ModSecurity parameter for audit log format. [#2583](https://github.com/puppetlabs/puppetlabs-apache/pull/2583) ([tamerz](https://github.com/tamerz))

## [v12.2.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v12.2.0) - 2024-10-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v12.1.0...v12.2.0)

### Added

- Update config parameters to match latest OIDC release and fix typos. … [#2569](https://github.com/puppetlabs/puppetlabs-apache/pull/2569) ([uoe-pjackson](https://github.com/uoe-pjackson))
- add XForwardedHeaders for oidc_settings [#2541](https://github.com/puppetlabs/puppetlabs-apache/pull/2541) ([trefzer](https://github.com/trefzer))
- Added cache_disk [#2521](https://github.com/puppetlabs/puppetlabs-apache/pull/2521) ([dploeger](https://github.com/dploeger))

### Fixed

- Fix apache2-mod_php7 not found for SLES-15 [#2568](https://github.com/puppetlabs/puppetlabs-apache/pull/2568) ([Harvey2504](https://github.com/Harvey2504))
- Add missing brackets for function call [#2540](https://github.com/puppetlabs/puppetlabs-apache/pull/2540) ([gerlingsm](https://github.com/gerlingsm))

## [v12.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v12.1.0) - 2024-04-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v12.0.3...v12.1.0)

### Added

- vhost: Allow customizing show_diff [#2536](https://github.com/puppetlabs/puppetlabs-apache/pull/2536) ([kajinamit](https://github.com/kajinamit))

### Fixed

- Stop managing mime support package on Debian [#2526](https://github.com/puppetlabs/puppetlabs-apache/pull/2526) ([jcharaoui](https://github.com/jcharaoui))

## [v12.0.3](https://github.com/puppetlabs/puppetlabs-apache/tree/v12.0.3) - 2024-03-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v12.0.2...v12.0.3)

### Fixed

- Fix `mod_auth_openidc` parameters [#2525](https://github.com/puppetlabs/puppetlabs-apache/pull/2525) ([smortex](https://github.com/smortex))

## [v12.0.2](https://github.com/puppetlabs/puppetlabs-apache/tree/v12.0.2) - 2024-01-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v12.0.1...v12.0.2)

### Fixed

- Correct handling of $serveraliases as string [#2518](https://github.com/puppetlabs/puppetlabs-apache/pull/2518) ([ekohl](https://github.com/ekohl))

## [v12.0.1](https://github.com/puppetlabs/puppetlabs-apache/tree/v12.0.1) - 2024-01-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v12.0.0...v12.0.1)

### Fixed

- Fix use_canonical_name directive [#2515](https://github.com/puppetlabs/puppetlabs-apache/pull/2515) ([pebtron](https://github.com/pebtron))
- Fix extra newline at end of headers [#2514](https://github.com/puppetlabs/puppetlabs-apache/pull/2514) ([smortex](https://github.com/smortex))

## [v12.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v12.0.0) - 2024-01-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v11.1.0...v12.0.0)

### Changed

- Drop EoL Debian 9 and older code [#2479](https://github.com/puppetlabs/puppetlabs-apache/pull/2479) ([bastelfreak](https://github.com/bastelfreak))

### Added

- `apache::vhost::directories`: switch default from `undef` to empty array [#2507](https://github.com/puppetlabs/puppetlabs-apache/pull/2507) ([bastelfreak](https://github.com/bastelfreak))
- Add `AllowOverrideList` support [#2486](https://github.com/puppetlabs/puppetlabs-apache/pull/2486) ([yakatz](https://github.com/yakatz))

### Fixed

- Remove useless notice [#2494](https://github.com/puppetlabs/puppetlabs-apache/pull/2494) ([smortex](https://github.com/smortex))

## [v11.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v11.1.0) - 2023-09-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v11.0.0...v11.1.0)

### Added

- (CAT-1450) - Added new parameters for passenger mod [#2471](https://github.com/puppetlabs/puppetlabs-apache/pull/2471) ([Ramesh7](https://github.com/Ramesh7))

### Fixed

- (CAT-1451) - Fixing nil check fix for SSL config [#2473](https://github.com/puppetlabs/puppetlabs-apache/pull/2473) ([Ramesh7](https://github.com/Ramesh7))

## [v11.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v11.0.0) - 2023-09-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v10.1.1...v11.0.0)

### Changed

- (CAT-1449) - Remove deprecated parameters for scriptaliases & passenger [#2470](https://github.com/puppetlabs/puppetlabs-apache/pull/2470) ([Ramesh7](https://github.com/Ramesh7))
- Remove deprecated classes [#2466](https://github.com/puppetlabs/puppetlabs-apache/pull/2466) ([ekohl](https://github.com/ekohl))
- Remove deprecated parameters from mod::userdir [#2465](https://github.com/puppetlabs/puppetlabs-apache/pull/2465) ([ekohl](https://github.com/ekohl))
- (CAT-1424)-Removal of redhat/scientific/oraclelinux 6 for apache module [#2462](https://github.com/puppetlabs/puppetlabs-apache/pull/2462) ([praj1001](https://github.com/praj1001))

### Added

- (CAT-1417) Nested require support for authz_core mod [#2460](https://github.com/puppetlabs/puppetlabs-apache/pull/2460) ([Ramesh7](https://github.com/Ramesh7))
- Simplify data types and array handling [#2457](https://github.com/puppetlabs/puppetlabs-apache/pull/2457) ([ekohl](https://github.com/ekohl))
- CAT-1285 - RHEL-8 mode security CRS fix [#2452](https://github.com/puppetlabs/puppetlabs-apache/pull/2452) ([Ramesh7](https://github.com/Ramesh7))
- (CAT-1283) - Enable forensic module [#2442](https://github.com/puppetlabs/puppetlabs-apache/pull/2442) ([Ramesh7](https://github.com/Ramesh7))
- (CAT-1281) - Support to add cipher with respective ssl protocol [#2440](https://github.com/puppetlabs/puppetlabs-apache/pull/2440) ([Ramesh7](https://github.com/Ramesh7))
- feat: add Debian12 Compability [#2439](https://github.com/puppetlabs/puppetlabs-apache/pull/2439) ([Robnarok](https://github.com/Robnarok))
- Add MellonSetEnv support [#2423](https://github.com/puppetlabs/puppetlabs-apache/pull/2423) ([](https://github.com/))
- Add the missing mod_authnz_ldap parameters [#2404](https://github.com/puppetlabs/puppetlabs-apache/pull/2404) ([chutzimir](https://github.com/chutzimir))

### Fixed

- (CAT-1308) Making mod list more restrictive and minor improvements in documentation for default mods override [#2459](https://github.com/puppetlabs/puppetlabs-apache/pull/2459) ([Ramesh7](https://github.com/Ramesh7))
- (CAT-1346) erb_to_epp conversion for mod directory [#2453](https://github.com/puppetlabs/puppetlabs-apache/pull/2453) ([praj1001](https://github.com/praj1001))
- (CAT-1348)-Conversion of erb to epp templates except mod or vhost dir… [#2449](https://github.com/puppetlabs/puppetlabs-apache/pull/2449) ([praj1001](https://github.com/praj1001))
- Raise Puppet lower bound to >= 7.9.0 [#2444](https://github.com/puppetlabs/puppetlabs-apache/pull/2444) ([ekohl](https://github.com/ekohl))
- (CAT-1261)-update_SUSE_repo_name [#2437](https://github.com/puppetlabs/puppetlabs-apache/pull/2437) ([praj1001](https://github.com/praj1001))
- Add required package for kerberos auth on jammy [#2403](https://github.com/puppetlabs/puppetlabs-apache/pull/2403) ([chrisongthb](https://github.com/chrisongthb))
- strickter loglevel syntax verification [#2397](https://github.com/puppetlabs/puppetlabs-apache/pull/2397) ([igt-marcin-wasilewski](https://github.com/igt-marcin-wasilewski))

## [v10.1.1](https://github.com/puppetlabs/puppetlabs-apache/tree/v10.1.1) - 2023-06-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v10.1.0...v10.1.1)

### Added

- Add mod_proxy_http2 support [#2393](https://github.com/puppetlabs/puppetlabs-apache/pull/2393) ([ekohl](https://github.com/ekohl))

### Fixed

- puppetlabs/concat: Allow 9.x [#2426](https://github.com/puppetlabs/puppetlabs-apache/pull/2426) ([bastelfreak](https://github.com/bastelfreak))
- fix ssl_ciphers array behavior [#2421](https://github.com/puppetlabs/puppetlabs-apache/pull/2421) ([SimonHoenscheid](https://github.com/SimonHoenscheid))

## [v10.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v10.1.0) - 2023-06-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v10.0.0...v10.1.0)

### Added

- (CONT-577) - allow deferred function for password/secret [#2419](https://github.com/puppetlabs/puppetlabs-apache/pull/2419) ([Ramesh7](https://github.com/Ramesh7))
- use a dedicated Enum type for On/Off and accept lower case too [#2415](https://github.com/puppetlabs/puppetlabs-apache/pull/2415) ([evgeni](https://github.com/evgeni))
- pdksync - (MAINT) - Allow Stdlib 9.x [#2413](https://github.com/puppetlabs/puppetlabs-apache/pull/2413) ([LukasAud](https://github.com/LukasAud))

### Fixed

- Remove has_key usage [#2408](https://github.com/puppetlabs/puppetlabs-apache/pull/2408) ([evgeni](https://github.com/evgeni))

## [v10.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v10.0.0) - 2023-04-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v9.1.3...v10.0.0)

### Changed

- (CONT-772) Puppet 8 support / Drop Puppet 6 [#2405](https://github.com/puppetlabs/puppetlabs-apache/pull/2405) ([LukasAud](https://github.com/LukasAud))

## [v9.1.3](https://github.com/puppetlabs/puppetlabs-apache/tree/v9.1.3) - 2023-04-20

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v9.1.2...v9.1.3)

### Fixed

- #2391 Allow Sensitive type in addition to String type [#2392](https://github.com/puppetlabs/puppetlabs-apache/pull/2392) ([dpavlotzky](https://github.com/dpavlotzky))

## [v9.1.2](https://github.com/puppetlabs/puppetlabs-apache/tree/v9.1.2) - 2023-02-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v9.1.1...v9.1.2)

### Fixed

- (BUGFIX) Update to ensure correct facter comparisons [#2387](https://github.com/puppetlabs/puppetlabs-apache/pull/2387) ([david22swan](https://github.com/david22swan))
- Fixes mod::proxy allow_from parameter inconsistency #2352 [#2385](https://github.com/puppetlabs/puppetlabs-apache/pull/2385) ([pebtron](https://github.com/pebtron))
- Fix example code for apache::vhost::php_values [#2384](https://github.com/puppetlabs/puppetlabs-apache/pull/2384) ([gcoxmoz](https://github.com/gcoxmoz))
- Suppress bad Directory comment when DocumentRoot is not set [#2368](https://github.com/puppetlabs/puppetlabs-apache/pull/2368) ([gcoxmoz](https://github.com/gcoxmoz))
- fix rewrite rules being ignored [#2330](https://github.com/puppetlabs/puppetlabs-apache/pull/2330) ([trefzer](https://github.com/trefzer))

## [v9.1.1](https://github.com/puppetlabs/puppetlabs-apache/tree/v9.1.1) - 2023-02-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v9.1.0...v9.1.1)

### Fixed

- (BugFix) Update OS Family comparison to correctly match [#2381](https://github.com/puppetlabs/puppetlabs-apache/pull/2381) ([david22swan](https://github.com/david22swan))
- Adding mod_version module to be activated by default [#2380](https://github.com/puppetlabs/puppetlabs-apache/pull/2380) ([Q-Storm](https://github.com/Q-Storm))

## [v9.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v9.1.0) - 2023-01-31

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v9.0.1...v9.1.0)

### Added

- vhost: Make ProxyAddHeaders configureable [#2365](https://github.com/puppetlabs/puppetlabs-apache/pull/2365) ([bastelfreak](https://github.com/bastelfreak))

### Fixed

- (#2374) Suse: Switch modsec_default_rules to array  [#2375](https://github.com/puppetlabs/puppetlabs-apache/pull/2375) ([bastelfreak](https://github.com/bastelfreak))
-  security{,_crs}.conf: switch to structured facts [#2373](https://github.com/puppetlabs/puppetlabs-apache/pull/2373) ([bastelfreak](https://github.com/bastelfreak))
- Simplify templates by reusing bool2httpd [#2366](https://github.com/puppetlabs/puppetlabs-apache/pull/2366) ([ekohl](https://github.com/ekohl))
- Simplify templates by reusing methods [#2344](https://github.com/puppetlabs/puppetlabs-apache/pull/2344) ([ekohl](https://github.com/ekohl))

## [v9.0.1](https://github.com/puppetlabs/puppetlabs-apache/tree/v9.0.1) - 2022-12-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v9.0.0...v9.0.1)

### Fixed

- (CONT-406) Fix for RHEL 7 compatibility [#2362](https://github.com/puppetlabs/puppetlabs-apache/pull/2362) ([david22swan](https://github.com/david22swan))

## [v9.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v9.0.0) - 2022-12-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v8.6.0...v9.0.0)

### Changed

- (GH-2291) Further refine types [#2359](https://github.com/puppetlabs/puppetlabs-apache/pull/2359) ([david22swan](https://github.com/david22swan))
- Drop deprecated a2mod type/providers [#2350](https://github.com/puppetlabs/puppetlabs-apache/pull/2350) ([bastelfreak](https://github.com/bastelfreak))
- Drop Apache 2.2 support [#2329](https://github.com/puppetlabs/puppetlabs-apache/pull/2329) ([ekohl](https://github.com/ekohl))

## [v8.6.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v8.6.0) - 2022-12-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v8.5.0...v8.6.0)

### Added

- Parameterize SecRequestBodyLimitAction and SecResponseBodyLimitAction [#2353](https://github.com/puppetlabs/puppetlabs-apache/pull/2353) ([Vincevrp](https://github.com/Vincevrp))

### Fixed

- fix mod_proxy_html on FreeBSD [#2355](https://github.com/puppetlabs/puppetlabs-apache/pull/2355) ([fraenki](https://github.com/fraenki))
- disable::mpm_event: Fix module deactivation [#2349](https://github.com/puppetlabs/puppetlabs-apache/pull/2349) ([bastelfreak](https://github.com/bastelfreak))

## [v8.5.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v8.5.0) - 2022-12-06

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v8.4.0...v8.5.0)

### Added

- add LimitRequestLine parameter [#2345](https://github.com/puppetlabs/puppetlabs-apache/pull/2345) ([stefan-ahrefs](https://github.com/stefan-ahrefs))

### Fixed

- remove _module from apache::mod::unique_id name. [#2339](https://github.com/puppetlabs/puppetlabs-apache/pull/2339) ([mdklapwijk](https://github.com/mdklapwijk))

## [v8.4.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v8.4.0) - 2022-11-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v8.3.0...v8.4.0)

### Added

- add maxrequestworkers parameter for mpm_worker module [#2331](https://github.com/puppetlabs/puppetlabs-apache/pull/2331) ([trefzer](https://github.com/trefzer))
- support lbmethod modules [#2268](https://github.com/puppetlabs/puppetlabs-apache/pull/2268) ([xorpaul](https://github.com/xorpaul))

### Fixed

- Declare minimum Puppet version to be 6.24.0 [#2342](https://github.com/puppetlabs/puppetlabs-apache/pull/2342) ([ekohl](https://github.com/ekohl))
- Fix RedHat + PHP 8 libphp file [#2333](https://github.com/puppetlabs/puppetlabs-apache/pull/2333) ([cinpol](https://github.com/cinpol))

## [v8.3.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v8.3.0) - 2022-10-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v8.2.1...v8.3.0)

### Added

- Automatically enable mod_http2 if needed [#2337](https://github.com/puppetlabs/puppetlabs-apache/pull/2337) ([ekohl](https://github.com/ekohl))
- Update EL8+ and Debian SSL defaults [#2336](https://github.com/puppetlabs/puppetlabs-apache/pull/2336) ([ekohl](https://github.com/ekohl))
- Support setting SSLProxyCipherSuite on mod_ssl [#2335](https://github.com/puppetlabs/puppetlabs-apache/pull/2335) ([ekohl](https://github.com/ekohl))

### Fixed

- Make serveradmin an optional parameter and use it [#2338](https://github.com/puppetlabs/puppetlabs-apache/pull/2338) ([ekohl](https://github.com/ekohl))
- pdksync - (CONT-189) Remove support for RedHat6 / OracleLinux6 / Scientific6 [#2326](https://github.com/puppetlabs/puppetlabs-apache/pull/2326) ([david22swan](https://github.com/david22swan))
- pdksync - (CONT-130) Dropping Support for Debian 9 [#2322](https://github.com/puppetlabs/puppetlabs-apache/pull/2322) ([jordanbreen28](https://github.com/jordanbreen28))
- fix directory empty options if an empty array is being used [#2312](https://github.com/puppetlabs/puppetlabs-apache/pull/2312) ([bovy89](https://github.com/bovy89))

## [v8.2.1](https://github.com/puppetlabs/puppetlabs-apache/tree/v8.2.1) - 2022-09-27

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v8.2.0...v8.2.1)

### Fixed

- (maint) Codebase Hardening [#2313](https://github.com/puppetlabs/puppetlabs-apache/pull/2313) ([david22swan](https://github.com/david22swan))

## [v8.2.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v8.2.0) - 2022-09-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v8.1.0...v8.2.0)

### Added

- Allow RewriteInherit with empty rewrites [#2301](https://github.com/puppetlabs/puppetlabs-apache/pull/2301) ([martin-koerner](https://github.com/martin-koerner))
- Add support for all proxy schemes, not just https:// [#2289](https://github.com/puppetlabs/puppetlabs-apache/pull/2289) ([canth1](https://github.com/canth1))
- Parameterize CRS DOS protection [#2280](https://github.com/puppetlabs/puppetlabs-apache/pull/2280) ([Vincevrp](https://github.com/Vincevrp))
- Allow multiple scopes for Scope in Apache::OIDCSettings [#2265](https://github.com/puppetlabs/puppetlabs-apache/pull/2265) ([jjackzhn](https://github.com/jjackzhn))

### Fixed

- (maint) Add variable manage_vhost_enable_dir [#2309](https://github.com/puppetlabs/puppetlabs-apache/pull/2309) ([david22swan](https://github.com/david22swan))
- Simplify the logic in _require.erb [#2303](https://github.com/puppetlabs/puppetlabs-apache/pull/2303) ([ekohl](https://github.com/ekohl))
- Fix deprecation warning about performing a regex comparison on a hash [#2293](https://github.com/puppetlabs/puppetlabs-apache/pull/2293) ([smokris](https://github.com/smokris))

## [v8.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v8.1.0) - 2022-08-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v8.0.0...v8.1.0)

### Added

- Manage DNF module for mod_auth_openidc [#2283](https://github.com/puppetlabs/puppetlabs-apache/pull/2283) ([ekohl](https://github.com/ekohl))
- pdksync - (GH-cat-11) Certify Support for Ubuntu 22.04 [#2276](https://github.com/puppetlabs/puppetlabs-apache/pull/2276) ([david22swan](https://github.com/david22swan))

### Fixed

- Allow integers for timeouts [#2294](https://github.com/puppetlabs/puppetlabs-apache/pull/2294) ([traylenator](https://github.com/traylenator))
- Allow setting icons_path to false so no alias will be set for it [#2292](https://github.com/puppetlabs/puppetlabs-apache/pull/2292) ([Zarne](https://github.com/Zarne))
- fix duplicate definition of auth_basic-mod [#2287](https://github.com/puppetlabs/puppetlabs-apache/pull/2287) ([sircubbi](https://github.com/sircubbi))
- Allow custom_config to have a string priority again [#2284](https://github.com/puppetlabs/puppetlabs-apache/pull/2284) ([martin-koerner](https://github.com/martin-koerner))
- Remove auth_kerb and nss from Debian Bullseye [#2281](https://github.com/puppetlabs/puppetlabs-apache/pull/2281) ([ekohl](https://github.com/ekohl))

## [v8.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v8.0.0) - 2022-08-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v7.0.0...v8.0.0)

### Changed

- Drop mod_fastcgi support [#2267](https://github.com/puppetlabs/puppetlabs-apache/pull/2267) ([ekohl](https://github.com/ekohl))
- Drop suphp support [#2263](https://github.com/puppetlabs/puppetlabs-apache/pull/2263) ([ekohl](https://github.com/ekohl))
- Use a stricter data type on apache::vhost::aliases [#2253](https://github.com/puppetlabs/puppetlabs-apache/pull/2253) ([ekohl](https://github.com/ekohl))
- Narrow down Datatypes [#2245](https://github.com/puppetlabs/puppetlabs-apache/pull/2245) ([cocker-cc](https://github.com/cocker-cc))
- (GH-cat-9) Update module to match current syntax standard [#2235](https://github.com/puppetlabs/puppetlabs-apache/pull/2235) ([david22swan](https://github.com/david22swan))
- Drop Apache 2.0 compatibility code [#2226](https://github.com/puppetlabs/puppetlabs-apache/pull/2226) ([ekohl](https://github.com/ekohl))
- (GH-iac-334) Remove code specific to unsupported OSs [#2223](https://github.com/puppetlabs/puppetlabs-apache/pull/2223) ([david22swan](https://github.com/david22swan))
- Remove warnings and plans to change vhost default naming [#2202](https://github.com/puppetlabs/puppetlabs-apache/pull/2202) ([ekohl](https://github.com/ekohl))
- Update modsec crs config and template [#2197](https://github.com/puppetlabs/puppetlabs-apache/pull/2197) ([henkworks](https://github.com/henkworks))

### Added

- Allow overriding CRS allowed HTTP methods per vhost [#2274](https://github.com/puppetlabs/puppetlabs-apache/pull/2274) ([Vincevrp](https://github.com/Vincevrp))
- Allow overriding CRS anomaly threshold per vhost [#2273](https://github.com/puppetlabs/puppetlabs-apache/pull/2273) ([Vincevrp](https://github.com/Vincevrp))
-  Allow configuring SecRequestBodyAccess and SecResponseBodyAccess [#2272](https://github.com/puppetlabs/puppetlabs-apache/pull/2272) ([Vincevrp](https://github.com/Vincevrp))
- Allow configuring CRS paranoia level [#2270](https://github.com/puppetlabs/puppetlabs-apache/pull/2270) ([Vincevrp](https://github.com/Vincevrp))
- Automatically include modules used in vhost directories [#2255](https://github.com/puppetlabs/puppetlabs-apache/pull/2255) ([ekohl](https://github.com/ekohl))
- Clean up includes and templates in vhost.pp [#2254](https://github.com/puppetlabs/puppetlabs-apache/pull/2254) ([ekohl](https://github.com/ekohl))
- pdksync - (GH-cat-12) Add Support for Redhat 9 [#2239](https://github.com/puppetlabs/puppetlabs-apache/pull/2239) ([david22swan](https://github.com/david22swan))
- Add support for PassengerPreloadBundler [#2233](https://github.com/puppetlabs/puppetlabs-apache/pull/2233) ([smortex](https://github.com/smortex))
- apache::vhost ProxyPassMatch in Location containers [#2222](https://github.com/puppetlabs/puppetlabs-apache/pull/2222) ([skylar2-uw](https://github.com/skylar2-uw))
- Allow additional settings for GSSAPI in Vhost [#2215](https://github.com/puppetlabs/puppetlabs-apache/pull/2215) ([tuxmea](https://github.com/tuxmea))
- mod_auth_gssapi: Add support for every configuration directive [#2214](https://github.com/puppetlabs/puppetlabs-apache/pull/2214) ([canth1](https://github.com/canth1))
- mod_auth_gssapi: Add support for `GssapiBasicAuth`. [#2212](https://github.com/puppetlabs/puppetlabs-apache/pull/2212) ([olifre](https://github.com/olifre))
- pdksync - (IAC-1753) - Add Support for AlmaLinux 8 [#2200](https://github.com/puppetlabs/puppetlabs-apache/pull/2200) ([david22swan](https://github.com/david22swan))
- Add support for setting UserDir in Virual Hosts [#2192](https://github.com/puppetlabs/puppetlabs-apache/pull/2192) ([smortex](https://github.com/smortex))
- Add an apache::vhost::proxy define [#2169](https://github.com/puppetlabs/puppetlabs-apache/pull/2169) ([wbclark](https://github.com/wbclark))

### Fixed

- Disable mod_php on EL9 [#2277](https://github.com/puppetlabs/puppetlabs-apache/pull/2277) ([ekohl](https://github.com/ekohl))
- Allow vhosts to have a string priority again [#2275](https://github.com/puppetlabs/puppetlabs-apache/pull/2275) ([ekohl](https://github.com/ekohl))
- Remove duplicate SecDefaultAction in CRS template [#2271](https://github.com/puppetlabs/puppetlabs-apache/pull/2271) ([Vincevrp](https://github.com/Vincevrp))
- Better data types on apache::vhost parameters [#2252](https://github.com/puppetlabs/puppetlabs-apache/pull/2252) ([ekohl](https://github.com/ekohl))
- Update $timeout to `Variant[Integer,String]` [#2242](https://github.com/puppetlabs/puppetlabs-apache/pull/2242) ([david22swan](https://github.com/david22swan))
- Let limitreqfieldsize and limitreqfields be integers [#2240](https://github.com/puppetlabs/puppetlabs-apache/pull/2240) ([traylenator](https://github.com/traylenator))
- Drop support for Fedora < 18 [#2238](https://github.com/puppetlabs/puppetlabs-apache/pull/2238) ([ekohl](https://github.com/ekohl))
- Restructure MPM disabling [#2227](https://github.com/puppetlabs/puppetlabs-apache/pull/2227) ([ekohl](https://github.com/ekohl))
- pdksync - (GH-iac-334) Remove Support for Ubuntu 16.04 [#2220](https://github.com/puppetlabs/puppetlabs-apache/pull/2220) ([david22swan](https://github.com/david22swan))
- Drop Apache 2.2 support with Gentoo [#2216](https://github.com/puppetlabs/puppetlabs-apache/pull/2216) ([ekohl](https://github.com/ekohl))
- pdksync - (IAC-1787) Remove Support for CentOS 6 [#2213](https://github.com/puppetlabs/puppetlabs-apache/pull/2213) ([david22swan](https://github.com/david22swan))

## [v7.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v7.0.0) - 2021-10-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.5.1...v7.0.0)

### Changed

- Drop Debian < 8 and Ubuntu < 14.04 code [#2189](https://github.com/puppetlabs/puppetlabs-apache/pull/2189) ([ekohl](https://github.com/ekohl))
- Drop support and compatibility for Debian < 9 and Ubuntu < 16.04 [#2123](https://github.com/puppetlabs/puppetlabs-apache/pull/2123) ([ekohl](https://github.com/ekohl))

### Added

- pdksync - (IAC-1751) - Add Support for Rocky 8 [#2196](https://github.com/puppetlabs/puppetlabs-apache/pull/2196) ([david22swan](https://github.com/david22swan))
- Allow `docroot` with `mod_vhost_alias` `virtual_docroot` [#2195](https://github.com/puppetlabs/puppetlabs-apache/pull/2195) ([yakatz](https://github.com/yakatz))

### Fixed

- Restore Ubuntu 14.04 support in suphp [#2193](https://github.com/puppetlabs/puppetlabs-apache/pull/2193) ([ekohl](https://github.com/ekohl))
- add double quote on scope parameter [#2191](https://github.com/puppetlabs/puppetlabs-apache/pull/2191) ([aba-rechsteiner](https://github.com/aba-rechsteiner))
- Debian 11: fix typo in `versioncmp()` / set default php to 7.4 [#2186](https://github.com/puppetlabs/puppetlabs-apache/pull/2186) ([bastelfreak](https://github.com/bastelfreak))

## [v6.5.1](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.5.1) - 2021-08-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.5.0...v6.5.1)

### Fixed

- (maint) Allow stdlib 8.0.0 [#2184](https://github.com/puppetlabs/puppetlabs-apache/pull/2184) ([smortex](https://github.com/smortex))

## [v6.5.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.5.0) - 2021-08-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.4.0...v6.5.0)

### Added

- pdksync - (IAC-1709) - Add Support for Debian 11 [#2180](https://github.com/puppetlabs/puppetlabs-apache/pull/2180) ([david22swan](https://github.com/david22swan))

## [v6.4.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.4.0) - 2021-08-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.3.1...v6.4.0)

### Added

- (MODULES-11075) Improve future version handling for RHEL [#2174](https://github.com/puppetlabs/puppetlabs-apache/pull/2174) ([mwhahaha](https://github.com/mwhahaha))
- Allow custom userdir directives [#2164](https://github.com/puppetlabs/puppetlabs-apache/pull/2164) ([hunner](https://github.com/hunner))
- Add feature to reload apache service when content of ssl files has changed [#2157](https://github.com/puppetlabs/puppetlabs-apache/pull/2157) ([timdeluxe](https://github.com/timdeluxe))

## [v6.3.1](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.3.1) - 2021-07-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.3.0...v6.3.1)

### Fixed

- (MODULES-10899) Load php module with the right libphp file [#2166](https://github.com/puppetlabs/puppetlabs-apache/pull/2166) ([sheenaajay](https://github.com/sheenaajay))
- (maint) Fix puppet-strings docs on apache::vhost [#2165](https://github.com/puppetlabs/puppetlabs-apache/pull/2165) ([ekohl](https://github.com/ekohl))

## [v6.3.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.3.0) - 2021-06-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/kps_ssl_reload_and_cache_disk_combined_tag...v6.3.0)

### Fixed

- Update the default version of Apache for Amazon Linux 2 [#2158](https://github.com/puppetlabs/puppetlabs-apache/pull/2158) ([turnopil](https://github.com/turnopil))
- Only warn about servername logging if relevant [#2154](https://github.com/puppetlabs/puppetlabs-apache/pull/2154) ([ekohl](https://github.com/ekohl))

## [kps_ssl_reload_and_cache_disk_combined_tag](https://github.com/puppetlabs/puppetlabs-apache/tree/kps_ssl_reload_and_cache_disk_combined_tag) - 2021-06-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.2.0...kps_ssl_reload_and_cache_disk_combined_tag)

### Added

- The default disk_cache.conf.erb caches everything.  [#2142](https://github.com/puppetlabs/puppetlabs-apache/pull/2142) ([Pawa2NR](https://github.com/Pawa2NR))

## [v6.2.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.2.0) - 2021-05-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.1.0...v6.2.0)

### Added

- (MODULES-11068) Allow apache::vhost ssl_honorcipherorder to take boolean parameter [#2152](https://github.com/puppetlabs/puppetlabs-apache/pull/2152) ([davidc](https://github.com/davidc))

## [v6.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.1.0) - 2021-05-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.0.1...v6.1.0)

### Added

- support for uri for severname with use_servername_for_filenames [#2150](https://github.com/puppetlabs/puppetlabs-apache/pull/2150) ([Zarne](https://github.com/Zarne))
- (MODULES-11061) mod_security custom rule functionality [#2145](https://github.com/puppetlabs/puppetlabs-apache/pull/2145) ([k2patel](https://github.com/k2patel))

## [v6.0.1](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.0.1) - 2021-05-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v6.0.0...v6.0.1)

### Fixed

- Fix HEADER* and README* wildcards in IndexIgnore [#2138](https://github.com/puppetlabs/puppetlabs-apache/pull/2138) ([keto](https://github.com/keto))
- Fix dav_svn for Debian 10 [#2135](https://github.com/puppetlabs/puppetlabs-apache/pull/2135) ([martijndegouw](https://github.com/martijndegouw))

## [v6.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v6.0.0) - 2021-03-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.10.0...v6.0.0)

### Changed

- pdksync - (MAINT) Remove SLES 11 support [#2132](https://github.com/puppetlabs/puppetlabs-apache/pull/2132) ([sanfrancrisko](https://github.com/sanfrancrisko))
- pdksync - Remove Puppet 5 from testing and bump minimal version to 6.0.0 [#2125](https://github.com/puppetlabs/puppetlabs-apache/pull/2125) ([carabasdaniel](https://github.com/carabasdaniel))

## [v5.10.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.10.0) - 2021-02-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.9.0...v5.10.0)

### Added

- (IAC-1186) Add $use_port_for_filenames parameter [#2122](https://github.com/puppetlabs/puppetlabs-apache/pull/2122) ([smortex](https://github.com/smortex))

### Fixed

- (MODULES-10899) Handle PHP8 MOD package naming convention changes [#2121](https://github.com/puppetlabs/puppetlabs-apache/pull/2121) ([sanfrancrisko](https://github.com/sanfrancrisko))

## [v5.9.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.9.0) - 2021-01-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.8.0...v5.9.0)

### Added

- Add ssl_user_name vhost parameter [#2093](https://github.com/puppetlabs/puppetlabs-apache/pull/2093) ([bodgit](https://github.com/bodgit))
- Add support for mod_md [#2090](https://github.com/puppetlabs/puppetlabs-apache/pull/2090) ([smortex](https://github.com/smortex))

### Fixed

- (FIX) Correct PHP packages on Ubuntu 16.04 [#2111](https://github.com/puppetlabs/puppetlabs-apache/pull/2111) ([ekohl](https://github.com/ekohl))

## [v5.8.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.8.0) - 2020-12-07

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.7.0...v5.8.0)

### Added

- (MODULES-10887) Set `use_servername_for_filenames` for defaults [#2103](https://github.com/puppetlabs/puppetlabs-apache/pull/2103) ([towo](https://github.com/towo))
- pdksync - (feat) Add support for Puppet 7 [#2101](https://github.com/puppetlabs/puppetlabs-apache/pull/2101) ([daianamezdrea](https://github.com/daianamezdrea))
- (feat) Add support for apreq2 MOD on Debian 9, 10 [#2085](https://github.com/puppetlabs/puppetlabs-apache/pull/2085) ([TigerKirika](https://github.com/TigerKirika))

### Fixed

- (fix) Convert unnecessary multi line warnings to single lines [#2104](https://github.com/puppetlabs/puppetlabs-apache/pull/2104) ([rj667](https://github.com/rj667))
- Fix bool2httpd function call for older ruby versions [#2102](https://github.com/puppetlabs/puppetlabs-apache/pull/2102) ([carabasdaniel](https://github.com/carabasdaniel))

## [v5.7.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.7.0) - 2020-11-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.6.0...v5.7.0)

### Added

- Add cas_cookie_path in vhosts [#2089](https://github.com/puppetlabs/puppetlabs-apache/pull/2089) ([yakatz](https://github.com/yakatz))
- (IAC-1186) Add new $use_servername_for_filenames parameter [#2086](https://github.com/puppetlabs/puppetlabs-apache/pull/2086) ([sanfrancrisko](https://github.com/sanfrancrisko))
- Allow relative paths in oidc_redirect_uri [#2082](https://github.com/puppetlabs/puppetlabs-apache/pull/2082) ([sanfrancrisko](https://github.com/sanfrancrisko))
- Improve SSLVerify options [#2081](https://github.com/puppetlabs/puppetlabs-apache/pull/2081) ([bovy89](https://github.com/bovy89))
- Change icon path [#2079](https://github.com/puppetlabs/puppetlabs-apache/pull/2079) ([yakatz](https://github.com/yakatz))
- Support mod_auth_gssapi parameters [#2078](https://github.com/puppetlabs/puppetlabs-apache/pull/2078) ([traylenator](https://github.com/traylenator))
- Add ssl_proxy_machine_cert_chain param to vhost class [#2072](https://github.com/puppetlabs/puppetlabs-apache/pull/2072) ([AbelNavarro](https://github.com/AbelNavarro))

### Fixed

- Use Ruby 2.7 compatible string matching [#2074](https://github.com/puppetlabs/puppetlabs-apache/pull/2074) ([sanfrancrisko](https://github.com/sanfrancrisko))

## [v5.6.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.6.0) - 2020-10-05

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.5.0...v5.6.0)

### Added

- Configure default shared lib path for mod_wsgi on RHEL8 [#2063](https://github.com/puppetlabs/puppetlabs-apache/pull/2063) ([nbarrientos](https://github.com/nbarrientos))
- Various enhancements to apache::mod::passenger [#2058](https://github.com/puppetlabs/puppetlabs-apache/pull/2058) ([smortex](https://github.com/smortex))

### Fixed

- make apache::mod::fcgid redhat 8 compatible [#2071](https://github.com/puppetlabs/puppetlabs-apache/pull/2071) ([creativefre](https://github.com/creativefre))
- pdksync - (feat) - Removal of inappropriate terminology [#2062](https://github.com/puppetlabs/puppetlabs-apache/pull/2062) ([pmcmaw](https://github.com/pmcmaw))
- Use Ruby 2.7 compatible string matching [#2060](https://github.com/puppetlabs/puppetlabs-apache/pull/2060) ([ekohl](https://github.com/ekohl))
- Use python3-mod_wsgi instead of mod_wsgi on CentOS8 [#2052](https://github.com/puppetlabs/puppetlabs-apache/pull/2052) ([kajinamit](https://github.com/kajinamit))

## [v5.5.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.5.0) - 2020-07-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.4.0...v5.5.0)

### Added

- Allow IPv6 CIDRs for proxy_protocol_exceptions in mod remoteip [#2033](https://github.com/puppetlabs/puppetlabs-apache/pull/2033) ([thechristschn](https://github.com/thechristschn))
- (IAC-746) - Add ubuntu 20.04 support [#2032](https://github.com/puppetlabs/puppetlabs-apache/pull/2032) ([david22swan](https://github.com/david22swan))
- Replace legacy `bool2httpd()` function with shim [#2025](https://github.com/puppetlabs/puppetlabs-apache/pull/2025) ([alexjfisher](https://github.com/alexjfisher))
- Tidy up `pw_hash` function [#2024](https://github.com/puppetlabs/puppetlabs-apache/pull/2024) ([alexjfisher](https://github.com/alexjfisher))
- Replace validate_apache_loglevel() with data type [#2023](https://github.com/puppetlabs/puppetlabs-apache/pull/2023) ([alexjfisher](https://github.com/alexjfisher))
- Add ProxyIOBufferSize option [#2014](https://github.com/puppetlabs/puppetlabs-apache/pull/2014) ([jplindquist](https://github.com/jplindquist))
- Add support for SetInputFilter directive [#2007](https://github.com/puppetlabs/puppetlabs-apache/pull/2007) ([HoucemEddine](https://github.com/HoucemEddine))
- [MODULES-10530] Add request limiting directives on virtual host level [#1996](https://github.com/puppetlabs/puppetlabs-apache/pull/1996) ([aursu](https://github.com/aursu))
- [MODULES-10528] Add ErrorLogFormat directive on virtual host level [#1995](https://github.com/puppetlabs/puppetlabs-apache/pull/1995) ([aursu](https://github.com/aursu))
- Add template variables and parameters for ModSecurity Audit Logs [#1988](https://github.com/puppetlabs/puppetlabs-apache/pull/1988) ([jplindquist](https://github.com/jplindquist))
- (MODULES-10432) Add mod_auth_openidc support [#1987](https://github.com/puppetlabs/puppetlabs-apache/pull/1987) ([asieraguado](https://github.com/asieraguado))

### Fixed

- (MODULES-10712) Fix mod_ldap on RH/CentOS 5 and 6 [#2041](https://github.com/puppetlabs/puppetlabs-apache/pull/2041) ([h-haaks](https://github.com/h-haaks))
- Update mod_dir, alias_icons_path, error_documents_path for CentOS 8 [#2038](https://github.com/puppetlabs/puppetlabs-apache/pull/2038) ([initrd](https://github.com/initrd))
- Ensure switching of thread module works on Debian 10 / Ubuntu 20.04 [#2034](https://github.com/puppetlabs/puppetlabs-apache/pull/2034) ([tuxmea](https://github.com/tuxmea))
- MODULES-10586 Centos 8: wrong package used to install mod_authnz_ldap [#2021](https://github.com/puppetlabs/puppetlabs-apache/pull/2021) ([farebers](https://github.com/farebers))
- Re-add package for fcgid on debian/ubuntu machines [#2006](https://github.com/puppetlabs/puppetlabs-apache/pull/2006) ([vStone](https://github.com/vStone))
- Use ldap_trusted_mode in conditional [#1999](https://github.com/puppetlabs/puppetlabs-apache/pull/1999) ([dacron](https://github.com/dacron))
- Typo in oidcsettings.pp [#1997](https://github.com/puppetlabs/puppetlabs-apache/pull/1997) ([asieraguado](https://github.com/asieraguado))
- Fix proxy_html Module to work on Debian 10 [#1994](https://github.com/puppetlabs/puppetlabs-apache/pull/1994) ([buchstabensalat](https://github.com/buchstabensalat))
- (MODULES-10360) Fix icon paths for RedHat systems [#1991](https://github.com/puppetlabs/puppetlabs-apache/pull/1991) ([2and3makes23](https://github.com/2and3makes23))
- SSLProxyEngine on has to be set before any Proxydirective using it [#1989](https://github.com/puppetlabs/puppetlabs-apache/pull/1989) ([zivis](https://github.com/zivis))

## [v5.4.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.4.0) - 2020-01-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.3.0...v5.4.0)

### Added

- Add an apache::vhost::fragment define [#1980](https://github.com/puppetlabs/puppetlabs-apache/pull/1980) ([ekohl](https://github.com/ekohl))

### Fixed

- (MODULES-10391) ssl_protocol includes SSLv2 and SSLv3 on all platforms [#1990](https://github.com/puppetlabs/puppetlabs-apache/pull/1990) ([legooolas](https://github.com/legooolas))

## [v5.3.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.3.0) - 2019-12-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.2.0...v5.3.0)

### Added

- (FM-8672) - Addition of Support for CentOS 8 [#1977](https://github.com/puppetlabs/puppetlabs-apache/pull/1977) ([david22swan](https://github.com/david22swan))
- (MODULES-9948) Allow switching of thread modules [#1961](https://github.com/puppetlabs/puppetlabs-apache/pull/1961) ([tuxmea](https://github.com/tuxmea))

### Fixed

- Fix newline being added before proxy params [#1984](https://github.com/puppetlabs/puppetlabs-apache/pull/1984) ([oxc](https://github.com/oxc))
- When using mod jk, we expect the libapache2-mod-jk package to be installed [#1979](https://github.com/puppetlabs/puppetlabs-apache/pull/1979) ([tuxmea](https://github.com/tuxmea))
- move unless into manage_security_corerules [#1976](https://github.com/puppetlabs/puppetlabs-apache/pull/1976) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- Change mod_proxy's ProxyTimeout to follow Apache's global timeout [#1975](https://github.com/puppetlabs/puppetlabs-apache/pull/1975) ([gcoxmoz](https://github.com/gcoxmoz))
- (FM-8721) fix php version and ssl error on redhat8 [#1973](https://github.com/puppetlabs/puppetlabs-apache/pull/1973) ([sheenaajay](https://github.com/sheenaajay))

## [v5.2.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.2.0) - 2019-11-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.1.0...v5.2.0)

### Added

- Add parameter version for mod security [#1953](https://github.com/puppetlabs/puppetlabs-apache/pull/1953) ([tuxmea](https://github.com/tuxmea))
- add possibility to define variables inside VirtualHost definition [#1947](https://github.com/puppetlabs/puppetlabs-apache/pull/1947) ([trefzer](https://github.com/trefzer))

### Fixed

- (FM-8662) Correction in manifests/mod/ssl.pp for SLES 11 [#1963](https://github.com/puppetlabs/puppetlabs-apache/pull/1963) ([sanfrancrisko](https://github.com/sanfrancrisko))
- always quote ExpiresDefault in vhost::directories [#1958](https://github.com/puppetlabs/puppetlabs-apache/pull/1958) ([evgeni](https://github.com/evgeni))
- MODULES-9904 Fix lbmethod module load order [#1956](https://github.com/puppetlabs/puppetlabs-apache/pull/1956) ([optiz0r](https://github.com/optiz0r))
- Add owner, group, file_mode and show_diff to apache::custom_config [#1942](https://github.com/puppetlabs/puppetlabs-apache/pull/1942) ([treydock](https://github.com/treydock))
- Add shibboleth support for Debian 10 [#1939](https://github.com/puppetlabs/puppetlabs-apache/pull/1939) ([fabbks](https://github.com/fabbks))

## [v5.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.1.0) - 2019-09-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/v5.0.0...v5.1.0)

### Added

- (FM-8393) add support on Debian 10 [#1945](https://github.com/puppetlabs/puppetlabs-apache/pull/1945) ([ThoughtCrhyme](https://github.com/ThoughtCrhyme))
- FM-8140 Add Redhat 8 support [#1941](https://github.com/puppetlabs/puppetlabs-apache/pull/1941) ([sheenaajay](https://github.com/sheenaajay))
- (FM-8214) converted to use litmus [#1938](https://github.com/puppetlabs/puppetlabs-apache/pull/1938) ([tphoney](https://github.com/tphoney))
- (MODULES-9668 ) Please make ProxyRequests setting in vhost.pp configurable [#1935](https://github.com/puppetlabs/puppetlabs-apache/pull/1935) ([aukesj](https://github.com/aukesj))
- Added unmanaged_path and custom_fragment options to userdir [#1931](https://github.com/puppetlabs/puppetlabs-apache/pull/1931) ([GeorgeCox](https://github.com/GeorgeCox))
- Add LDAP parameters to httpd.conf [#1930](https://github.com/puppetlabs/puppetlabs-apache/pull/1930) ([daveseff](https://github.com/daveseff))
- Add LDAPReferrals configuration parameter [#1928](https://github.com/puppetlabs/puppetlabs-apache/pull/1928) ([HT43-bqxFqB](https://github.com/HT43-bqxFqB))

### Fixed

- (MODULES-9104) Add file_mode to config files. [#1922](https://github.com/puppetlabs/puppetlabs-apache/pull/1922) ([stevegarn](https://github.com/stevegarn))
- (bugfix) Add default package name for mod_ldap [#1913](https://github.com/puppetlabs/puppetlabs-apache/pull/1913) ([turnopil](https://github.com/turnopil))
- Remove event mpm when using prefork, worker or itk [#1905](https://github.com/puppetlabs/puppetlabs-apache/pull/1905) ([tuxmea](https://github.com/tuxmea))

## [v5.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/v5.0.0) - 2019-05-20

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/4.1.0...v5.0.0)

### Changed

- pdksync - (MODULES-8444) - Raise lower Puppet bound [#1908](https://github.com/puppetlabs/puppetlabs-apache/pull/1908) ([david22swan](https://github.com/david22swan))

### Added

- (FM-7923) Implement Puppet Strings [#1916](https://github.com/puppetlabs/puppetlabs-apache/pull/1916) ([eimlav](https://github.com/eimlav))
- Define SCL package name for mod_ldap [#1893](https://github.com/puppetlabs/puppetlabs-apache/pull/1893) ([treydock](https://github.com/treydock))

### Fixed

- (MODULES-9014) Improve SSLSessionTickets handling [#1923](https://github.com/puppetlabs/puppetlabs-apache/pull/1923) ([FredL69](https://github.com/FredL69))
- (MODULES-8931) Fix stahnma/epel failures [#1914](https://github.com/puppetlabs/puppetlabs-apache/pull/1914) ([eimlav](https://github.com/eimlav))
- Fix wsgi_daemon_process to support hash data type [#1884](https://github.com/puppetlabs/puppetlabs-apache/pull/1884) ([mdechiaro](https://github.com/mdechiaro))

## [4.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/4.1.0) - 2019-04-05

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/4.0.0...4.1.0)

### Added

- (MODULES-7196) Allow setting CASRootProxiedAs per virtualhost (replaces #1857) [#1900](https://github.com/puppetlabs/puppetlabs-apache/pull/1900) ([Lavinia-Dan](https://github.com/Lavinia-Dan))
- (feat) - Amazon Linux 2 compatibility added [#1898](https://github.com/puppetlabs/puppetlabs-apache/pull/1898) ([david22swan](https://github.com/david22swan))
- (MODULES-8731) Allow CIDRs for proxy_ips/internal_proxy in remoteip [#1891](https://github.com/puppetlabs/puppetlabs-apache/pull/1891) ([JAORMX](https://github.com/JAORMX))
- Manage all mod_remoteip parameters supported by Apache [#1882](https://github.com/puppetlabs/puppetlabs-apache/pull/1882) ([johanfleury](https://github.com/johanfleury))
- MODULES-8541 : Allow HostnameLookups to be modified [#1881](https://github.com/puppetlabs/puppetlabs-apache/pull/1881) ([k2patel](https://github.com/k2patel))
- Add support for mod_http2 [#1867](https://github.com/puppetlabs/puppetlabs-apache/pull/1867) ([smortex](https://github.com/smortex))
- Added code to paramertize the libphp prefix [#1852](https://github.com/puppetlabs/puppetlabs-apache/pull/1852) ([grahamuk2018](https://github.com/grahamuk2018))
- Added WSGI Options WSGIApplicationGroup and WSGIPythonOptimize [#1847](https://github.com/puppetlabs/puppetlabs-apache/pull/1847) ([emetriqLikedeeler](https://github.com/emetriqLikedeeler))

### Fixed

- (bugfix) set kernel for facter version test [#1895](https://github.com/puppetlabs/puppetlabs-apache/pull/1895) ([tphoney](https://github.com/tphoney))
- (MODULES-5990) - Managing conf_enabled [#1875](https://github.com/puppetlabs/puppetlabs-apache/pull/1875) ([david22swan](https://github.com/david22swan))

## [4.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/4.0.0) - 2019-01-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/3.5.0...4.0.0)

### Changed

- default server_tokens to prod - more secure default [#1746](https://github.com/puppetlabs/puppetlabs-apache/pull/1746) ([juju4](https://github.com/juju4))

### Added

- (Modules 8141/Modules 8379) - Addition of support for SLES 15 [#1862](https://github.com/puppetlabs/puppetlabs-apache/pull/1862) ([david22swan](https://github.com/david22swan))

### Fixed

- (MODULES-5990) - conf-enabled defaulted to undef [#1869](https://github.com/puppetlabs/puppetlabs-apache/pull/1869) ([david22swan](https://github.com/david22swan))
- pdksync - (FM-7655) Fix rubygems-update for ruby < 2.3 [#1866](https://github.com/puppetlabs/puppetlabs-apache/pull/1866) ([tphoney](https://github.com/tphoney))

## [3.5.0](https://github.com/puppetlabs/puppetlabs-apache/tree/3.5.0) - 2018-12-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/3.4.0...3.5.0)

### Added

- (MODULES-5990) Addition of 'IncludeOptional conf-enabled/*.conf' to apache2.conf' on Debian Family OS [#1851](https://github.com/puppetlabs/puppetlabs-apache/pull/1851) ([david22swan](https://github.com/david22swan))
- (MODULES-8107) - Support added for Ubuntu 18.04. [#1850](https://github.com/puppetlabs/puppetlabs-apache/pull/1850) ([david22swan](https://github.com/david22swan))
- (MODULES-8108) - Support added for Debian 9 [#1849](https://github.com/puppetlabs/puppetlabs-apache/pull/1849) ([david22swan](https://github.com/david22swan))
- Add option to add comments to the header of a vhost file [#1841](https://github.com/puppetlabs/puppetlabs-apache/pull/1841) ([jovandeginste](https://github.com/jovandeginste))
- SCL support for httpd and php7.1 [#1822](https://github.com/puppetlabs/puppetlabs-apache/pull/1822) ([mmoll](https://github.com/mmoll))

### Fixed

- (FM-7605) - Disabling conf_enabled on Ubuntu 18.04  by default as it conflicts with Shibboleth causing errors with apache2. [#1856](https://github.com/puppetlabs/puppetlabs-apache/pull/1856) ([david22swan](https://github.com/david22swan))
- (MODULES-8429) Update GPG key for phusion passenger [#1848](https://github.com/puppetlabs/puppetlabs-apache/pull/1848) ([abottchen](https://github.com/abottchen))
- Fix default vhost priority in readme [#1843](https://github.com/puppetlabs/puppetlabs-apache/pull/1843) ([HT43-bqxFqB](https://github.com/HT43-bqxFqB))
- fix apache::mod::jk example typo and add link for more info [#1812](https://github.com/puppetlabs/puppetlabs-apache/pull/1812) ([xorpaul](https://github.com/xorpaul))
- MODULES-7379: Fixing syntax by adding newline [#1803](https://github.com/puppetlabs/puppetlabs-apache/pull/1803) ([wimvr](https://github.com/wimvr))
- ensure mpm_event is disabled under debian 9 if mpm itk is used [#1766](https://github.com/puppetlabs/puppetlabs-apache/pull/1766) ([zivis](https://github.com/zivis))

## [3.4.0](https://github.com/puppetlabs/puppetlabs-apache/tree/3.4.0) - 2018-09-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/3.3.0...3.4.0)

### Added

- pdksync - (FM-7392) - Puppet 6 Testing Changes [#1838](https://github.com/puppetlabs/puppetlabs-apache/pull/1838) ([pmcmaw](https://github.com/pmcmaw))
- pdksync - (MODULES-6805) metadata.json shows support for puppet 6 [#1836](https://github.com/puppetlabs/puppetlabs-apache/pull/1836) ([tphoney](https://github.com/tphoney))

### Fixed

- Fix "audit_log_relevant_status" typo in README.md [#1830](https://github.com/puppetlabs/puppetlabs-apache/pull/1830) ([smokris](https://github.com/smokris))

## [3.3.0](https://github.com/puppetlabs/puppetlabs-apache/tree/3.3.0) - 2018-09-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/3.2.0...3.3.0)

### Added

- pdksync - (MODULES-7705) - Bumping stdlib dependency from < 5.0.0 to < 6.0.0 [#1821](https://github.com/puppetlabs/puppetlabs-apache/pull/1821) ([pmcmaw](https://github.com/pmcmaw))
- Add support for ProxyTimeout [#1805](https://github.com/puppetlabs/puppetlabs-apache/pull/1805) ([agoodno](https://github.com/agoodno))
- Rework passenger VHost and Directories [#1778](https://github.com/puppetlabs/puppetlabs-apache/pull/1778) ([smortex](https://github.com/smortex))

### Fixed

- MODULES-7575 reverse sort the aliases [#1808](https://github.com/puppetlabs/puppetlabs-apache/pull/1808) ([k2patel](https://github.com/k2patel))

## [3.2.0](https://github.com/puppetlabs/puppetlabs-apache/tree/3.2.0) - 2018-06-29

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/3.1.0...3.2.0)

### Added

- (MODULES-7343) - Allow overrides by adding mod_libs in apache class [#1800](https://github.com/puppetlabs/puppetlabs-apache/pull/1800) ([karelyatin](https://github.com/karelyatin))
- Allow `apache::mod::passenger::passenger_pre_start` to accept multiple URIs [#1776](https://github.com/puppetlabs/puppetlabs-apache/pull/1776) ([smortex](https://github.com/smortex))

### Fixed

- fixes for OpenSUSE ans SLES [#1783](https://github.com/puppetlabs/puppetlabs-apache/pull/1783) ([tuxmea](https://github.com/tuxmea))

## [3.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/3.1.0) - 2018-03-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/3.0.0...3.1.0)

### Added

- Allow overriding passenger_group in apache::vhost [#1769](https://github.com/puppetlabs/puppetlabs-apache/pull/1769) ([smortex](https://github.com/smortex))

## [3.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/3.0.0) - 2018-02-20

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/2.3.1...3.0.0)

## [2.3.1](https://github.com/puppetlabs/puppetlabs-apache/tree/2.3.1) - 2018-02-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/2.3.0...2.3.1)

### Added

- Add LimitRequestFields parameter in main configuration [#1742](https://github.com/puppetlabs/puppetlabs-apache/pull/1742) ([geekix](https://github.com/geekix))
- Add enable capabilities to itk [#1687](https://github.com/puppetlabs/puppetlabs-apache/pull/1687) ([edestecd](https://github.com/edestecd))
- updated log formats to include client ip [#1686](https://github.com/puppetlabs/puppetlabs-apache/pull/1686) ([tenajsystems](https://github.com/tenajsystems))
- MODULES-5452 - add $options to `balancer` type [#1668](https://github.com/puppetlabs/puppetlabs-apache/pull/1668) ([cedef](https://github.com/cedef))
- [Modules 5385] Include support for Apache 2.4 mod_authz_host directives in apache::mod::status [#1667](https://github.com/puppetlabs/puppetlabs-apache/pull/1667) ([EmersonPrado](https://github.com/EmersonPrado))
- Expose loadfile_name option to mod::python class [#1663](https://github.com/puppetlabs/puppetlabs-apache/pull/1663) ([traylenator](https://github.com/traylenator))
- Add ShibCompatValidUser option to vhost config [#1657](https://github.com/puppetlabs/puppetlabs-apache/pull/1657) ([mdechiaro](https://github.com/mdechiaro))

### Fixed

- Fix typos [#1728](https://github.com/puppetlabs/puppetlabs-apache/pull/1728) ([hfm](https://github.com/hfm))
- [MODULES-5644] Package name is libapache2-mpm-itk for Debian 9 [#1724](https://github.com/puppetlabs/puppetlabs-apache/pull/1724) ([zivis](https://github.com/zivis))
- Fix case of setting apache::mpm_module to false [#1720](https://github.com/puppetlabs/puppetlabs-apache/pull/1720) ([edestecd](https://github.com/edestecd))
- remoteip: Notify apache::service instead of service['httpd'] [#1684](https://github.com/puppetlabs/puppetlabs-apache/pull/1684) ([sergiik](https://github.com/sergiik))

## [2.3.0](https://github.com/puppetlabs/puppetlabs-apache/tree/2.3.0) - 2017-10-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/2.2.0...2.3.0)

## [2.2.0](https://github.com/puppetlabs/puppetlabs-apache/tree/2.2.0) - 2017-10-05

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/2.1.0...2.2.0)

### Added

- (MODULES-2062) updates prefork.conf params for apache 2.4 [#1685](https://github.com/puppetlabs/puppetlabs-apache/pull/1685) ([eputnam](https://github.com/eputnam))
- MODULES-5426 : Add support for all mod_passenger server config settings	 [#1665](https://github.com/puppetlabs/puppetlabs-apache/pull/1665) ([dacat](https://github.com/dacat))

### Fixed

- Wsgi inclusion [#1702](https://github.com/puppetlabs/puppetlabs-apache/pull/1702) ([willmeek](https://github.com/willmeek))
- MODULES-5649 Do not install mod_fastcgi on el7 [#1701](https://github.com/puppetlabs/puppetlabs-apache/pull/1701) ([tphoney](https://github.com/tphoney))

## [2.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/2.1.0) - 2017-09-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.11.1...2.1.0)

## [1.11.1](https://github.com/puppetlabs/puppetlabs-apache/tree/1.11.1) - 2017-09-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/2.0.0...1.11.1)

### Added

- [Modules 5519] Add port parameter in class mod::jk [#1679](https://github.com/puppetlabs/puppetlabs-apache/pull/1679) ([EmersonPrado](https://github.com/EmersonPrado))
- (MODULES-3942) make sure mod_alias is loaded with redirectmatch [#1675](https://github.com/puppetlabs/puppetlabs-apache/pull/1675) ([eputnam](https://github.com/eputnam))
- [Modules 5492] - Include treatment for absolute, relative and pipe paths for JkLogFile and JkShmFile for class mod::jk [#1671](https://github.com/puppetlabs/puppetlabs-apache/pull/1671) ([EmersonPrado](https://github.com/EmersonPrado))
- Replace deprecated type checking with Puppet 4 types [#1670](https://github.com/puppetlabs/puppetlabs-apache/pull/1670) ([ekohl](https://github.com/ekohl))
- [Modules 4746] Creates class for managing Apache mod_jk connector [#1630](https://github.com/puppetlabs/puppetlabs-apache/pull/1630) ([EmersonPrado](https://github.com/EmersonPrado))
- Adds apache::mod::macro [#1590](https://github.com/puppetlabs/puppetlabs-apache/pull/1590) ([kyledecot](https://github.com/kyledecot))

### Fixed

- Setup SSL/TLS client auth without overly broad trusts for client certificates [#1680](https://github.com/puppetlabs/puppetlabs-apache/pull/1680) ([epackorigan](https://github.com/epackorigan))

## [2.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/2.0.0) - 2017-07-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.11.0...2.0.0)

### Changed

- MODULES-4824: Update the version compatibility to >= 4.7.0 < 5.0.0 [#1628](https://github.com/puppetlabs/puppetlabs-apache/pull/1628) ([angrox](https://github.com/angrox))
- Migrate to puppet4 datatypes [#1621](https://github.com/puppetlabs/puppetlabs-apache/pull/1621) ([bastelfreak](https://github.com/bastelfreak))
- Set default keepalive to On [#1434](https://github.com/puppetlabs/puppetlabs-apache/pull/1434) ([sathieu](https://github.com/sathieu))

### Added

- (MODULES-4933) Allow custom UserDir string [#1650](https://github.com/puppetlabs/puppetlabs-apache/pull/1650) ([hunner](https://github.com/hunner))
- Add proxy_pass in directory template for location context [#1644](https://github.com/puppetlabs/puppetlabs-apache/pull/1644) ([toteva](https://github.com/toteva))
- Don't install proxy_html package in ubuntu xenial [#1643](https://github.com/puppetlabs/puppetlabs-apache/pull/1643) ([amateo](https://github.com/amateo))
- (MODULES-5121) Allow ssl.conf to have better defaults [#1636](https://github.com/puppetlabs/puppetlabs-apache/pull/1636) ([hunner](https://github.com/hunner))
- MODULES-3838 Pass mod_packages through init.pp to allow overrides [#1631](https://github.com/puppetlabs/puppetlabs-apache/pull/1631) ([optiz0r](https://github.com/optiz0r))
- MODULES-4946 Add HTTP protocol options support [#1629](https://github.com/puppetlabs/puppetlabs-apache/pull/1629) ([dspinellis](https://github.com/dspinellis))
- Use enclose_ipv6 function from stdlib [#1624](https://github.com/puppetlabs/puppetlabs-apache/pull/1624) ([acritox](https://github.com/acritox))
- (MODULES-4819) remove include_src parameter from vhost_spec [#1617](https://github.com/puppetlabs/puppetlabs-apache/pull/1617) ([eputnam](https://github.com/eputnam))
- MODULES-4816 - new param for mod::security class [#1616](https://github.com/puppetlabs/puppetlabs-apache/pull/1616) ([cedef](https://github.com/cedef))
- Add WSGIRestrictEmbedded to apache::mod::wsgi [#1614](https://github.com/puppetlabs/puppetlabs-apache/pull/1614) ([dsavineau](https://github.com/dsavineau))
- Enable configuring CA file in ssl.conf [#1612](https://github.com/puppetlabs/puppetlabs-apache/pull/1612) ([JAORMX](https://github.com/JAORMX))
- MODULES-4737 - Additional class params for mod ssl [#1611](https://github.com/puppetlabs/puppetlabs-apache/pull/1611) ([cedef](https://github.com/cedef))
- Added supplementary_groups to the user resource [#1608](https://github.com/puppetlabs/puppetlabs-apache/pull/1608) ([chgarling](https://github.com/chgarling))
- [msync] 786266 Implement puppet-module-gems, a45803 Remove metadata.json from locales config [#1606](https://github.com/puppetlabs/puppetlabs-apache/pull/1606) ([wilson208](https://github.com/wilson208))
- Limit except support [#1605](https://github.com/puppetlabs/puppetlabs-apache/pull/1605) ([ffapitalle](https://github.com/ffapitalle))
- (FM-6116) - Adding POT file for metadata.json [#1604](https://github.com/puppetlabs/puppetlabs-apache/pull/1604) ([pmcmaw](https://github.com/pmcmaw))
- [MODULES-4528] Replace Puppet.version.to_f version comparison from spec_helper.rb [#1603](https://github.com/puppetlabs/puppetlabs-apache/pull/1603) ([wilson208](https://github.com/wilson208))
- Add param for AllowOverride in the userdir.conf template [#1602](https://github.com/puppetlabs/puppetlabs-apache/pull/1602) ([dstepe](https://github.com/dstepe))
- Modules-4500 Add optional "AdvertiseFrequency" directive in cluster.conf template [#1601](https://github.com/puppetlabs/puppetlabs-apache/pull/1601) ([EmersonPrado](https://github.com/EmersonPrado))
- The base tag also needs link rewriting [#1599](https://github.com/puppetlabs/puppetlabs-apache/pull/1599) ([tobixen](https://github.com/tobixen))
- MODULES-4391 add SSLProxyVerifyDepth and SSLProxyCACertificateFile directives [#1596](https://github.com/puppetlabs/puppetlabs-apache/pull/1596) ([hex2a](https://github.com/hex2a))
- add parser function apache_pw_hash [#1592](https://github.com/puppetlabs/puppetlabs-apache/pull/1592) ([aptituz](https://github.com/aptituz))
- Add mod_{authnz_pam,intercept_form_submit,lookup_identity} [#1588](https://github.com/puppetlabs/puppetlabs-apache/pull/1588) ([ekohl](https://github.com/ekohl))
- Allow multiple ports per vhost [#1583](https://github.com/puppetlabs/puppetlabs-apache/pull/1583) ([tjikkun](https://github.com/tjikkun))
- Feature/add charset [#1582](https://github.com/puppetlabs/puppetlabs-apache/pull/1582) ([harakiri406](https://github.com/harakiri406))
- Add FileETag [#1581](https://github.com/puppetlabs/puppetlabs-apache/pull/1581) ([kuchosauronad0](https://github.com/kuchosauronad0))
- (MODULES-4156) adds RequestHeader directive to vhost template #puppethack [#1573](https://github.com/puppetlabs/puppetlabs-apache/pull/1573) ([eputnam](https://github.com/eputnam))
- add passenger_max_requests option per vhost [#1517](https://github.com/puppetlabs/puppetlabs-apache/pull/1517) ([pulecp](https://github.com/pulecp))

### Fixed

- Ensure that ProxyPreserveHost is set even when ProxyPass (etc) are not. [#1639](https://github.com/puppetlabs/puppetlabs-apache/pull/1639) ([tpdownes](https://github.com/tpdownes))
- When absolute path is specified for access_log_file/error_log_file, don't prepend logbase [#1633](https://github.com/puppetlabs/puppetlabs-apache/pull/1633) ([ca-asm](https://github.com/ca-asm))
- Fix single quoted string [#1623](https://github.com/puppetlabs/puppetlabs-apache/pull/1623) ([lordbink](https://github.com/lordbink))
- fixed apache group for SUSE/SLES Systems (checked for SLES11/12) [#1613](https://github.com/puppetlabs/puppetlabs-apache/pull/1613) ([pseiler](https://github.com/pseiler))
- the wsgi_script_aliases need to support array type of value [#1609](https://github.com/puppetlabs/puppetlabs-apache/pull/1609) ([netman2k](https://github.com/netman2k))
- Fix alignement in vhost.conf [#1607](https://github.com/puppetlabs/puppetlabs-apache/pull/1607) ([sathieu](https://github.com/sathieu))
- [apache::mod::cgi] Fix: ordering constraint for mod_cgi [#1585](https://github.com/puppetlabs/puppetlabs-apache/pull/1585) ([punycode](https://github.com/punycode))
- Fix vhost template [#1552](https://github.com/puppetlabs/puppetlabs-apache/pull/1552) ([iamspido](https://github.com/iamspido))

## [1.11.0](https://github.com/puppetlabs/puppetlabs-apache/tree/1.11.0) - 2016-12-19

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.10.0...1.11.0)

### Added

- (MODULES-4213) Adds spec test for rewrite_inherit [#1575](https://github.com/puppetlabs/puppetlabs-apache/pull/1575) ([bmjen](https://github.com/bmjen))
- Add ability to set SSLStaplingReturnResponderErrors on server level [#1571](https://github.com/puppetlabs/puppetlabs-apache/pull/1571) ([tjikkun](https://github.com/tjikkun))
- (MODULES-4213) Allow global rewrite rules inheritance in vhosts [#1569](https://github.com/puppetlabs/puppetlabs-apache/pull/1569) ([EmersonPrado](https://github.com/EmersonPrado))
- mod_proxy_balancer manager [#1562](https://github.com/puppetlabs/puppetlabs-apache/pull/1562) ([sathieu](https://github.com/sathieu))
- Add SSL stapling [#1561](https://github.com/puppetlabs/puppetlabs-apache/pull/1561) ([tjikkun](https://github.com/tjikkun))
- ModSec debug logs to use apache logroot parameter [#1560](https://github.com/puppetlabs/puppetlabs-apache/pull/1560) ([scottmullaly](https://github.com/scottmullaly))
- (MODULES-4049) SLES support [#1554](https://github.com/puppetlabs/puppetlabs-apache/pull/1554) ([eputnam](https://github.com/eputnam))
- Validate wsgi_chunked_request parameter for vhost [#1553](https://github.com/puppetlabs/puppetlabs-apache/pull/1553) ([JAORMX](https://github.com/JAORMX))
- (MODULES-4048) SLES 10 support [#1551](https://github.com/puppetlabs/puppetlabs-apache/pull/1551) ([eputnam](https://github.com/eputnam))
- Support Passenger repo on Amazon Linux [#1549](https://github.com/puppetlabs/puppetlabs-apache/pull/1549) ([seefood](https://github.com/seefood))
- Support parameter PassengerDataBufferDir [#1548](https://github.com/puppetlabs/puppetlabs-apache/pull/1548) ([seefood](https://github.com/seefood))
- Allow user to specify alternative package and library names for shibboleth module [#1547](https://github.com/puppetlabs/puppetlabs-apache/pull/1547) ([tpdownes](https://github.com/tpdownes))
- (FM-5739) removes mocha stubbing [#1540](https://github.com/puppetlabs/puppetlabs-apache/pull/1540) ([eputnam](https://github.com/eputnam))
- Adding requirement for httpd package [#1539](https://github.com/puppetlabs/puppetlabs-apache/pull/1539) ([jplindquist](https://github.com/jplindquist))
- Update modulesync_config [51f469d] [#1535](https://github.com/puppetlabs/puppetlabs-apache/pull/1535) ([DavidS](https://github.com/DavidS))
- Allow the proxy_via setting to be configured [#1534](https://github.com/puppetlabs/puppetlabs-apache/pull/1534) ([bmjen](https://github.com/bmjen))
- The meier move error log to params [#1533](https://github.com/puppetlabs/puppetlabs-apache/pull/1533) ([bmjen](https://github.com/bmjen))
- Add path to shibboleth lib [#1532](https://github.com/puppetlabs/puppetlabs-apache/pull/1532) ([gvdb1967](https://github.com/gvdb1967))
- Add rpaf.conf template parameter [#1531](https://github.com/puppetlabs/puppetlabs-apache/pull/1531) ([gvdb1967](https://github.com/gvdb1967))
- (MODULES-3712) SLES 11 Support [#1528](https://github.com/puppetlabs/puppetlabs-apache/pull/1528) ([eputnam](https://github.com/eputnam))
- Settings to control modcluster request size [#1527](https://github.com/puppetlabs/puppetlabs-apache/pull/1527) ([lexkastro](https://github.com/lexkastro))
- Allow no_proxy_uris to be used within proxy_pass [#1524](https://github.com/puppetlabs/puppetlabs-apache/pull/1524) ([df7cb](https://github.com/df7cb))
- Update modulesync_config [a3fe424] [#1519](https://github.com/puppetlabs/puppetlabs-apache/pull/1519) ([DavidS](https://github.com/DavidS))
- Update modulesync_config [0d59329] [#1518](https://github.com/puppetlabs/puppetlabs-apache/pull/1518) ([DavidS](https://github.com/DavidS))
- Add some more passenger params [#1510](https://github.com/puppetlabs/puppetlabs-apache/pull/1510) ([Reamer](https://github.com/Reamer))
- MODULES-3682 - config of auth_dbd, include dbd, allow AuthnProviderAlias [#1508](https://github.com/puppetlabs/puppetlabs-apache/pull/1508) ([johndixon](https://github.com/johndixon))
- mod_passenger: PassengerMaxInstancesPerApp option [#1503](https://github.com/puppetlabs/puppetlabs-apache/pull/1503) ([ygt-davidstirling](https://github.com/ygt-davidstirling))
- add force option to confd file resource [#1502](https://github.com/puppetlabs/puppetlabs-apache/pull/1502) ([martinpfeifer](https://github.com/martinpfeifer))
- Auto load Apache::Mod[slotmem_shm] and Apache::Mod[lbmethod_byrequest… [#1499](https://github.com/puppetlabs/puppetlabs-apache/pull/1499) ([sathieu](https://github.com/sathieu))
- Allow to set SecAuditLog [#1490](https://github.com/puppetlabs/puppetlabs-apache/pull/1490) ([sathieu](https://github.com/sathieu))
- Add wsgi script aliases match [#1485](https://github.com/puppetlabs/puppetlabs-apache/pull/1485) ([tphoney](https://github.com/tphoney))
- Add cas_cookie_path_mode param [#1475](https://github.com/puppetlabs/puppetlabs-apache/pull/1475) ([edestecd](https://github.com/edestecd))
- Added support for apache 2.4 on Amazon Linux [#1473](https://github.com/puppetlabs/puppetlabs-apache/pull/1473) ([lotjuh](https://github.com/lotjuh))
- Add apache::mod::socache_shmcb so it can be included multiple times [#1471](https://github.com/puppetlabs/puppetlabs-apache/pull/1471) ([mpdude](https://github.com/mpdude))
- Manage default root directory access rights [#1468](https://github.com/puppetlabs/puppetlabs-apache/pull/1468) ([smoeding](https://github.com/smoeding))
- Add apache::mod::proxy_wstunnel and tests [#1465](https://github.com/puppetlabs/puppetlabs-apache/pull/1465) ([DavidS](https://github.com/DavidS))
- Add apache::mod::proxy_wstunnel [#1462](https://github.com/puppetlabs/puppetlabs-apache/pull/1462) ([sathieu](https://github.com/sathieu))
- add additional directories options for LDAP Auth [#1443](https://github.com/puppetlabs/puppetlabs-apache/pull/1443) ([zivis](https://github.com/zivis))
- Update _block.erb [#1441](https://github.com/puppetlabs/puppetlabs-apache/pull/1441) ([jostmart](https://github.com/jostmart))
- Support the newer mod_auth_cas config options [#1436](https://github.com/puppetlabs/puppetlabs-apache/pull/1436) ([pcfens](https://github.com/pcfens))
- Wrap mod_security directives in an IfModule [#1423](https://github.com/puppetlabs/puppetlabs-apache/pull/1423) ([kimor79](https://github.com/kimor79))

### Fixed

- Fix conditional in vhost ssl template [#1574](https://github.com/puppetlabs/puppetlabs-apache/pull/1574) ([bmjen](https://github.com/bmjen))
- Avoid relative classname inclusion [#1566](https://github.com/puppetlabs/puppetlabs-apache/pull/1566) ([roidelapluie](https://github.com/roidelapluie))
- custom facts shouldn't break structured facts [#1565](https://github.com/puppetlabs/puppetlabs-apache/pull/1565) ([igalic](https://github.com/igalic))
- (#MODULES-3744) Process $crs_package before $modsec_dir [#1563](https://github.com/puppetlabs/puppetlabs-apache/pull/1563) ([EmersonPrado](https://github.com/EmersonPrado))
- (MODULES-3972) fixes version errors and small fix for suse ssl [#1557](https://github.com/puppetlabs/puppetlabs-apache/pull/1557) ([eputnam](https://github.com/eputnam))
- Don't fail if first element of  is not an hash before flattening [#1555](https://github.com/puppetlabs/puppetlabs-apache/pull/1555) ([sathieu](https://github.com/sathieu))
- [MODULES-3548] SLES 12 fix  [#1545](https://github.com/puppetlabs/puppetlabs-apache/pull/1545) ([HelenCampbell](https://github.com/HelenCampbell))
- Move ssl.conf to main conf directory on EL7 [#1543](https://github.com/puppetlabs/puppetlabs-apache/pull/1543) ([stbenjam](https://github.com/stbenjam))
- Do not set ssl_certs_dir on FreeBSD [#1538](https://github.com/puppetlabs/puppetlabs-apache/pull/1538) ([smortex](https://github.com/smortex))
- [MODULES-3882] Don't write empty servername for vhost to template [#1526](https://github.com/puppetlabs/puppetlabs-apache/pull/1526) ([JAORMX](https://github.com/JAORMX))
- Bug - Port numbers must be quoted [#1525](https://github.com/puppetlabs/puppetlabs-apache/pull/1525) ([blackknight36](https://github.com/blackknight36))
- Fixes spec tests for apache::mod::disk_cache [#1509](https://github.com/puppetlabs/puppetlabs-apache/pull/1509) ([gerhardsam](https://github.com/gerhardsam))
- Httpoxy fix [#1506](https://github.com/puppetlabs/puppetlabs-apache/pull/1506) ([simonrondelez](https://github.com/simonrondelez))
- Fix non breaking space (MODULES-3503) [#1489](https://github.com/puppetlabs/puppetlabs-apache/pull/1489) ([Jeoffreybauvin](https://github.com/Jeoffreybauvin))
- Fix PassengerRoot under Debian stretch [#1478](https://github.com/puppetlabs/puppetlabs-apache/pull/1478) ([sathieu](https://github.com/sathieu))
- variety of xenial fixes [#1477](https://github.com/puppetlabs/puppetlabs-apache/pull/1477) ([tphoney](https://github.com/tphoney))
- fix and make 2.4 require docu more readable [#1466](https://github.com/puppetlabs/puppetlabs-apache/pull/1466) ([HT43-bqxFqB](https://github.com/HT43-bqxFqB))
- apache::balancer now respects apache::confd_dir [#1463](https://github.com/puppetlabs/puppetlabs-apache/pull/1463) ([traylenator](https://github.com/traylenator))

## [1.10.0](https://github.com/puppetlabs/puppetlabs-apache/tree/1.10.0) - 2016-05-19

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.9.0...1.10.0)

### Added

- Remove duplicate shib2 hash element [#1458](https://github.com/puppetlabs/puppetlabs-apache/pull/1458) ([domcleal](https://github.com/domcleal))
- mod_event: parameters can be unset [#1455](https://github.com/puppetlabs/puppetlabs-apache/pull/1455) ([timogoebel](https://github.com/timogoebel))
- Set DAV parameters in a directory block [#1454](https://github.com/puppetlabs/puppetlabs-apache/pull/1454) ([jonnytdevops](https://github.com/jonnytdevops))
- Add support for mod_cluster, an httpd-based load balancer. [#1453](https://github.com/puppetlabs/puppetlabs-apache/pull/1453) ([jonnytdevops](https://github.com/jonnytdevops))
- Only set SSLCompression when it is set to true. [#1452](https://github.com/puppetlabs/puppetlabs-apache/pull/1452) ([buzzdeee](https://github.com/buzzdeee))
- Add class apache::vhosts to create apache::vhost resources [#1450](https://github.com/puppetlabs/puppetlabs-apache/pull/1450) ([gerhardsam](https://github.com/gerhardsam))
- Allow setting KeepAlive related options per vhost [#1447](https://github.com/puppetlabs/puppetlabs-apache/pull/1447) ([antaflos](https://github.com/antaflos))

### Fixed

- Set actual path to apachectl on FreeBSD. [#1448](https://github.com/puppetlabs/puppetlabs-apache/pull/1448) ([smortex](https://github.com/smortex))
- Revert "changed rpaf Configuration Directives: RPAF -> RPAF_" [#1446](https://github.com/puppetlabs/puppetlabs-apache/pull/1446) ([antaflos](https://github.com/antaflos))
- mod_event: do not set parameters twice [#1445](https://github.com/puppetlabs/puppetlabs-apache/pull/1445) ([timogoebel](https://github.com/timogoebel))
- setting options-hash in proxy_pass or proxy_match leads to syntax errors in Apache [#1444](https://github.com/puppetlabs/puppetlabs-apache/pull/1444) ([zivis](https://github.com/zivis))
- Fixed trailing slash in lib_path on Suse [#1429](https://github.com/puppetlabs/puppetlabs-apache/pull/1429) ([OpenCoreCH](https://github.com/OpenCoreCH))
- Add simple <Limit> support + ProxyAddHeaders [#1427](https://github.com/puppetlabs/puppetlabs-apache/pull/1427) ([costela](https://github.com/costela))

## [1.9.0](https://github.com/puppetlabs/puppetlabs-apache/tree/1.9.0) - 2016-04-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.8.1...1.9.0)

### Added

- Expose verify_config in apache::vhost::custom [#1433](https://github.com/puppetlabs/puppetlabs-apache/pull/1433) ([cmurphy](https://github.com/cmurphy))
- (MODULES-3140) explicitly rely on hasrestart if no restart command is… [#1432](https://github.com/puppetlabs/puppetlabs-apache/pull/1432) ([DavidS](https://github.com/DavidS))
- (MODULES-3274) mod-info: specify the info_path [#1431](https://github.com/puppetlabs/puppetlabs-apache/pull/1431) ([DavidS](https://github.com/DavidS))
- Update to newest modulesync_configs [9ca280f] [#1426](https://github.com/puppetlabs/puppetlabs-apache/pull/1426) ([DavidS](https://github.com/DavidS))
- Allow for pagespeed mod to automatically be updated to the latest version [#1422](https://github.com/puppetlabs/puppetlabs-apache/pull/1422) ([lymichaels](https://github.com/lymichaels))
- Allow package names to be specified for mod_proxy, mod_ldap, and mod_authnz_ldap [#1421](https://github.com/puppetlabs/puppetlabs-apache/pull/1421) ([MG2R](https://github.com/MG2R))
- Add parameter passanger_log_level [#1420](https://github.com/puppetlabs/puppetlabs-apache/pull/1420) ([samuelb](https://github.com/samuelb))
- add passenger_high_performance on the vhost level [#1419](https://github.com/puppetlabs/puppetlabs-apache/pull/1419) ([timogoebel](https://github.com/timogoebel))
- Adding SSLProxyCheckPeerExpire support [#1418](https://github.com/puppetlabs/puppetlabs-apache/pull/1418) ([jasonhancock](https://github.com/jasonhancock))
- (MODULES-3218) add auth_merging for directory enteries [#1412](https://github.com/puppetlabs/puppetlabs-apache/pull/1412) ([pyther](https://github.com/pyther))
- MODULES-3212: add parallel_spec option [#1410](https://github.com/puppetlabs/puppetlabs-apache/pull/1410) ([jlambert121](https://github.com/jlambert121))
- MODULES-1352 : Better support for Apache 2.4 style require directives implementation [#1408](https://github.com/puppetlabs/puppetlabs-apache/pull/1408) ([witjoh](https://github.com/witjoh))
- Added vhost options SecRuleRemoveByTag and SecRuleRemoveByMsg [#1407](https://github.com/puppetlabs/puppetlabs-apache/pull/1407) ([FlatKey](https://github.com/FlatKey))
- Configurability of Collaborative Detection Threshold Levels for OWASP Core Rule Set [#1405](https://github.com/puppetlabs/puppetlabs-apache/pull/1405) ([FlatKey](https://github.com/FlatKey))
- Configurability of Collaborative Detection Severity Levels for OWASP Core Rule Set [#1404](https://github.com/puppetlabs/puppetlabs-apache/pull/1404) ([FlatKey](https://github.com/FlatKey))
- Configurability of SecDefaultAction for OWASP Core Rule Set [#1403](https://github.com/puppetlabs/puppetlabs-apache/pull/1403) ([FlatKey](https://github.com/FlatKey))
- MODULES-2179: Implement SetEnvIfNoCase [#1402](https://github.com/puppetlabs/puppetlabs-apache/pull/1402) ([jlambert121](https://github.com/jlambert121))
- Load mod_xml2enc on Apache >= 2.4 on Debian [#1401](https://github.com/puppetlabs/puppetlabs-apache/pull/1401) ([sathieu](https://github.com/sathieu))
- Take igalic's suggestion to use bool2httpd [#1400](https://github.com/puppetlabs/puppetlabs-apache/pull/1400) ([tpdownes](https://github.com/tpdownes))
- Added vhost option fastcgi_idle_timeout [#1399](https://github.com/puppetlabs/puppetlabs-apache/pull/1399) ([michakrause](https://github.com/michakrause))
- Move all ensure parameters from concat::fragment to concat [#1396](https://github.com/puppetlabs/puppetlabs-apache/pull/1396) ([domcleal](https://github.com/domcleal))
- mod_ssl requires mod_mime for AddType directives [#1394](https://github.com/puppetlabs/puppetlabs-apache/pull/1394) ([sathieu](https://github.com/sathieu))
- Allow configuring mod_security's SecAuditLogParts [#1392](https://github.com/puppetlabs/puppetlabs-apache/pull/1392) ([stig](https://github.com/stig))
- (#3139) Add support for PassengerUser [#1391](https://github.com/puppetlabs/puppetlabs-apache/pull/1391) ([Reamer](https://github.com/Reamer))
- add support for SSLProxyProtocol directive [#1390](https://github.com/puppetlabs/puppetlabs-apache/pull/1390) ([saimonn](https://github.com/saimonn))
- Add mellon_sp_metadata_file parameter for directory entries [#1389](https://github.com/puppetlabs/puppetlabs-apache/pull/1389) ([jokajak](https://github.com/jokajak))
- Manage mod dir before things that depend on mods [#1388](https://github.com/puppetlabs/puppetlabs-apache/pull/1388) ([cmurphy](https://github.com/cmurphy))
- add support for fcgi [#1387](https://github.com/puppetlabs/puppetlabs-apache/pull/1387) ([mlhess](https://github.com/mlhess))
- apache::balancer: Add a target parameter to write to a custom path [#1386](https://github.com/puppetlabs/puppetlabs-apache/pull/1386) ([roidelapluie](https://github.com/roidelapluie))
- Add JkMount/JkUnmount directives to vhost [#1384](https://github.com/puppetlabs/puppetlabs-apache/pull/1384) ([smoeding](https://github.com/smoeding))
- Remove SSLv3 [#1383](https://github.com/puppetlabs/puppetlabs-apache/pull/1383) ([ghoneycutt](https://github.com/ghoneycutt))
- include apache, so parsing works [#1380](https://github.com/puppetlabs/puppetlabs-apache/pull/1380) ([tphoney](https://github.com/tphoney))
- include apache, so parsing works. [#1377](https://github.com/puppetlabs/puppetlabs-apache/pull/1377) ([tphoney](https://github.com/tphoney))
- mod/ssl: Add option to configure SSL mutex [#1371](https://github.com/puppetlabs/puppetlabs-apache/pull/1371) ([daenney](https://github.com/daenney))
- support pass-header option in apache::fastcgi::server [#1370](https://github.com/puppetlabs/puppetlabs-apache/pull/1370) ([janschumann](https://github.com/janschumann))
- Support socket communication option in apache::fastcgi::server [#1368](https://github.com/puppetlabs/puppetlabs-apache/pull/1368) ([janschumann](https://github.com/janschumann))
- allow include in vhost directory [#1366](https://github.com/puppetlabs/puppetlabs-apache/pull/1366) ([Zarne](https://github.com/Zarne))
- support Ubuntu xenial (16.04) [#1364](https://github.com/puppetlabs/puppetlabs-apache/pull/1364) ([mmoll](https://github.com/mmoll))
- changed rpaf Configuration Directives: RPAF -> RPAF_ [#1361](https://github.com/puppetlabs/puppetlabs-apache/pull/1361) ([gvdb1967](https://github.com/gvdb1967))
- (MODULES-2756) Adding include ::apache so mkdir exec works properly [#1236](https://github.com/puppetlabs/puppetlabs-apache/pull/1236) ([damonconway](https://github.com/damonconway))

### Fixed

- fix incorrect use of .join() with newlines [#1425](https://github.com/puppetlabs/puppetlabs-apache/pull/1425) ([mpeter](https://github.com/mpeter))
- SSLCompression directive only available with apache 2.4.3 [#1417](https://github.com/puppetlabs/puppetlabs-apache/pull/1417) ([Reamer](https://github.com/Reamer))
- Fix in custom fact "apache_version" for OracleLinux. [#1416](https://github.com/puppetlabs/puppetlabs-apache/pull/1416) ([Reamer](https://github.com/Reamer))
- MODULES-3211: fix broken strict_variable tests [#1414](https://github.com/puppetlabs/puppetlabs-apache/pull/1414) ([jonnytdevops](https://github.com/jonnytdevops))
- MODULES-3211: fix broken strict_variable tests [#1409](https://github.com/puppetlabs/puppetlabs-apache/pull/1409) ([jlambert121](https://github.com/jlambert121))
- Fix MODULES-3158 (any string interpreted as SSLCompression on) [#1398](https://github.com/puppetlabs/puppetlabs-apache/pull/1398) ([tpdownes](https://github.com/tpdownes))
- Fix broken internal link for virtual hosts configuration [#1369](https://github.com/puppetlabs/puppetlabs-apache/pull/1369) ([gerhardsam](https://github.com/gerhardsam))

## [1.8.1](https://github.com/puppetlabs/puppetlabs-apache/tree/1.8.1) - 2016-02-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.8.0...1.8.1)

### Added

- allow status code on redirect match to be optional and not a requirement [#1355](https://github.com/puppetlabs/puppetlabs-apache/pull/1355) ([BigAl](https://github.com/BigAl))
- Ldap parameters [#1352](https://github.com/puppetlabs/puppetlabs-apache/pull/1352) ([tphoney](https://github.com/tphoney))
- Add apache_version fact [#1347](https://github.com/puppetlabs/puppetlabs-apache/pull/1347) ([jyaworski](https://github.com/jyaworski))
- (FM-4049) update to modulesync_configs [#1343](https://github.com/puppetlabs/puppetlabs-apache/pull/1343) ([DavidS](https://github.com/DavidS))
- Specify owning permissions for logroot directory [#1340](https://github.com/puppetlabs/puppetlabs-apache/pull/1340) ([SlavaValAl](https://github.com/SlavaValAl))
- add file_mode to mod manifests [#1338](https://github.com/puppetlabs/puppetlabs-apache/pull/1338) ([timogoebel](https://github.com/timogoebel))
- 	Added support for modsecurity parameter SecPcreMatchLimit and SecPcr… [#1296](https://github.com/puppetlabs/puppetlabs-apache/pull/1296) ([whotwagner](https://github.com/whotwagner))

### Fixed

- Fix in custom fact "apache_version" for RHEL. [#1360](https://github.com/puppetlabs/puppetlabs-apache/pull/1360) ([BobVincentatNCRdotcom](https://github.com/BobVincentatNCRdotcom))
- Fix passenger on redhat systems [#1354](https://github.com/puppetlabs/puppetlabs-apache/pull/1354) ([hunner](https://github.com/hunner))
- ThreadLimit needs to be above MaxClients or it is ignored. https://bz… [#1351](https://github.com/puppetlabs/puppetlabs-apache/pull/1351) ([tphoney](https://github.com/tphoney))
- Bugfix: require concat, not file [#1350](https://github.com/puppetlabs/puppetlabs-apache/pull/1350) ([BobVincentatNCRdotcom](https://github.com/BobVincentatNCRdotcom))
- (MODULES-3018) Fixes apache to work correctly with concat. [#1348](https://github.com/puppetlabs/puppetlabs-apache/pull/1348) ([bmjen](https://github.com/bmjen))
- Fix fcgid.conf on Debian [#1331](https://github.com/puppetlabs/puppetlabs-apache/pull/1331) ([sathieu](https://github.com/sathieu))
- MODULES-2958 : correct CustomLog syslog entry [#1322](https://github.com/puppetlabs/puppetlabs-apache/pull/1322) ([BigAl](https://github.com/BigAl))

## [1.8.0](https://github.com/puppetlabs/puppetlabs-apache/tree/1.8.0) - 2016-01-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.7.1...1.8.0)

### Added

- add paramter to set config file permissions [#1333](https://github.com/puppetlabs/puppetlabs-apache/pull/1333) ([timogoebel](https://github.com/timogoebel))
- (MODULES-2964) Enable PassengerMaxRequestQueueSize to be set [#1323](https://github.com/puppetlabs/puppetlabs-apache/pull/1323) ([traylenator](https://github.com/traylenator))
- MODULES-2956: Enable options within location block on proxy_match [#1317](https://github.com/puppetlabs/puppetlabs-apache/pull/1317) ([jlambert121](https://github.com/jlambert121))
- Support itk on redhat [#1316](https://github.com/puppetlabs/puppetlabs-apache/pull/1316) ([edestecd](https://github.com/edestecd))
- SSLProxyVerify [#1311](https://github.com/puppetlabs/puppetlabs-apache/pull/1311) ([occelebi](https://github.com/occelebi))
- Support the mod_proxy ProxPassReverseCookieDomain directive   [#1309](https://github.com/puppetlabs/puppetlabs-apache/pull/1309) ([occelebi](https://github.com/occelebi))
- Add X-Forwarded-For into log_formats defaults [#1308](https://github.com/puppetlabs/puppetlabs-apache/pull/1308) ([mpolenchuk](https://github.com/mpolenchuk))
- Put headers and request headers before proxy [#1306](https://github.com/puppetlabs/puppetlabs-apache/pull/1306) ([quixoten](https://github.com/quixoten))
- EL7 uses conf.modules.d directory for modules. [#1305](https://github.com/puppetlabs/puppetlabs-apache/pull/1305) ([jasonhancock](https://github.com/jasonhancock))
- Support proxy provider for vhost directories. [#1304](https://github.com/puppetlabs/puppetlabs-apache/pull/1304) ([roidelapluie](https://github.com/roidelapluie))

### Fixed

- MODULES-2990: Gentoo - fix module includes in portage::makeconf [#1337](https://github.com/puppetlabs/puppetlabs-apache/pull/1337) ([derdanne](https://github.com/derdanne))
- fix vhosts listen to wildcard ip [#1335](https://github.com/puppetlabs/puppetlabs-apache/pull/1335) ([timogoebel](https://github.com/timogoebel))
- fixing apache_parameters_spec.rb [#1330](https://github.com/puppetlabs/puppetlabs-apache/pull/1330) ([tphoney](https://github.com/tphoney))
- a path is needed for ProxyPassReverse [#1327](https://github.com/puppetlabs/puppetlabs-apache/pull/1327) ([tphoney](https://github.com/tphoney))
- Fixing error in Amazon $operatingsystem comparison [#1321](https://github.com/puppetlabs/puppetlabs-apache/pull/1321) ([ryno75](https://github.com/ryno75))
- fix ordering of catalogue for redhat 7 [#1319](https://github.com/puppetlabs/puppetlabs-apache/pull/1319) ([tphoney](https://github.com/tphoney))
- fix validation error when empty array is passed as rewrites parameter [#1301](https://github.com/puppetlabs/puppetlabs-apache/pull/1301) ([timogoebel](https://github.com/timogoebel))
- Fix typo with versioncmp [#1299](https://github.com/puppetlabs/puppetlabs-apache/pull/1299) ([pabelanger](https://github.com/pabelanger))
- enable setting LimitRequestFieldSize globally as it does not actually… [#1293](https://github.com/puppetlabs/puppetlabs-apache/pull/1293) ([KlavsKlavsen](https://github.com/KlavsKlavsen))
- Fixes paths and packages for the shib2 module on Debian [#1292](https://github.com/puppetlabs/puppetlabs-apache/pull/1292) ([cholyoak](https://github.com/cholyoak))
- Add ::apache::vhost::custom [#1271](https://github.com/puppetlabs/puppetlabs-apache/pull/1271) ([pabelanger](https://github.com/pabelanger))

## [1.7.1](https://github.com/puppetlabs/puppetlabs-apache/tree/1.7.1) - 2015-12-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.7.0...1.7.1)

### Added

- (MODULES-2682, FM-3919) Use more FilesMatch [#1280](https://github.com/puppetlabs/puppetlabs-apache/pull/1280) ([DavidS](https://github.com/DavidS))
- (MODULES-2682) Update Apache Configuration to use FilesMatch instead … [#1277](https://github.com/puppetlabs/puppetlabs-apache/pull/1277) ([DavidS](https://github.com/DavidS))
- (MODULES-2703) Allow mod pagespeed to take an array of lines as additional_configuration [#1276](https://github.com/puppetlabs/puppetlabs-apache/pull/1276) ([DavidS](https://github.com/DavidS))
- add ability to overide file name generation in custom_config [#1270](https://github.com/puppetlabs/puppetlabs-apache/pull/1270) ([karmix](https://github.com/karmix))
- (MODULES-2834) Support SSLProxyCheckPeerCN and SSLProxyCheckPeerName … [#1268](https://github.com/puppetlabs/puppetlabs-apache/pull/1268) ([traylenator](https://github.com/traylenator))
- Leave require directive unmanaged [#1267](https://github.com/puppetlabs/puppetlabs-apache/pull/1267) ([robertvargason](https://github.com/robertvargason))
- Added support for LDAPTrustedGlobalCert option to apache::mod::ldap [#1262](https://github.com/puppetlabs/puppetlabs-apache/pull/1262) ([lukebigum](https://github.com/lukebigum))

### Fixed

- (MODULES-2200, MODULES-2865) fix ITK configuration on Ubuntu [#1288](https://github.com/puppetlabs/puppetlabs-apache/pull/1288) ([bmjen](https://github.com/bmjen))
- (MODULES-2773) Duplicate Entries in Spec Files [#1278](https://github.com/puppetlabs/puppetlabs-apache/pull/1278) ([DavidS](https://github.com/DavidS))
- (MODULES-2863) Set SSLProxy directives even if ssl is false [#1274](https://github.com/puppetlabs/puppetlabs-apache/pull/1274) ([ckaenzig](https://github.com/ckaenzig))

## [1.7.0](https://github.com/puppetlabs/puppetlabs-apache/tree/1.7.0) - 2015-11-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.6.0...1.7.0)

### Added

- Add support for changing mod_nss listen port (vol 2) [#1260](https://github.com/puppetlabs/puppetlabs-apache/pull/1260) ([rexcze-zz](https://github.com/rexcze-zz))
- (MODULES-2811) Add missing helper lines to spec files [#1256](https://github.com/puppetlabs/puppetlabs-apache/pull/1256) ([alex-harvey-z3q](https://github.com/alex-harvey-z3q))
- Add missing parameters in mod_auth_kerb [#1255](https://github.com/puppetlabs/puppetlabs-apache/pull/1255) ([olivierHa](https://github.com/olivierHa))
- (MODULES-2764) Enclose IPv6 addresses in square brackets [#1248](https://github.com/puppetlabs/puppetlabs-apache/pull/1248) ([Benedikt1992](https://github.com/Benedikt1992))
- (MODULES-2757) Adding if around ServerName in template [#1237](https://github.com/puppetlabs/puppetlabs-apache/pull/1237) ([damonconway](https://github.com/damonconway))
- (MODULES-2651) Default document root update for Ubuntu 14.04 and Debian 8 [#1235](https://github.com/puppetlabs/puppetlabs-apache/pull/1235) ([abednarik](https://github.com/abednarik))
- Update mime.conf.erb to support dynamic AddHandler AddType AddOutputF… [#1232](https://github.com/puppetlabs/puppetlabs-apache/pull/1232) ([prabin5](https://github.com/prabin5))
- #2544 Allow multiple IP addresses per vhost [#1229](https://github.com/puppetlabs/puppetlabs-apache/pull/1229) ([Benedikt1992](https://github.com/Benedikt1992))
- RewriteLock support [#1228](https://github.com/puppetlabs/puppetlabs-apache/pull/1228) ([wickedOne](https://github.com/wickedOne))
- (MODULES-2120) Allow empty docroot [#1224](https://github.com/puppetlabs/puppetlabs-apache/pull/1224) ([DavidS](https://github.com/DavidS))
- Add option to configure the include pattern for the vhost_enable dir [#1223](https://github.com/puppetlabs/puppetlabs-apache/pull/1223) ([DavidS](https://github.com/DavidS))
- (MODULES-2120) Allow empty docroot [#1222](https://github.com/puppetlabs/puppetlabs-apache/pull/1222) ([yakatz](https://github.com/yakatz))
- Install all modules before adding custom configs [#1221](https://github.com/puppetlabs/puppetlabs-apache/pull/1221) ([mpdude](https://github.com/mpdude))
- (#2673) Adding dev_packages to apache class. Allows use of httpd24u-d… [#1218](https://github.com/puppetlabs/puppetlabs-apache/pull/1218) ([damonconway](https://github.com/damonconway))
- Change SSLProtocol in apache::vhost to be space separated [#1216](https://github.com/puppetlabs/puppetlabs-apache/pull/1216) ([bmfurtado](https://github.com/bmfurtado))
- (MODULES-2649) Allow SetOutputFilter to be set on a directory. [#1214](https://github.com/puppetlabs/puppetlabs-apache/pull/1214) ([traylenator](https://github.com/traylenator))
- (MODULES-2647) Optinally set parameters for mod_ext_filter module [#1213](https://github.com/puppetlabs/puppetlabs-apache/pull/1213) ([traylenator](https://github.com/traylenator))
- (MODULES-2622) add SecUploadDir parameter to support file uploads with mod_security [#1210](https://github.com/puppetlabs/puppetlabs-apache/pull/1210) ([jlambert121](https://github.com/jlambert121))
- (MODULES-2616) Optionally set LimitRequestFieldSize on an apache::vhost [#1208](https://github.com/puppetlabs/puppetlabs-apache/pull/1208) ([traylenator](https://github.com/traylenator))
- also install mod_authn_alias as default mod in debian for apache < 2.4 [#1205](https://github.com/puppetlabs/puppetlabs-apache/pull/1205) ([zivis](https://github.com/zivis))
- Add an option to configure PassengerLogFile [#1194](https://github.com/puppetlabs/puppetlabs-apache/pull/1194) ([igalic](https://github.com/igalic))
- (MODULES-2458) Support for mod_auth_mellon. [#1189](https://github.com/puppetlabs/puppetlabs-apache/pull/1189) ([traylenator](https://github.com/traylenator))
- Client auth for reverse proxy [#1188](https://github.com/puppetlabs/puppetlabs-apache/pull/1188) ([holtwilkins](https://github.com/holtwilkins))
- Add ListenBacklog for mod worker (MODULES-2432) [#1185](https://github.com/puppetlabs/puppetlabs-apache/pull/1185) ([mwhahaha](https://github.com/mwhahaha))
- (MODULES-2419) - Add mod_auth_kerb parameters to vhost [#1183](https://github.com/puppetlabs/puppetlabs-apache/pull/1183) ([traylenator](https://github.com/traylenator))
- Support the mod_proxy ProxyPassReverseCookiePath directive [#1180](https://github.com/puppetlabs/puppetlabs-apache/pull/1180) ([roidelapluie](https://github.com/roidelapluie))
- Adding use_optional_includes parameter to vhost define. [#1162](https://github.com/puppetlabs/puppetlabs-apache/pull/1162) ([cropalato](https://github.com/cropalato))
- Add support for user modifiable installation of mod_systemd and pidfile locations: [#1159](https://github.com/puppetlabs/puppetlabs-apache/pull/1159) ([vamegh](https://github.com/vamegh))
- mod_passenger: Allow setting PassengerSpawnMethod [#1158](https://github.com/puppetlabs/puppetlabs-apache/pull/1158) ([wubr](https://github.com/wubr))
- Feature/master/passengerbaseuri [#1152](https://github.com/puppetlabs/puppetlabs-apache/pull/1152) ([aronymous](https://github.com/aronymous))

### Fixed

- (MODULES-2813) Fix deprecation warning in spec_helper.rb [#1258](https://github.com/puppetlabs/puppetlabs-apache/pull/1258) ([alex-harvey-z3q](https://github.com/alex-harvey-z3q))
- (MODULES-2812) Fix deprecation warning in service_spec.rb [#1257](https://github.com/puppetlabs/puppetlabs-apache/pull/1257) ([alex-harvey-z3q](https://github.com/alex-harvey-z3q))
- Fix typo about dynamic AddHandler/AddType [#1254](https://github.com/puppetlabs/puppetlabs-apache/pull/1254) ([olivierHa](https://github.com/olivierHa))
- reduce constraints on regex to fix pe tests [#1231](https://github.com/puppetlabs/puppetlabs-apache/pull/1231) ([tphoney](https://github.com/tphoney))
- Fix ordering issue with conf_file and ports_file [#1230](https://github.com/puppetlabs/puppetlabs-apache/pull/1230) ([MasonM](https://github.com/MasonM))
- (MODULES-2655) Fix acceptance testing for SSLProtocol behaviour for real [#1226](https://github.com/puppetlabs/puppetlabs-apache/pull/1226) ([DavidS](https://github.com/DavidS))
- Multiple fixes [#1225](https://github.com/puppetlabs/puppetlabs-apache/pull/1225) ([DavidS](https://github.com/DavidS))
- Fix typo of MPM_PREFORK for FreeBSD package install [#1200](https://github.com/puppetlabs/puppetlabs-apache/pull/1200) ([edmundcraske](https://github.com/edmundcraske))
- Deflate "application/json" by default [#1198](https://github.com/puppetlabs/puppetlabs-apache/pull/1198) ([leopoiroux](https://github.com/leopoiroux))
- MODULES-2513 mod::ssl fails on SLES [#1195](https://github.com/puppetlabs/puppetlabs-apache/pull/1195) ([ngrossmann](https://github.com/ngrossmann))
- Catch that mod_authz_default has been removed in Apache 2.4 [#1193](https://github.com/puppetlabs/puppetlabs-apache/pull/1193) ([mpdude](https://github.com/mpdude))
- MODULES-2439 - ProxyPassMatch parameters were ending up on a newline [#1190](https://github.com/puppetlabs/puppetlabs-apache/pull/1190) ([underscorgan](https://github.com/underscorgan))
- The purge_vhost_configs parameter is actually called purge_vhost_dir [#1184](https://github.com/puppetlabs/puppetlabs-apache/pull/1184) ([mpdude](https://github.com/mpdude))
- corrects mod_cgid worker/event defaults [#1182](https://github.com/puppetlabs/puppetlabs-apache/pull/1182) ([bmjen](https://github.com/bmjen))
- fixes conditional in vhost aliases [#1181](https://github.com/puppetlabs/puppetlabs-apache/pull/1181) ([bmjen](https://github.com/bmjen))
- load unixd before fcgid on all operating systems (see #879) [#1178](https://github.com/puppetlabs/puppetlabs-apache/pull/1178) ([sethlyons](https://github.com/sethlyons))
- Fix apache::mod::cgid so it can be used with the event MPM [#1175](https://github.com/puppetlabs/puppetlabs-apache/pull/1175) ([MasonM](https://github.com/MasonM))
- Fix _proxy.erb for SetEnv within ProxyMatch. [#1156](https://github.com/puppetlabs/puppetlabs-apache/pull/1156) ([dconry](https://github.com/dconry))
- mod::alias should be included when the aliases parameter is used [#1155](https://github.com/puppetlabs/puppetlabs-apache/pull/1155) ([pcfens](https://github.com/pcfens))
- Fix: missing package for mod_geoip on Debian systems [#1148](https://github.com/puppetlabs/puppetlabs-apache/pull/1148) ([olivierHa](https://github.com/olivierHa))

## [1.6.0](https://github.com/puppetlabs/puppetlabs-apache/tree/1.6.0) - 2015-07-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.5.0...1.6.0)

### Added

- [#puppethack] Adding ability to enable/disable the secruleengine through a parameter [#1168](https://github.com/puppetlabs/puppetlabs-apache/pull/1168) ([igalic](https://github.com/igalic))
- add possibility to set icons_path to false so no alias will be set for it [#1160](https://github.com/puppetlabs/puppetlabs-apache/pull/1160) ([tjikkun](https://github.com/tjikkun))
- apache::vhost filter support [#1143](https://github.com/puppetlabs/puppetlabs-apache/pull/1143) ([BIAndrews](https://github.com/BIAndrews))
- Add the ability to specify GeoIPScanProxyHeaderField for mod_geoip [#1128](https://github.com/puppetlabs/puppetlabs-apache/pull/1128) ([dgarbus](https://github.com/dgarbus))
- Add ssl_openssl_conf_cmd param (apache::mod::ssl and apache::vhost) [#1127](https://github.com/puppetlabs/puppetlabs-apache/pull/1127) ([tmuellerleile](https://github.com/tmuellerleile))

### Fixed

- fixes timing of mod_security tests for aio [#1165](https://github.com/puppetlabs/puppetlabs-apache/pull/1165) ([bmjen](https://github.com/bmjen))
- Debian 7 acceptance test fix [#1161](https://github.com/puppetlabs/puppetlabs-apache/pull/1161) ([bmjen](https://github.com/bmjen))
- Fix test condition for proxy directives. [#1145](https://github.com/puppetlabs/puppetlabs-apache/pull/1145) ([jonnytdevops](https://github.com/jonnytdevops))

## [1.5.0](https://github.com/puppetlabs/puppetlabs-apache/tree/1.5.0) - 2015-06-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.4.1...1.5.0)

### Added

- Add the helper to install puppet/pe/puppet-agent [#1140](https://github.com/puppetlabs/puppetlabs-apache/pull/1140) ([hunner](https://github.com/hunner))
- Updated travisci file to remove allow_failures for Puppet 4 [#1135](https://github.com/puppetlabs/puppetlabs-apache/pull/1135) ([jonnytdevops](https://github.com/jonnytdevops))
- Add changelog for 1.5.0 relesase [#1132](https://github.com/puppetlabs/puppetlabs-apache/pull/1132) ([hunner](https://github.com/hunner))
- Support puppetlabs-concat 2.x [#1126](https://github.com/puppetlabs/puppetlabs-apache/pull/1126) ([domcleal](https://github.com/domcleal))
- Added the ability to define the IndexStyleSheet setting for a directory [#1124](https://github.com/puppetlabs/puppetlabs-apache/pull/1124) ([genebean](https://github.com/genebean))
- Add basic initial support for SLES 11 [#1121](https://github.com/puppetlabs/puppetlabs-apache/pull/1121) ([carroarmato0](https://github.com/carroarmato0))
- Modulesync updates [#1117](https://github.com/puppetlabs/puppetlabs-apache/pull/1117) ([underscorgan](https://github.com/underscorgan))
- MODULES-1968 - Update the template to warn if using deprecated options [#1113](https://github.com/puppetlabs/puppetlabs-apache/pull/1113) ([underscorgan](https://github.com/underscorgan))
- check if ensure present before including alias module [#1102](https://github.com/puppetlabs/puppetlabs-apache/pull/1102) ([maneeshmp](https://github.com/maneeshmp))

### Fixed

- Fixes acceptance tests [#1141](https://github.com/puppetlabs/puppetlabs-apache/pull/1141) ([bmjen](https://github.com/bmjen))
- Incorrect date in the changelog [#1134](https://github.com/puppetlabs/puppetlabs-apache/pull/1134) ([underscorgan](https://github.com/underscorgan))
- Do not offload overriding LogFormats to httpd [#1096](https://github.com/puppetlabs/puppetlabs-apache/pull/1096) ([igalic](https://github.com/igalic))

## [1.4.1](https://github.com/puppetlabs/puppetlabs-apache/tree/1.4.1) - 2015-04-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.4.0...1.4.1)

### Added

- (#1971) new $service_restart parameter to influence httpd. [#1107](https://github.com/puppetlabs/puppetlabs-apache/pull/1107) ([traylenator](https://github.com/traylenator))
- unify log_level checking and allow trace1-8 levels [#1097](https://github.com/puppetlabs/puppetlabs-apache/pull/1097) ([mrgum](https://github.com/mrgum))
- (BKR-147) add Gemfile setting for BEAKER_VERSION for puppet... [#1085](https://github.com/puppetlabs/puppetlabs-apache/pull/1085) ([anodelman](https://github.com/anodelman))
- MODULES-1789 add initial mod_geoip support [#1083](https://github.com/puppetlabs/puppetlabs-apache/pull/1083) ([roman-mueller](https://github.com/roman-mueller))
- Allow settings to be overridden as parameters to apache::mod::ssl [#1079](https://github.com/puppetlabs/puppetlabs-apache/pull/1079) ([roman-mueller](https://github.com/roman-mueller))
- add section for FreeBSD limitations [#1078](https://github.com/puppetlabs/puppetlabs-apache/pull/1078) ([sethlyons](https://github.com/sethlyons))
- Make Options directive configurable for mod userdir [#1077](https://github.com/puppetlabs/puppetlabs-apache/pull/1077) ([frenkel](https://github.com/frenkel))
- allow acess to userdirs again [#1071](https://github.com/puppetlabs/puppetlabs-apache/pull/1071) ([niklas](https://github.com/niklas))
- add parameters to configure expires globally [#1063](https://github.com/puppetlabs/puppetlabs-apache/pull/1063) ([igalic](https://github.com/igalic))
- make $lib_path configurable [#1057](https://github.com/puppetlabs/puppetlabs-apache/pull/1057) ([fraenki](https://github.com/fraenki))

### Fixed

- (MODULES-1874) Fix proxy_connect module on apache >= 2.2 [#1093](https://github.com/puppetlabs/puppetlabs-apache/pull/1093) ([ckaenzig](https://github.com/ckaenzig))
- Fix remoteip unit test for rspec-puppet 2 [#1091](https://github.com/puppetlabs/puppetlabs-apache/pull/1091) ([cmurphy](https://github.com/cmurphy))
- Fixed setting multiple env_var in a location block for proxy pass. [#1086](https://github.com/puppetlabs/puppetlabs-apache/pull/1086) ([btreecat](https://github.com/btreecat))
- fix typo [#1082](https://github.com/puppetlabs/puppetlabs-apache/pull/1082) ([kgeis](https://github.com/kgeis))
- Fixes/apache name [#1070](https://github.com/puppetlabs/puppetlabs-apache/pull/1070) ([stevenpost](https://github.com/stevenpost))
- Remoteip module [#1065](https://github.com/puppetlabs/puppetlabs-apache/pull/1065) ([igalic](https://github.com/igalic))

## [1.4.0](https://github.com/puppetlabs/puppetlabs-apache/tree/1.4.0) - 2015-03-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.3.0...1.4.0)

### Added

- Give a lower priority to mod_passenger [#1072](https://github.com/puppetlabs/puppetlabs-apache/pull/1072) ([underscorgan](https://github.com/underscorgan))
- Apache - mod_passenger: allow setting PassengerMinInstances [#1067](https://github.com/puppetlabs/puppetlabs-apache/pull/1067) ([stevenpost](https://github.com/stevenpost))
- Apache: allow setting the default type [#1064](https://github.com/puppetlabs/puppetlabs-apache/pull/1064) ([stevenpost](https://github.com/stevenpost))
- Allow setting environment variables inside the proxy locations [#1061](https://github.com/puppetlabs/puppetlabs-apache/pull/1061) ([stevenpost](https://github.com/stevenpost))
- give a lower priority to mod_passenger [#1060](https://github.com/puppetlabs/puppetlabs-apache/pull/1060) ([stevenpost](https://github.com/stevenpost))
- Added missing comma in the aliases example section [#1058](https://github.com/puppetlabs/puppetlabs-apache/pull/1058) ([jeremycline](https://github.com/jeremycline))
- Adds the AddDefaultCharset option [#1053](https://github.com/puppetlabs/puppetlabs-apache/pull/1053) ([stevenpost](https://github.com/stevenpost))
- add proper array support for require [#1047](https://github.com/puppetlabs/puppetlabs-apache/pull/1047) ([underscorgan](https://github.com/underscorgan))
- make icons directorylisting configurable [#1046](https://github.com/puppetlabs/puppetlabs-apache/pull/1046) ([underscorgan](https://github.com/underscorgan))
- Allow includes necessary for basic authentication [#1045](https://github.com/puppetlabs/puppetlabs-apache/pull/1045) ([underscorgan](https://github.com/underscorgan))
- MODULES-1779 install package mod_ldap on CentOS 7 [#1038](https://github.com/puppetlabs/puppetlabs-apache/pull/1038) ([roman-mueller](https://github.com/roman-mueller))
- Add support for Passenger's PassengerAppEnv setting [#1034](https://github.com/puppetlabs/puppetlabs-apache/pull/1034) ([liff](https://github.com/liff))
- MODULES-1622: Allow multiple Deny directives in a directory [#985](https://github.com/puppetlabs/puppetlabs-apache/pull/985) ([roman-mueller](https://github.com/roman-mueller))
- MODULES-1581: Gentoo compatibility [#957](https://github.com/puppetlabs/puppetlabs-apache/pull/957) ([derdanne](https://github.com/derdanne))

### Fixed

- Revert "Supersede ssl_random_seed_bytes with ssl_random_seeds option to ... [#1073](https://github.com/puppetlabs/puppetlabs-apache/pull/1073) ([underscorgan](https://github.com/underscorgan))
- Apache: add support for the ProxyPassMatch directive [#1069](https://github.com/puppetlabs/puppetlabs-apache/pull/1069) ([stevenpost](https://github.com/stevenpost))
- Remove Debian workaround as it broke Red Hat systems [#1062](https://github.com/puppetlabs/puppetlabs-apache/pull/1062) ([stevenpost](https://github.com/stevenpost))
- Fix typo in fallbackresource [#1055](https://github.com/puppetlabs/puppetlabs-apache/pull/1055) ([jbx](https://github.com/jbx))
- Ensure resources notify Apache::Service class [#1054](https://github.com/puppetlabs/puppetlabs-apache/pull/1054) ([butlern](https://github.com/butlern))
- Style fix [#1052](https://github.com/puppetlabs/puppetlabs-apache/pull/1052) ([stevenpost](https://github.com/stevenpost))
- Don't manage docroot when default vhosts are disabled [#1050](https://github.com/puppetlabs/puppetlabs-apache/pull/1050) ([underscorgan](https://github.com/underscorgan))
- include mod_filter when needed instead of instantiating it [#1049](https://github.com/puppetlabs/puppetlabs-apache/pull/1049) ([sethlyons](https://github.com/sethlyons))
- Corrected error in documentation for ssl_protocol and ssl_cipher. [#1044](https://github.com/puppetlabs/puppetlabs-apache/pull/1044) ([tdiscuit](https://github.com/tdiscuit))
- Fixed vhost proxy_pass params documentation [#1043](https://github.com/puppetlabs/puppetlabs-apache/pull/1043) ([grafjo](https://github.com/grafjo))
- (#1391) Correct Debian jessie mod_prefork dev package name [#1042](https://github.com/puppetlabs/puppetlabs-apache/pull/1042) ([sathieu](https://github.com/sathieu))
- Fixes #880 - (MODULES-1391) Correct Ubuntu Trusty mod_prefork package name [#1041](https://github.com/puppetlabs/puppetlabs-apache/pull/1041) ([underscorgan](https://github.com/underscorgan))
- Fixed default mpm_event config warning [#1039](https://github.com/puppetlabs/puppetlabs-apache/pull/1039) ([HT43-bqxFqB](https://github.com/HT43-bqxFqB))
- MODULES-1784 check for deprecated options and fail when they are unsupported [#1036](https://github.com/puppetlabs/puppetlabs-apache/pull/1036) ([roman-mueller](https://github.com/roman-mueller))
- fix bug in scriptalias code that keeps scriptalias from beeing included in default vhost [#1035](https://github.com/puppetlabs/puppetlabs-apache/pull/1035) ([haraldsk](https://github.com/haraldsk))
- Fixed an order of operations issue in the test that caused some weird behavior when apache would delay or not restart and added a check with timeout to ensure proper wait [#1032](https://github.com/puppetlabs/puppetlabs-apache/pull/1032) ([cyberious](https://github.com/cyberious))
- SuPHP acceptance fixes?, chasing the test bug that is timing [#1031](https://github.com/puppetlabs/puppetlabs-apache/pull/1031) ([cyberious](https://github.com/cyberious))
- ssl.pp: Fixed indent. [#1026](https://github.com/puppetlabs/puppetlabs-apache/pull/1026) ([jpds-zz](https://github.com/jpds-zz))
- our templates are horrible, we should fix it [#1025](https://github.com/puppetlabs/puppetlabs-apache/pull/1025) ([igalic](https://github.com/igalic))

## [1.3.0](https://github.com/puppetlabs/puppetlabs-apache/tree/1.3.0) - 2015-02-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.2.0...1.3.0)

### Added

- Concat started using a new fact [#1012](https://github.com/puppetlabs/puppetlabs-apache/pull/1012) ([underscorgan](https://github.com/underscorgan))
- (MODULES-1719) Add parameter for SSLRandomSeed bytes [#1007](https://github.com/puppetlabs/puppetlabs-apache/pull/1007) ([hunner](https://github.com/hunner))
- MODULES-1744: use bool2httpd for server_signature and trace_enable [#1006](https://github.com/puppetlabs/puppetlabs-apache/pull/1006) ([jlambert121](https://github.com/jlambert121))
- ssl.pp: Allow setting of SSLRandomSeed option. [#1001](https://github.com/puppetlabs/puppetlabs-apache/pull/1001) ([jpds-zz](https://github.com/jpds-zz))
- add configuration options to mod_security [#997](https://github.com/puppetlabs/puppetlabs-apache/pull/997) ([jlambert121](https://github.com/jlambert121))
- MODULES-1696: ensure mod::setenvif is included if needed [#995](https://github.com/puppetlabs/puppetlabs-apache/pull/995) ([jlambert121](https://github.com/jlambert121))
- MODULES-1680 - sort php_* hashes for idempotency [#994](https://github.com/puppetlabs/puppetlabs-apache/pull/994) ([underscorgan](https://github.com/underscorgan))
- modules-1559 Apache module no service refresh [#993](https://github.com/puppetlabs/puppetlabs-apache/pull/993) ([tphoney](https://github.com/tphoney))
- Add RewriteMap support [#990](https://github.com/puppetlabs/puppetlabs-apache/pull/990) ([soerenbe](https://github.com/soerenbe))
- add passenger support for Debian/jessie [#976](https://github.com/puppetlabs/puppetlabs-apache/pull/976) ([mmoll](https://github.com/mmoll))
- Add IntelliJ files to the ignore list [#970](https://github.com/puppetlabs/puppetlabs-apache/pull/970) ([cmurphy](https://github.com/cmurphy))
- MODULES-1586: Set uid/gid when creating user/group resources [#962](https://github.com/puppetlabs/puppetlabs-apache/pull/962) ([rnelson0](https://github.com/rnelson0))
- acceptance: add test for actual port [#959](https://github.com/puppetlabs/puppetlabs-apache/pull/959) ([DavidS](https://github.com/DavidS))
- MODULES-1382: support multiple access log directives [#951](https://github.com/puppetlabs/puppetlabs-apache/pull/951) ([jlambert121](https://github.com/jlambert121))
- add mod_security apache module [#948](https://github.com/puppetlabs/puppetlabs-apache/pull/948) ([jlambert121](https://github.com/jlambert121))
- Add metadata summary per FM-1523 [#942](https://github.com/puppetlabs/puppetlabs-apache/pull/942) ([lrnrthr](https://github.com/lrnrthr))
- Add configurable options for mpm_event [#939](https://github.com/puppetlabs/puppetlabs-apache/pull/939) ([stumped2](https://github.com/stumped2))
- Add support for SSLPassPhraseDialog [#938](https://github.com/puppetlabs/puppetlabs-apache/pull/938) ([dteirney](https://github.com/dteirney))
- Updated _directories.erb to add support for 'SetEnv' [#934](https://github.com/puppetlabs/puppetlabs-apache/pull/934) ([muresan](https://github.com/muresan))
- 'allow_encoded_slashes' vhost parameter was omitted [#931](https://github.com/puppetlabs/puppetlabs-apache/pull/931) ([antoineco](https://github.com/antoineco))
- Add $status_path parameter to change mod_status url [#930](https://github.com/puppetlabs/puppetlabs-apache/pull/930) ([atxulo](https://github.com/atxulo))
- Add support for mod_auth_cas module configuration [#923](https://github.com/puppetlabs/puppetlabs-apache/pull/923) ([pcfens](https://github.com/pcfens))
- Modules-1458 mod_wsgi package and module name/path [#915](https://github.com/puppetlabs/puppetlabs-apache/pull/915) ([jantman](https://github.com/jantman))
- Implement php_value and php_flag [#906](https://github.com/puppetlabs/puppetlabs-apache/pull/906) ([jweisner](https://github.com/jweisner))

### Fixed

- Fixup 928 - optionally omit priority [#1014](https://github.com/puppetlabs/puppetlabs-apache/pull/1014) ([underscorgan](https://github.com/underscorgan))
- FM-2140 - Fix for suphp test [#1011](https://github.com/puppetlabs/puppetlabs-apache/pull/1011) ([underscorgan](https://github.com/underscorgan))
- Fix for PR 845 [#1010](https://github.com/puppetlabs/puppetlabs-apache/pull/1010) ([underscorgan](https://github.com/underscorgan))
- ssl_protocol expects a string, not an array. [#1009](https://github.com/puppetlabs/puppetlabs-apache/pull/1009) ([sathieu](https://github.com/sathieu))
- Fix license for forge linting. [#1008](https://github.com/puppetlabs/puppetlabs-apache/pull/1008) ([big-samantha](https://github.com/big-samantha))
- Symlinks on all distros [#1000](https://github.com/puppetlabs/puppetlabs-apache/pull/1000) ([HT43-bqxFqB](https://github.com/HT43-bqxFqB))
- MODULES-1684: Specify mod_proxy_connect module for Apache >= 2.3.5 [#987](https://github.com/puppetlabs/puppetlabs-apache/pull/987) ([holser](https://github.com/holser))
- fix versioncmp test in mod::alias [#984](https://github.com/puppetlabs/puppetlabs-apache/pull/984) ([jlambert121](https://github.com/jlambert121))
- MODULES-1688: fix indenting in vhost/_directories.erb template [#980](https://github.com/puppetlabs/puppetlabs-apache/pull/980) ([jlambert121](https://github.com/jlambert121))
- fix apache_version for Debian >7 [#975](https://github.com/puppetlabs/puppetlabs-apache/pull/975) ([mmoll](https://github.com/mmoll))
- Strict variable fix [#974](https://github.com/puppetlabs/puppetlabs-apache/pull/974) ([underscorgan](https://github.com/underscorgan))
- $::selinux is a bool, not a string [#971](https://github.com/puppetlabs/puppetlabs-apache/pull/971) ([underscorgan](https://github.com/underscorgan))
- Even more mod_security test fixes [#969](https://github.com/puppetlabs/puppetlabs-apache/pull/969) ([underscorgan](https://github.com/underscorgan))
- Paths should be different for all deb based OSes [#965](https://github.com/puppetlabs/puppetlabs-apache/pull/965) ([underscorgan](https://github.com/underscorgan))
- Fixes version automatic detection for debian jessie; [#964](https://github.com/puppetlabs/puppetlabs-apache/pull/964) ([Zouuup](https://github.com/Zouuup))
- Fix tests from #948 [#963](https://github.com/puppetlabs/puppetlabs-apache/pull/963) ([underscorgan](https://github.com/underscorgan))
- Fix apache::mod::version title [#960](https://github.com/puppetlabs/puppetlabs-apache/pull/960) ([sathieu](https://github.com/sathieu))
- Fix linting errors [#953](https://github.com/puppetlabs/puppetlabs-apache/pull/953) ([nibalizer](https://github.com/nibalizer))
- Fix uninitialized variable lint [#947](https://github.com/puppetlabs/puppetlabs-apache/pull/947) ([justinstoller](https://github.com/justinstoller))
- Modules 825 - apache2.4 - mod_itk dependency fix  [#944](https://github.com/puppetlabs/puppetlabs-apache/pull/944) ([valeriominetti](https://github.com/valeriominetti))
- MODULES-1384 - idempotency for wsgi_script_aliases [#936](https://github.com/puppetlabs/puppetlabs-apache/pull/936) ([underscorgan](https://github.com/underscorgan))
- MODULES-1403 - fix doc bug [#935](https://github.com/puppetlabs/puppetlabs-apache/pull/935) ([underscorgan](https://github.com/underscorgan))

## [1.2.0](https://github.com/puppetlabs/puppetlabs-apache/tree/1.2.0) - 2014-11-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.1.1...1.2.0)

### Added

- Poodle [#917](https://github.com/puppetlabs/puppetlabs-apache/pull/917) ([igalic](https://github.com/igalic))
- Support parameters along with proxy_pass now w/ tests [#914](https://github.com/puppetlabs/puppetlabs-apache/pull/914) ([tfhartmann](https://github.com/tfhartmann))
- Add params to proxy_pass in vhost [#910](https://github.com/puppetlabs/puppetlabs-apache/pull/910) ([mkobel](https://github.com/mkobel))
- allow disabling default vhosts under 2.4 [#909](https://github.com/puppetlabs/puppetlabs-apache/pull/909) ([igalic](https://github.com/igalic))
- MODULES-1446: mod_version is now builtin [#908](https://github.com/puppetlabs/puppetlabs-apache/pull/908) ([igalic](https://github.com/igalic))
- Allow specifying all alias directives in `aliases` [#901](https://github.com/puppetlabs/puppetlabs-apache/pull/901) ([antaflos](https://github.com/antaflos))
- Add parameter for AddDefaultCharset virtual host directive [#898](https://github.com/puppetlabs/puppetlabs-apache/pull/898) ([domcleal](https://github.com/domcleal))
- Add Passenger related parameters to vhost [#894](https://github.com/puppetlabs/puppetlabs-apache/pull/894) ([domcleal](https://github.com/domcleal))
- (#1423) Added the WSGIChunkedRequest directive to vhost [#890](https://github.com/puppetlabs/puppetlabs-apache/pull/890) ([retr0h](https://github.com/retr0h))
- Remove deprecated concat::setup class [#884](https://github.com/puppetlabs/puppetlabs-apache/pull/884) ([blkperl](https://github.com/blkperl))
- Modules 1396 redirect match rules do not work in the apache module [#881](https://github.com/puppetlabs/puppetlabs-apache/pull/881) ([Matoch](https://github.com/Matoch))
- Need fcgid to load after unixd on RHEL7 [#879](https://github.com/puppetlabs/puppetlabs-apache/pull/879) ([underscorgan](https://github.com/underscorgan))
- Add support to set SSLCARevocationCheck on Apache 2.4 [#866](https://github.com/puppetlabs/puppetlabs-apache/pull/866) ([domcleal](https://github.com/domcleal))
- (PUP-3242) Setting up mod_shib [#850](https://github.com/puppetlabs/puppetlabs-apache/pull/850) ([Aethylred](https://github.com/Aethylred))
- force class definition checks to use absolute scope [#833](https://github.com/puppetlabs/puppetlabs-apache/pull/833) ([GeoffWilliams](https://github.com/GeoffWilliams))
- Added missing syntax highlight to 1st apache::mod::php example [#832](https://github.com/puppetlabs/puppetlabs-apache/pull/832) ([thatgraemeguy](https://github.com/thatgraemeguy))
- Allow multiple balancermember with the same url [#830](https://github.com/puppetlabs/puppetlabs-apache/pull/830) ([roidelapluie](https://github.com/roidelapluie))
- add sort to LogFormats to ensure consistency between runs [#829](https://github.com/puppetlabs/puppetlabs-apache/pull/829) ([tjikkun](https://github.com/tjikkun))
- Add missing kernel fact [#827](https://github.com/puppetlabs/puppetlabs-apache/pull/827) ([underscorgan](https://github.com/underscorgan))
- Add --relative flag [#826](https://github.com/puppetlabs/puppetlabs-apache/pull/826) ([underscorgan](https://github.com/underscorgan))
- Convert apache::vhost to use concat fragments. [#825](https://github.com/puppetlabs/puppetlabs-apache/pull/825) ([underscorgan](https://github.com/underscorgan))
- Finish SCL support for RHEL/CentOS 6 [#821](https://github.com/puppetlabs/puppetlabs-apache/pull/821) ([smerrill](https://github.com/smerrill))
- Allow overriding the detected $apache_name. [#819](https://github.com/puppetlabs/puppetlabs-apache/pull/819) ([smerrill](https://github.com/smerrill))
- Allow other manifests to define ::apache::mod{ 'ssl': }. [#818](https://github.com/puppetlabs/puppetlabs-apache/pull/818) ([smerrill](https://github.com/smerrill))
- Call @proxy_set insteat of proxy_set in inline_template [#816](https://github.com/puppetlabs/puppetlabs-apache/pull/816) ([roidelapluie](https://github.com/roidelapluie))
- Call install_* methods only once in spec_helper_acceptance [#815](https://github.com/puppetlabs/puppetlabs-apache/pull/815) ([justinstoller](https://github.com/justinstoller))
- Add a validate_string check for custom_fragment. [#812](https://github.com/puppetlabs/puppetlabs-apache/pull/812) ([underscorgan](https://github.com/underscorgan))
- ssl mutex directory needs to be set for Debian [#810](https://github.com/puppetlabs/puppetlabs-apache/pull/810) ([jtreminio](https://github.com/jtreminio))
- Support itk with mod php [#808](https://github.com/puppetlabs/puppetlabs-apache/pull/808) ([corvus-ch](https://github.com/corvus-ch))
- Exposed $logroot_mode in init.pp [#807](https://github.com/puppetlabs/puppetlabs-apache/pull/807) ([Ginja](https://github.com/Ginja))
- introduce flag to manage the docroot [#802](https://github.com/puppetlabs/puppetlabs-apache/pull/802) ([igalic](https://github.com/igalic))
- Add authn_core mod to ubuntu trusty defaults [#800](https://github.com/puppetlabs/puppetlabs-apache/pull/800) ([jestallin](https://github.com/jestallin))
- Allow to set multiple ProxyPassReverse directives [#793](https://github.com/puppetlabs/puppetlabs-apache/pull/793) ([roidelapluie](https://github.com/roidelapluie))
- configure timeouts for apache::mod::reqtimeout [#792](https://github.com/puppetlabs/puppetlabs-apache/pull/792) ([roidelapluie](https://github.com/roidelapluie))
- Add deflate params: types, notes [#785](https://github.com/puppetlabs/puppetlabs-apache/pull/785) ([JCotton1123](https://github.com/JCotton1123))
- Add regex validation to wsgi_pass_authorization [#775](https://github.com/puppetlabs/puppetlabs-apache/pull/775) ([ekohl](https://github.com/ekohl))
- Add options to mod info [#717](https://github.com/puppetlabs/puppetlabs-apache/pull/717) ([genebean](https://github.com/genebean))

### Fixed

- Update the test to match the fix from yesterday [#924](https://github.com/puppetlabs/puppetlabs-apache/pull/924) ([underscorgan](https://github.com/underscorgan))
- Fixes indentation of versioncmp [#922](https://github.com/puppetlabs/puppetlabs-apache/pull/922) ([saz](https://github.com/saz))
- Relying on missing fact [#921](https://github.com/puppetlabs/puppetlabs-apache/pull/921) ([underscorgan](https://github.com/underscorgan))
- wsgi_chunked_request doesn't work on lucid [#919](https://github.com/puppetlabs/puppetlabs-apache/pull/919) ([underscorgan](https://github.com/underscorgan))
- (MODULES-1457) apache::vhost: SSLCACertificatePath can't be unset [#913](https://github.com/puppetlabs/puppetlabs-apache/pull/913) ([vinzent](https://github.com/vinzent))
- passenger concat needs to be wrapped in a check [#912](https://github.com/puppetlabs/puppetlabs-apache/pull/912) ([pdxfixit](https://github.com/pdxfixit))
- Fix authnz_ldap package name on el7 [#911](https://github.com/puppetlabs/puppetlabs-apache/pull/911) ([mcanevet](https://github.com/mcanevet))
- Fix misleading error message [#893](https://github.com/puppetlabs/puppetlabs-apache/pull/893) ([DavidS](https://github.com/DavidS))
- Fix Shib setting rules. [#888](https://github.com/puppetlabs/puppetlabs-apache/pull/888) ([halfninja](https://github.com/halfninja))
- ScriptAlias needs to come before Alias. [#882](https://github.com/puppetlabs/puppetlabs-apache/pull/882) ([daveseff](https://github.com/daveseff))
- Fix vhost and mod_passenger tests on deb7 [#876](https://github.com/puppetlabs/puppetlabs-apache/pull/876) ([underscorgan](https://github.com/underscorgan))
- Fix dav_svn for debian 6 [#874](https://github.com/puppetlabs/puppetlabs-apache/pull/874) ([underscorgan](https://github.com/underscorgan))
- Fix custom_config check for ubuntu precise. [#873](https://github.com/puppetlabs/puppetlabs-apache/pull/873) ([underscorgan](https://github.com/underscorgan))
- Revert "Fix duplicate declarations when puppet manages logroot for vhost... [#869](https://github.com/puppetlabs/puppetlabs-apache/pull/869) ([underscorgan](https://github.com/underscorgan))
- (FM-1913) fix passenger tests on EL derivatives [#861](https://github.com/puppetlabs/puppetlabs-apache/pull/861) ([justinstoller](https://github.com/justinstoller))
- Change $port to interpolated string "${port}" to fix "Cannot use Fixnu... [#856](https://github.com/puppetlabs/puppetlabs-apache/pull/856) ([misterdorm](https://github.com/misterdorm))
- Modules-1294 Fix Auth_Require bug with directories [#855](https://github.com/puppetlabs/puppetlabs-apache/pull/855) ([cyberious](https://github.com/cyberious))
- Fix correct type for php_admin and sort hash [#851](https://github.com/puppetlabs/puppetlabs-apache/pull/851) ([olivierHa](https://github.com/olivierHa))
- Revert "strict_variables fix" -- accidentally merged onto 1.1.x [#847](https://github.com/puppetlabs/puppetlabs-apache/pull/847) ([igalic](https://github.com/igalic))
- Fix issue with puppet_module_install, removed and using updated method f... [#846](https://github.com/puppetlabs/puppetlabs-apache/pull/846) ([cyberious](https://github.com/cyberious))
- Fix formatting of sethandler description [#842](https://github.com/puppetlabs/puppetlabs-apache/pull/842) ([antaflos](https://github.com/antaflos))
- Fix some Puppet Lint errors [#840](https://github.com/puppetlabs/puppetlabs-apache/pull/840) ([baurmatt](https://github.com/baurmatt))
- Ensure that mod packages are installed before conf [#837](https://github.com/puppetlabs/puppetlabs-apache/pull/837) ([bodepd](https://github.com/bodepd))
- Add defined type for handling custom configs [#836](https://github.com/puppetlabs/puppetlabs-apache/pull/836) ([underscorgan](https://github.com/underscorgan))
- Typefix [#828](https://github.com/puppetlabs/puppetlabs-apache/pull/828) ([setola](https://github.com/setola))
- Fix dependency loop in vhost [#820](https://github.com/puppetlabs/puppetlabs-apache/pull/820) ([underscorgan](https://github.com/underscorgan))
- Fixing warning in rake validate [#809](https://github.com/puppetlabs/puppetlabs-apache/pull/809) ([underscorgan](https://github.com/underscorgan))
- fix for #802: when !manage_docroot, don't require it [#806](https://github.com/puppetlabs/puppetlabs-apache/pull/806) ([igalic](https://github.com/igalic))
- Fix strict variables [#804](https://github.com/puppetlabs/puppetlabs-apache/pull/804) ([hunner](https://github.com/hunner))
- Changes $alias to $fcgi_alias to prevent Puppet complaining about using that name [#781](https://github.com/puppetlabs/puppetlabs-apache/pull/781) ([jtreminio](https://github.com/jtreminio))

## [1.1.1](https://github.com/puppetlabs/puppetlabs-apache/tree/1.1.1) - 2014-07-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.1.0...1.1.1)

## [1.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/1.1.0) - 2014-07-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.0.1...1.1.0)

### Added

- Allow ssl_certs_dir to be unset. [#787](https://github.com/puppetlabs/puppetlabs-apache/pull/787) ([tdb](https://github.com/tdb))
- Add param to ctrl purging of vhost dir [#786](https://github.com/puppetlabs/puppetlabs-apache/pull/786) ([JCotton1123](https://github.com/JCotton1123))
- Adds @ to faux_path template variable [#780](https://github.com/puppetlabs/puppetlabs-apache/pull/780) ([jtreminio](https://github.com/jtreminio))
- Start synchronizing module files [#774](https://github.com/puppetlabs/puppetlabs-apache/pull/774) ([cmurphy](https://github.com/cmurphy))
- Add DeflateFilterNote directives [#761](https://github.com/puppetlabs/puppetlabs-apache/pull/761) ([bodgit](https://github.com/bodgit))
- add logroot_mode parameter [#760](https://github.com/puppetlabs/puppetlabs-apache/pull/760) ([nbeernink](https://github.com/nbeernink))
- MODULES-957: Add more Apache 2.4 conditional blocks to configuration templates [#756](https://github.com/puppetlabs/puppetlabs-apache/pull/756) ([pcfens](https://github.com/pcfens))
- MODULES-1065: Add ThreadLimit to mod::worker [#755](https://github.com/puppetlabs/puppetlabs-apache/pull/755) ([jlambert121](https://github.com/jlambert121))
- Add the Satisfy parameter to the directory fragment. [#752](https://github.com/puppetlabs/puppetlabs-apache/pull/752) ([Arakmar](https://github.com/Arakmar))
- Add package parameters to the dav_svn mod. [#750](https://github.com/puppetlabs/puppetlabs-apache/pull/750) ([Arakmar](https://github.com/Arakmar))
- Provide configuration file for php module [#744](https://github.com/puppetlabs/puppetlabs-apache/pull/744) ([amateo](https://github.com/amateo))
- MODULES-956 Added loadfile_name parameter to apache::mod. [#737](https://github.com/puppetlabs/puppetlabs-apache/pull/737) ([underscorgan](https://github.com/underscorgan))
- Add a nodeset for Ubuntu 14.04. [#719](https://github.com/puppetlabs/puppetlabs-apache/pull/719) ([underscorgan](https://github.com/underscorgan))
- Add fcgid options [#716](https://github.com/puppetlabs/puppetlabs-apache/pull/716) ([ekohl](https://github.com/ekohl))
- Add specs for #689 [#715](https://github.com/puppetlabs/puppetlabs-apache/pull/715) ([hunner](https://github.com/hunner))
- Use access_compat on 2.4, and update pagespeed to load the correct modul... [#714](https://github.com/puppetlabs/puppetlabs-apache/pull/714) ([underscorgan](https://github.com/underscorgan))
- Add suexec support [#712](https://github.com/puppetlabs/puppetlabs-apache/pull/712) ([ekohl](https://github.com/ekohl))
-  Configure Passenger in separate .conf file on Debian so PassengerRoot isn't lost [#711](https://github.com/puppetlabs/puppetlabs-apache/pull/711) ([GregSutcliffe](https://github.com/GregSutcliffe))
- Don't include the NameVirtualHost directives in apache >= 2.4, and add t... [#708](https://github.com/puppetlabs/puppetlabs-apache/pull/708) ([underscorgan](https://github.com/underscorgan))
- Add fastcgi external server defined type [#704](https://github.com/puppetlabs/puppetlabs-apache/pull/704) ([JCotton1123](https://github.com/JCotton1123))
- turning MaxKeepAliveRequests into a variable [#703](https://github.com/puppetlabs/puppetlabs-apache/pull/703) ([attachmentgenie](https://github.com/attachmentgenie))
- add docroot_mode parameter to vhost [#697](https://github.com/puppetlabs/puppetlabs-apache/pull/697) ([ckaenzig](https://github.com/ckaenzig))
- Added support for SVN authentication (mod_authz_svn) [#696](https://github.com/puppetlabs/puppetlabs-apache/pull/696) ([baurmatt](https://github.com/baurmatt))
- Added WSGIPassAuthorization option to vhost. [#694](https://github.com/puppetlabs/puppetlabs-apache/pull/694) ([Conzar](https://github.com/Conzar))
- Allow Apache service not to be managed by Puppet [#690](https://github.com/puppetlabs/puppetlabs-apache/pull/690) ([arnoudj](https://github.com/arnoudj))
- ssl tweaks [#688](https://github.com/puppetlabs/puppetlabs-apache/pull/688) ([sdague](https://github.com/sdague))
- Enable overriding mod-level parameters for apache::mod::passenger [#687](https://github.com/puppetlabs/puppetlabs-apache/pull/687) ([jonoterc](https://github.com/jonoterc))
- Add extra parameters to mod::php [#684](https://github.com/puppetlabs/puppetlabs-apache/pull/684) ([nbeernink](https://github.com/nbeernink))
- A first stab at extending LogFormats [#682](https://github.com/puppetlabs/puppetlabs-apache/pull/682) ([igalic](https://github.com/igalic))
- Add support for mod_speling [#652](https://github.com/puppetlabs/puppetlabs-apache/pull/652) ([rchouinard](https://github.com/rchouinard))
- Add support for Google's mod_pagespeed [#650](https://github.com/puppetlabs/puppetlabs-apache/pull/650) ([pcfens](https://github.com/pcfens))
- Add support for SetHandler directive [#604](https://github.com/puppetlabs/puppetlabs-apache/pull/604) ([bodgit](https://github.com/bodgit))

### Fixed

- Fix passenger repo on Scientific linux [#749](https://github.com/puppetlabs/puppetlabs-apache/pull/749) ([hunner](https://github.com/hunner))
- Mod pagespeed fix [#740](https://github.com/puppetlabs/puppetlabs-apache/pull/740) ([underscorgan](https://github.com/underscorgan))
- Mod rewrite duplicate error [#739](https://github.com/puppetlabs/puppetlabs-apache/pull/739) ([xavierleune](https://github.com/xavierleune))
- Fix lib path for Ubuntu 10.04. [#727](https://github.com/puppetlabs/puppetlabs-apache/pull/727) ([underscorgan](https://github.com/underscorgan))
- Fix module usage with strict_variables [#721](https://github.com/puppetlabs/puppetlabs-apache/pull/721) ([mcanevet](https://github.com/mcanevet))
- Fix platform for centos-6.5 [#710](https://github.com/puppetlabs/puppetlabs-apache/pull/710) ([ekohl](https://github.com/ekohl))
- order proxy_set option so it doesn't change between runs [#701](https://github.com/puppetlabs/puppetlabs-apache/pull/701) ([tjikkun](https://github.com/tjikkun))
- fix missing comma in sample config [#683](https://github.com/puppetlabs/puppetlabs-apache/pull/683) ([sdague](https://github.com/sdague))
- fix missing ensure on concat::fragment resources [#681](https://github.com/puppetlabs/puppetlabs-apache/pull/681) ([jfroche](https://github.com/jfroche))
- mod_proxy_html failing in Debian [#673](https://github.com/puppetlabs/puppetlabs-apache/pull/673) ([carlossg](https://github.com/carlossg))
- Apache version in Ubuntu 13.10 is 2.4 [#672](https://github.com/puppetlabs/puppetlabs-apache/pull/672) ([carlossg](https://github.com/carlossg))
- lint fixes [#671](https://github.com/puppetlabs/puppetlabs-apache/pull/671) ([carlossg](https://github.com/carlossg))
- Include mod wsgi when wsgi_daemon_process is given [#664](https://github.com/puppetlabs/puppetlabs-apache/pull/664) ([ekohl](https://github.com/ekohl))
- apache::mod::mime does not compile due to wrong file dependency [#627](https://github.com/puppetlabs/puppetlabs-apache/pull/627) ([carlossg](https://github.com/carlossg))

## [1.0.1](https://github.com/puppetlabs/puppetlabs-apache/tree/1.0.1) - 2014-03-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/1.0.0...1.0.1)

### Fixed

- Replace the symlink with the actual file to resolve a PMT issue. [#665](https://github.com/puppetlabs/puppetlabs-apache/pull/665) ([apenney](https://github.com/apenney))

## [1.0.0](https://github.com/puppetlabs/puppetlabs-apache/tree/1.0.0) - 2014-03-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.11.0...1.0.0)

### Changed

- Metadata [#661](https://github.com/puppetlabs/puppetlabs-apache/pull/661) ([apenney](https://github.com/apenney))
- Apache2.4 support [#552](https://github.com/puppetlabs/puppetlabs-apache/pull/552) ([scottasmith](https://github.com/scottasmith))

### Added

- Modifying hierarchy of the Version/Params to fix AWS AMI [#651](https://github.com/puppetlabs/puppetlabs-apache/pull/651) ([jrnt30](https://github.com/jrnt30))
- Windows, Suse, Solaris, and AIX are not supported. [#644](https://github.com/puppetlabs/puppetlabs-apache/pull/644) ([hunner](https://github.com/hunner))
- Add rewrite_base functionality to rewrites [#631](https://github.com/puppetlabs/puppetlabs-apache/pull/631) ([hunner](https://github.com/hunner))
- Array/Hash mutating operations deprecated [#625](https://github.com/puppetlabs/puppetlabs-apache/pull/625) ([domcleal](https://github.com/domcleal))
- Create user/group instead of using existing ones [#619](https://github.com/puppetlabs/puppetlabs-apache/pull/619) ([hunner](https://github.com/hunner))
- Allow custom gemsource [#617](https://github.com/puppetlabs/puppetlabs-apache/pull/617) ([hunner](https://github.com/hunner))
- Ensure socache_shmcb is enabled on all Apache 2.4 OSes [#612](https://github.com/puppetlabs/puppetlabs-apache/pull/612) ([domcleal](https://github.com/domcleal))
- Add WSGIApplicationGroup and WSGIImportScript directives [#606](https://github.com/puppetlabs/puppetlabs-apache/pull/606) ([bodgit](https://github.com/bodgit))

### Fixed

- Add in missing fields to work around a Puppet bug. [#663](https://github.com/puppetlabs/puppetlabs-apache/pull/663) ([apenney](https://github.com/apenney))
- Adds "Release Notes/Known Bugs" to Changelog, updates file format to markdown, standardizes the format of previous entries [#660](https://github.com/puppetlabs/puppetlabs-apache/pull/660) ([lrnrthr](https://github.com/lrnrthr))
- Checking the stderr wasn't specified correctly [#646](https://github.com/puppetlabs/puppetlabs-apache/pull/646) ([hunner](https://github.com/hunner))
- Fix WSGI import_script and mod_ssl issues on Lucid [#645](https://github.com/puppetlabs/puppetlabs-apache/pull/645) ([hunner](https://github.com/hunner))
- The vagrant user doesn't exist on non-vagrant machines [#616](https://github.com/puppetlabs/puppetlabs-apache/pull/616) ([hunner](https://github.com/hunner))
- Lint fixes [#614](https://github.com/puppetlabs/puppetlabs-apache/pull/614) ([justinstoller](https://github.com/justinstoller))
- Proxy pass reverse fix [#613](https://github.com/puppetlabs/puppetlabs-apache/pull/613) ([dteirney](https://github.com/dteirney))
- templates/vhost/_proxy.erb misconfigures ProxyPassReverse [#602](https://github.com/puppetlabs/puppetlabs-apache/pull/602) ([jrwilk01](https://github.com/jrwilk01))
- Added in mod_actions to the repo so it may be used. [#591](https://github.com/puppetlabs/puppetlabs-apache/pull/591) ([typhonius](https://github.com/typhonius))

## [0.11.0](https://github.com/puppetlabs/puppetlabs-apache/tree/0.11.0) - 2014-02-05

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.10.0...0.11.0)

### Added

- Implement *Match methods for directory providers [#597](https://github.com/puppetlabs/puppetlabs-apache/pull/597) ([scottasmith](https://github.com/scottasmith))
- allow AuthGroupFile directive for vhosts [#589](https://github.com/puppetlabs/puppetlabs-apache/pull/589) ([doc75](https://github.com/doc75))
- Support Header directives in vhost context [#575](https://github.com/puppetlabs/puppetlabs-apache/pull/575) ([antaflos](https://github.com/antaflos))
- quote paths for windows compatability [#567](https://github.com/puppetlabs/puppetlabs-apache/pull/567) ([jlambert121](https://github.com/jlambert121))
- Update alias.pp to let users of Amazon Linux use the module [#545](https://github.com/puppetlabs/puppetlabs-apache/pull/545) ([mattboston](https://github.com/mattboston))
- Update init.pp to allow for support for Amazon Linux [#544](https://github.com/puppetlabs/puppetlabs-apache/pull/544) ([mattboston](https://github.com/mattboston))
- Added support for mod_include [#543](https://github.com/puppetlabs/puppetlabs-apache/pull/543) ([derJD](https://github.com/derJD))
- Pass this through to directories. [#539](https://github.com/puppetlabs/puppetlabs-apache/pull/539) ([apenney](https://github.com/apenney))
- Support environment variable control for CustomLog [#527](https://github.com/puppetlabs/puppetlabs-apache/pull/527) ([chieping](https://github.com/chieping))
- added redirectmatch support [#521](https://github.com/puppetlabs/puppetlabs-apache/pull/521) ([pablokbs](https://github.com/pablokbs))
- Convert spec tests to beaker [#518](https://github.com/puppetlabs/puppetlabs-apache/pull/518) ([hunner](https://github.com/hunner))
- Setting up the ability to do multiple rewrites and conditions. Allowing ... [#517](https://github.com/puppetlabs/puppetlabs-apache/pull/517) ([amvapor](https://github.com/amvapor))
- Support php_admin_(flag|value)s [#481](https://github.com/puppetlabs/puppetlabs-apache/pull/481) ([igalic](https://github.com/igalic))

### Fixed

- Fix typos in templates/vhost/_itk.erb [#601](https://github.com/puppetlabs/puppetlabs-apache/pull/601) ([hunner](https://github.com/hunner))
- Change serveradmin default to undef [#599](https://github.com/puppetlabs/puppetlabs-apache/pull/599) ([hunner](https://github.com/hunner))
- Delete this key, mistakenly added. [#582](https://github.com/puppetlabs/puppetlabs-apache/pull/582) ([apenney](https://github.com/apenney))
- fix puppet-lint errors [#571](https://github.com/puppetlabs/puppetlabs-apache/pull/571) ([robbyt](https://github.com/robbyt))
- Don't purge mods-available dir when separate enable dir is used [#561](https://github.com/puppetlabs/puppetlabs-apache/pull/561) ([domcleal](https://github.com/domcleal))
- Fix the servername used in log file name [#547](https://github.com/puppetlabs/puppetlabs-apache/pull/547) ([xcompass](https://github.com/xcompass))
- make sure that directories are actually a Hash [#536](https://github.com/puppetlabs/puppetlabs-apache/pull/536) ([igalic](https://github.com/igalic))
- Fix rspec-puppet deprecation warnings [#534](https://github.com/puppetlabs/puppetlabs-apache/pull/534) ([blkperl](https://github.com/blkperl))
- Fix $ports_file reference in Namevirtualhost. [#532](https://github.com/puppetlabs/puppetlabs-apache/pull/532) ([apenney](https://github.com/apenney))

## [0.10.0](https://github.com/puppetlabs/puppetlabs-apache/tree/0.10.0) - 2013-12-05

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.9.0...0.10.0)

### Added

- Make LogLevel configurable for server [#516](https://github.com/puppetlabs/puppetlabs-apache/pull/516) ([antaflos](https://github.com/antaflos))
- Make LogLevel configurable for vhost [#513](https://github.com/puppetlabs/puppetlabs-apache/pull/513) ([antaflos](https://github.com/antaflos))
- Add ability to pass ip (instead of wildcard) in default vhost files [#509](https://github.com/puppetlabs/puppetlabs-apache/pull/509) ([tampakrap](https://github.com/tampakrap))
- add parameter for TraceEnable [#508](https://github.com/puppetlabs/puppetlabs-apache/pull/508) ([mmoll](https://github.com/mmoll))
- Add support for ScriptAliasMatch directives [#502](https://github.com/puppetlabs/puppetlabs-apache/pull/502) ([antaflos](https://github.com/antaflos))
- Remove eronous duplication of ForceType [#501](https://github.com/puppetlabs/puppetlabs-apache/pull/501) ([igalic](https://github.com/igalic))
- Add support for overriding ErrorDocument [#498](https://github.com/puppetlabs/puppetlabs-apache/pull/498) ([igalic](https://github.com/igalic))
- Add suPHP_UserGroup directive to directory context [#497](https://github.com/puppetlabs/puppetlabs-apache/pull/497) ([igalic](https://github.com/igalic))
- Working mod_authnz_ldap support on Debian/Ubuntu [#496](https://github.com/puppetlabs/puppetlabs-apache/pull/496) ([antaflos](https://github.com/antaflos))
- Set SSLOptions StdEnvVars in server context [#490](https://github.com/puppetlabs/puppetlabs-apache/pull/490) ([igalic](https://github.com/igalic))
- Mod rpaf support (with FreeBSD support) [#471](https://github.com/puppetlabs/puppetlabs-apache/pull/471) ([ptomulik](https://github.com/ptomulik))
- Don't listen on port or set NameVirtualHost for non-existent vhost [#470](https://github.com/puppetlabs/puppetlabs-apache/pull/470) ([antaflos](https://github.com/antaflos))
- Adding support for another mod_wsgi parameter [#458](https://github.com/puppetlabs/puppetlabs-apache/pull/458) ([ksexton](https://github.com/ksexton))
- Add ability to include additional external configurations in vhost [#457](https://github.com/puppetlabs/puppetlabs-apache/pull/457) ([alnewkirk](https://github.com/alnewkirk))
- Add new params to apache::mod::mime class [#447](https://github.com/puppetlabs/puppetlabs-apache/pull/447) ([ptomulik](https://github.com/ptomulik))
- Add Allow and ExtendedStatus support to mod_status (rebase of #419) [#446](https://github.com/puppetlabs/puppetlabs-apache/pull/446) ([dbeckham](https://github.com/dbeckham))
- Allow apache::mod to specify module id and path [#445](https://github.com/puppetlabs/puppetlabs-apache/pull/445) ([ptomulik](https://github.com/ptomulik))
- added $server_root parameter [#443](https://github.com/puppetlabs/puppetlabs-apache/pull/443) ([ptomulik](https://github.com/ptomulik))
- More vhost directives, only add AllowOverride default for directory container [#438](https://github.com/puppetlabs/puppetlabs-apache/pull/438) ([TrevorBramble](https://github.com/TrevorBramble))
- Peruser event [#437](https://github.com/puppetlabs/puppetlabs-apache/pull/437) ([ptomulik](https://github.com/ptomulik))
- Added $service_name parameter [#436](https://github.com/puppetlabs/puppetlabs-apache/pull/436) ([ptomulik](https://github.com/ptomulik))
- add $root_group parameter [#435](https://github.com/puppetlabs/puppetlabs-apache/pull/435) ([ptomulik](https://github.com/ptomulik))
- ensure default vhost config files are removed when false [#433](https://github.com/puppetlabs/puppetlabs-apache/pull/433) ([jlambert121](https://github.com/jlambert121))
- allow allow_from to be set for mod_status [#432](https://github.com/puppetlabs/puppetlabs-apache/pull/432) ([jlambert121](https://github.com/jlambert121))
- Add support for nss module [#426](https://github.com/puppetlabs/puppetlabs-apache/pull/426) ([jonathanunderwood](https://github.com/jonathanunderwood))
- satisfy mod_php inter-module dependencies [#422](https://github.com/puppetlabs/puppetlabs-apache/pull/422) ([igalic](https://github.com/igalic))
- Remove AllowOverride header for non-directories [#420](https://github.com/puppetlabs/puppetlabs-apache/pull/420) ([mvschaik](https://github.com/mvschaik))
- Don't set `Allow from all` by default for apache::vhost::directories [#416](https://github.com/puppetlabs/puppetlabs-apache/pull/416) ([RPDiep](https://github.com/RPDiep))
- Enable support for mod_authnz_ldap [#404](https://github.com/puppetlabs/puppetlabs-apache/pull/404) ([jlambert121](https://github.com/jlambert121))
- FM-103: Add metadata.json to all modules. [#401](https://github.com/puppetlabs/puppetlabs-apache/pull/401) ([apenney](https://github.com/apenney))
- Add basic support for mod_proxy_ajp [#398](https://github.com/puppetlabs/puppetlabs-apache/pull/398) ([croddy](https://github.com/croddy))
- (#368) Add scriptaliases parameter for multiple script aliases  [#394](https://github.com/puppetlabs/puppetlabs-apache/pull/394) ([jlambert121](https://github.com/jlambert121))
- Add SSLVerifyClient, SSLVerifyDepth, SSLOptions to vhost configuration [#391](https://github.com/puppetlabs/puppetlabs-apache/pull/391) ([mwhahaha](https://github.com/mwhahaha))
- mod_fastcgi [#390](https://github.com/puppetlabs/puppetlabs-apache/pull/390) ([jlambert121](https://github.com/jlambert121))
- Add support for DirectoryIndex tag. [#389](https://github.com/puppetlabs/puppetlabs-apache/pull/389) ([arnoudj](https://github.com/arnoudj))
- Added passenger_use_global_queue option [#388](https://github.com/puppetlabs/puppetlabs-apache/pull/388) ([xorpaul](https://github.com/xorpaul))
- Ability to define service_enable and service_ensure independently [#387](https://github.com/puppetlabs/puppetlabs-apache/pull/387) ([xorpaul](https://github.com/xorpaul))
- Support FallbackResource (httpd >= 2.2.16) [#383](https://github.com/puppetlabs/puppetlabs-apache/pull/383) ([igalic](https://github.com/igalic))
- Added a parameter that allow to precise package ensure [#382](https://github.com/puppetlabs/puppetlabs-apache/pull/382) ([godp1301](https://github.com/godp1301))
- Added 2 parameters to control the creation of user and group resources [#381](https://github.com/puppetlabs/puppetlabs-apache/pull/381) ([slamont](https://github.com/slamont))
- Remove vhost symlink if ensure != present. [#380](https://github.com/puppetlabs/puppetlabs-apache/pull/380) ([pataquets](https://github.com/pataquets))
- Added apache::mod::mime to support SSL module. [#379](https://github.com/puppetlabs/puppetlabs-apache/pull/379) ([blewa](https://github.com/blewa))
- SSLProtocol, SSLCipherSuite, SSLHonorCipherOrder support in the SSL section [#378](https://github.com/puppetlabs/puppetlabs-apache/pull/378) ([AlexRRR](https://github.com/AlexRRR))
- Add 'Timeout' core directive. [#367](https://github.com/puppetlabs/puppetlabs-apache/pull/367) ([pataquets](https://github.com/pataquets))
- Add conditional <IfModule> directive to alias_module template. [#366](https://github.com/puppetlabs/puppetlabs-apache/pull/366) ([pataquets](https://github.com/pataquets))
- Convert sendfile param to string from bool. [#365](https://github.com/puppetlabs/puppetlabs-apache/pull/365) ([razorsedge](https://github.com/razorsedge))
- Add support for DirectoryIndex tag described here: [#359](https://github.com/puppetlabs/puppetlabs-apache/pull/359) ([faisal-memon](https://github.com/faisal-memon))
- Enable support for mod_authnz_ldap [#356](https://github.com/puppetlabs/puppetlabs-apache/pull/356) ([jbartko](https://github.com/jbartko))
- apache::mod::expires class for easy including [#352](https://github.com/puppetlabs/puppetlabs-apache/pull/352) ([kitchen](https://github.com/kitchen))
- Remove default <proxy *> block [#345](https://github.com/puppetlabs/puppetlabs-apache/pull/345) ([igalic](https://github.com/igalic))
- Add configuration options for ServerTokens and ServerSignature [#344](https://github.com/puppetlabs/puppetlabs-apache/pull/344) ([xstasi](https://github.com/xstasi))
- Support for FreeBSD and few other features (reworked PR #264). [#342](https://github.com/puppetlabs/puppetlabs-apache/pull/342) ([ptomulik](https://github.com/ptomulik))
- Allow specifying "ensure" parameter in apache::mod::php [#338](https://github.com/puppetlabs/puppetlabs-apache/pull/338) ([MasonM](https://github.com/MasonM))
- allow to choose the mpm_event mod from the init.pp [#323](https://github.com/puppetlabs/puppetlabs-apache/pull/323) ([mhellmic](https://github.com/mhellmic))
- adopt a more stable proxy configuration [#306](https://github.com/puppetlabs/puppetlabs-apache/pull/306) ([igalic](https://github.com/igalic))

### Fixed

- No implicit <Directory> entry for ScriptAlias path [#488](https://github.com/puppetlabs/puppetlabs-apache/pull/488) ([antaflos](https://github.com/antaflos))
- Add support for AliasMatch directives [#483](https://github.com/puppetlabs/puppetlabs-apache/pull/483) ([antaflos](https://github.com/antaflos))
- Fix directory fragment not setting AllowOverride [#455](https://github.com/puppetlabs/puppetlabs-apache/pull/455) ([Aethylred](https://github.com/Aethylred))
- Revert unnecessary `$default_ssl_vhost` validation change. [#453](https://github.com/puppetlabs/puppetlabs-apache/pull/453) ([dbeckham](https://github.com/dbeckham))
- Workaround for apxs-loaded modules [#444](https://github.com/puppetlabs/puppetlabs-apache/pull/444) ([ptomulik](https://github.com/ptomulik))
- vhost directories fix [#434](https://github.com/puppetlabs/puppetlabs-apache/pull/434) ([kgeis](https://github.com/kgeis))
- Checked that Package declaration has not been defined yet. Fixes #424 [#425](https://github.com/puppetlabs/puppetlabs-apache/pull/425) ([jtreminio](https://github.com/jtreminio))
- Correct broken mime_magic config for Debian - Squashed commit for #418 [#421](https://github.com/puppetlabs/puppetlabs-apache/pull/421) ([dbeckham](https://github.com/dbeckham))
- default_mods now pulls in mod_rewrite correctly [#415](https://github.com/puppetlabs/puppetlabs-apache/pull/415) ([justinclayton](https://github.com/justinclayton))
- Calling apache::mod::rewrite instead of Apache::Mod class directly. Fixe... [#412](https://github.com/puppetlabs/puppetlabs-apache/pull/412) ([jtreminio](https://github.com/jtreminio))
- Correct incorrect expects and init race condition [#405](https://github.com/puppetlabs/puppetlabs-apache/pull/405) ([hunner](https://github.com/hunner))
- Fix for https://github.com/puppetlabs/puppetlabs-apache/issues/248 [#392](https://github.com/puppetlabs/puppetlabs-apache/pull/392) ([greglarkin](https://github.com/greglarkin))
- EL5 and EL6 both use /etc/pki/tls/certs. [#384](https://github.com/puppetlabs/puppetlabs-apache/pull/384) ([razorsedge](https://github.com/razorsedge))
- Fix invalid variable name in itk mod [#362](https://github.com/puppetlabs/puppetlabs-apache/pull/362) ([blkperl](https://github.com/blkperl))
- Fix for issue #358. Including apache::mod::proxy and apache::mod::proxy_h... [#360](https://github.com/puppetlabs/puppetlabs-apache/pull/360) ([bmurtagh](https://github.com/bmurtagh))
- fix exception types in some specs [#350](https://github.com/puppetlabs/puppetlabs-apache/pull/350) ([ptomulik](https://github.com/ptomulik))

## [0.9.0](https://github.com/puppetlabs/puppetlabs-apache/tree/0.9.0) - 2013-09-06

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.8.1...0.9.0)

### Added

- Add header support to the apache::vhost::directories parameter [#334](https://github.com/puppetlabs/puppetlabs-apache/pull/334) ([hunner](https://github.com/hunner))
- Support all kinds of httpd directories. [#331](https://github.com/puppetlabs/puppetlabs-apache/pull/331) ([igalic](https://github.com/igalic))
- Add wsgi_daemon_process_options parameter to vhost [#330](https://github.com/puppetlabs/puppetlabs-apache/pull/330) ([blkperl](https://github.com/blkperl))
- Add deprecation warning for a2mod [#329](https://github.com/puppetlabs/puppetlabs-apache/pull/329) ([blkperl](https://github.com/blkperl))
- Add syslog support for vhosts [#324](https://github.com/puppetlabs/puppetlabs-apache/pull/324) ([mkoderer](https://github.com/mkoderer))
- Add suphp mod [#322](https://github.com/puppetlabs/puppetlabs-apache/pull/322) ([blkperl](https://github.com/blkperl))
- Service class [#321](https://github.com/puppetlabs/puppetlabs-apache/pull/321) ([hunner](https://github.com/hunner))
- remove servername_real [#320](https://github.com/puppetlabs/puppetlabs-apache/pull/320) ([kitchen](https://github.com/kitchen))
- Add WSGI params to apache::vhost [#319](https://github.com/puppetlabs/puppetlabs-apache/pull/319) ([blkperl](https://github.com/blkperl))
- Add WSGIPythonHome param to apache::mod::wsgi [#318](https://github.com/puppetlabs/puppetlabs-apache/pull/318) ([blkperl](https://github.com/blkperl))
- Add build status png [#316](https://github.com/puppetlabs/puppetlabs-apache/pull/316) ([blkperl](https://github.com/blkperl))
- make default mods configurable [#314](https://github.com/puppetlabs/puppetlabs-apache/pull/314) ([igalic](https://github.com/igalic))
- Add KeepAliveTimeout parameter [#313](https://github.com/puppetlabs/puppetlabs-apache/pull/313) ([jjtorroglosa](https://github.com/jjtorroglosa))
- if facter can not determine the fqdn, use the hostname fact [#308](https://github.com/puppetlabs/puppetlabs-apache/pull/308) ([jonmosco](https://github.com/jonmosco))
- Add stuff to use ITK on Debian [#304](https://github.com/puppetlabs/puppetlabs-apache/pull/304) ([kumy](https://github.com/kumy))
- Allow configuration of WSGISocketPrefix [#296](https://github.com/puppetlabs/puppetlabs-apache/pull/296) ([stdietrich](https://github.com/stdietrich))
- Add the custom_fragement to the directories hash [#290](https://github.com/puppetlabs/puppetlabs-apache/pull/290) ([booo](https://github.com/booo))
- Auth [#289](https://github.com/puppetlabs/puppetlabs-apache/pull/289) ([booo](https://github.com/booo))
- Update apache::params for Amazon Linux [#288](https://github.com/puppetlabs/puppetlabs-apache/pull/288) ([hunner](https://github.com/hunner))
- Add `httpd_dir` parameter to the base class for custom builds [#287](https://github.com/puppetlabs/puppetlabs-apache/pull/287) ([hunner](https://github.com/hunner))
- Add KeepAlive parameter [#280](https://github.com/puppetlabs/puppetlabs-apache/pull/280) ([thegriglat](https://github.com/thegriglat))
- (#272) Add parameter sslproxyengine to vhost.pp [#273](https://github.com/puppetlabs/puppetlabs-apache/pull/273) ([mattthias](https://github.com/mattthias))
- Add auth_basic_file and auth_basic_name support to vhost directories [#240](https://github.com/puppetlabs/puppetlabs-apache/pull/240) ([ezheidtmann](https://github.com/ezheidtmann))
- Passenger tuning with the apache::mod::passenger class [#146](https://github.com/puppetlabs/puppetlabs-apache/pull/146) ([Aethylred](https://github.com/Aethylred))

### Fixed

- Fixed failing itk system spec on RedHat [#351](https://github.com/puppetlabs/puppetlabs-apache/pull/351) ([ptomulik](https://github.com/ptomulik))
- Fix failing itk system spec on RedHat [#349](https://github.com/puppetlabs/puppetlabs-apache/pull/349) ([blkperl](https://github.com/blkperl))
- Fix apache::default_mods loading [#348](https://github.com/puppetlabs/puppetlabs-apache/pull/348) ([hunner](https://github.com/hunner))
- Fix hash ordering on 1.8.7 for #330 [#335](https://github.com/puppetlabs/puppetlabs-apache/pull/335) ([hunner](https://github.com/hunner))
- Fix parameters that take hash or array of hashes [#327](https://github.com/puppetlabs/puppetlabs-apache/pull/327) ([hunner](https://github.com/hunner))
- Fix a2mod ruby19 bug [#315](https://github.com/puppetlabs/puppetlabs-apache/pull/315) ([blkperl](https://github.com/blkperl))
- Fix stdlib requirements [#311](https://github.com/puppetlabs/puppetlabs-apache/pull/311) ([hunner](https://github.com/hunner))
- The * needs to be escaped for grep to pass [#309](https://github.com/puppetlabs/puppetlabs-apache/pull/309) ([hunner](https://github.com/hunner))
- Fix rewrite_base [#307](https://github.com/puppetlabs/puppetlabs-apache/pull/307) ([ekohl](https://github.com/ekohl))
- Fixes Issue #291 - created apache::mod::proxy_balancer [#292](https://github.com/puppetlabs/puppetlabs-apache/pull/292) ([benhocker](https://github.com/benhocker))
- (#278) Ports file attempted to be created before Apache installed [#279](https://github.com/puppetlabs/puppetlabs-apache/pull/279) ([jtreminio](https://github.com/jtreminio))

## [0.8.1](https://github.com/puppetlabs/puppetlabs-apache/tree/0.8.1) - 2013-07-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.8.0...0.8.1)

### Added

- Use a more specific match for changing worker/prefork [#263](https://github.com/puppetlabs/puppetlabs-apache/pull/263) ([hunner](https://github.com/hunner))

## [0.8.0](https://github.com/puppetlabs/puppetlabs-apache/tree/0.8.0) - 2013-07-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.7.0...0.8.0)

### Added

- make directories examples real puppet DSL [#253](https://github.com/puppetlabs/puppetlabs-apache/pull/253) ([richardc](https://github.com/richardc))
- add proxy_set option to balancer [#252](https://github.com/puppetlabs/puppetlabs-apache/pull/252) ([tjikkun](https://github.com/tjikkun))
- Add severname parameter to httpd.conf [#251](https://github.com/puppetlabs/puppetlabs-apache/pull/251) ([blkperl](https://github.com/blkperl))
- make fragment names unique to support multiple balancerclusters [#249](https://github.com/puppetlabs/puppetlabs-apache/pull/249) ([tjikkun](https://github.com/tjikkun))

### Fixed

- Issue 230 specifiy that: The apache::mod::* classes that have .conf file [#250](https://github.com/puppetlabs/puppetlabs-apache/pull/250) ([gehel](https://github.com/gehel))
- Sites symlinks [#235](https://github.com/puppetlabs/puppetlabs-apache/pull/235) ([hunner](https://github.com/hunner))

## [0.7.0](https://github.com/puppetlabs/puppetlabs-apache/tree/0.7.0) - 2013-07-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.6.0...0.7.0)

### Changed

- Refactor module [#182](https://github.com/puppetlabs/puppetlabs-apache/pull/182) ([hunner](https://github.com/hunner))

### Added

- Added an 'h' in a typo on default_ssl_vost  [#243](https://github.com/puppetlabs/puppetlabs-apache/pull/243) ([Wesseldr](https://github.com/Wesseldr))
- Add balancermember define [#238](https://github.com/puppetlabs/puppetlabs-apache/pull/238) ([tjikkun](https://github.com/tjikkun))
- Updating for puppet lint [#236](https://github.com/puppetlabs/puppetlabs-apache/pull/236) ([hunner](https://github.com/hunner))
- Add posibility to set VirtualDocumentRoot [#234](https://github.com/puppetlabs/puppetlabs-apache/pull/234) ([hunner](https://github.com/hunner))
- Remove firewall resource [#229](https://github.com/puppetlabs/puppetlabs-apache/pull/229) ([hunner](https://github.com/hunner))
- Add @ to cgisock_path [#227](https://github.com/puppetlabs/puppetlabs-apache/pull/227) ([hunner](https://github.com/hunner))
- Adding extra vhost rspec-server tests [#226](https://github.com/puppetlabs/puppetlabs-apache/pull/226) ([hunner](https://github.com/hunner))
- Support for mod_xsendfile [#224](https://github.com/puppetlabs/puppetlabs-apache/pull/224) ([bmurtagh](https://github.com/bmurtagh))
- Adding rspec-system tests for apache::vhost [#217](https://github.com/puppetlabs/puppetlabs-apache/pull/217) ([hunner](https://github.com/hunner))
- Remove array key assignment [#215](https://github.com/puppetlabs/puppetlabs-apache/pull/215) ([hunner](https://github.com/hunner))
- Adding support for mod_dav_svn [#214](https://github.com/puppetlabs/puppetlabs-apache/pull/214) ([hunner](https://github.com/hunner))
- Add vhost Alias and Directory declarations [#212](https://github.com/puppetlabs/puppetlabs-apache/pull/212) ([Aethylred](https://github.com/Aethylred))
- This allows an override of the default DirectoryIndex directive [#211](https://github.com/puppetlabs/puppetlabs-apache/pull/211) ([Aethylred](https://github.com/Aethylred))
- Move user and group into class parameters. [#210](https://github.com/puppetlabs/puppetlabs-apache/pull/210) ([sfozz](https://github.com/sfozz))
- Add $conf_template in order to override the default template. [#200](https://github.com/puppetlabs/puppetlabs-apache/pull/200) ([apenney](https://github.com/apenney))
- Add proxy_pass parameter [#193](https://github.com/puppetlabs/puppetlabs-apache/pull/193) ([tjikkun](https://github.com/tjikkun))
- Move 'ServerLimit' line in worker.erb [#191](https://github.com/puppetlabs/puppetlabs-apache/pull/191) ([trlinkin](https://github.com/trlinkin))
- Add Validation and rspec tests for $error_log [#186](https://github.com/puppetlabs/puppetlabs-apache/pull/186) ([trlinkin](https://github.com/trlinkin))
- Refactor vhost logformat [#184](https://github.com/puppetlabs/puppetlabs-apache/pull/184) ([trlinkin](https://github.com/trlinkin))
- Add a2mod instances method on Debian [#133](https://github.com/puppetlabs/puppetlabs-apache/pull/133) ([hunner](https://github.com/hunner))
- Added apache::mod::rewrite class. [#128](https://github.com/puppetlabs/puppetlabs-apache/pull/128) ([Stubbs](https://github.com/Stubbs))
- Added apache::mod::shib to configure Shibboleth Service Providers [#96](https://github.com/puppetlabs/puppetlabs-apache/pull/96) ([Aethylred](https://github.com/Aethylred))

### Fixed

- Fix directories template fragment [#233](https://github.com/puppetlabs/puppetlabs-apache/pull/233) ([hunner](https://github.com/hunner))
- Update apache::mod::php's error message to be correct [#232](https://github.com/puppetlabs/puppetlabs-apache/pull/232) ([hunner](https://github.com/hunner))
- Incorrect php .so [#225](https://github.com/puppetlabs/puppetlabs-apache/pull/225) ([hunner](https://github.com/hunner))
- Only 0 (no changes) and 2 (successful) are valid exit codes [#222](https://github.com/puppetlabs/puppetlabs-apache/pull/222) ([hunner](https://github.com/hunner))
- fix variables for latest puppet [#208](https://github.com/puppetlabs/puppetlabs-apache/pull/208) ([pronix](https://github.com/pronix))
- Unable to use proxy because of the default deny all [#203](https://github.com/puppetlabs/puppetlabs-apache/pull/203) ([gregswift](https://github.com/gregswift))
- Fix mod::prefork dependencies [#188](https://github.com/puppetlabs/puppetlabs-apache/pull/188) ([nanliu](https://github.com/nanliu))

## [0.6.0](https://github.com/puppetlabs/puppetlabs-apache/tree/0.6.0) - 2013-03-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.5.0-rc1...0.6.0)

### Added

- Restrict the versions and add 3.1 [#159](https://github.com/puppetlabs/puppetlabs-apache/pull/159) ([richardc](https://github.com/richardc))
- Enable puppet 3.0.1 in travis.yml [#143](https://github.com/puppetlabs/puppetlabs-apache/pull/143) ([blkperl](https://github.com/blkperl))
- Add parameter for purging vdir [#139](https://github.com/puppetlabs/puppetlabs-apache/pull/139) ([mjanser](https://github.com/mjanser))

## [0.5.0-rc1](https://github.com/puppetlabs/puppetlabs-apache/tree/0.5.0-rc1) - 2012-12-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.4.0...0.5.0-rc1)

### Added

- Passenger support [#112](https://github.com/puppetlabs/puppetlabs-apache/pull/112) ([antaflos](https://github.com/antaflos))
- Accept service_enable parameter to install without running at boot [#108](https://github.com/puppetlabs/puppetlabs-apache/pull/108) ([rwstauner](https://github.com/rwstauner))
- Ability to enable/disable "EnableSendFile" from base class call. [#105](https://github.com/puppetlabs/puppetlabs-apache/pull/105) ([obokaman-com](https://github.com/obokaman-com))
- Include apache::params in apache::mod::php [#102](https://github.com/puppetlabs/puppetlabs-apache/pull/102) ([reidmv](https://github.com/reidmv))
- Allow overriding servername in apache::vhost::redirect [#101](https://github.com/puppetlabs/puppetlabs-apache/pull/101) ([cdelston](https://github.com/cdelston))
- Added rspec tests for apache::mod define [#100](https://github.com/puppetlabs/puppetlabs-apache/pull/100) ([knowshan](https://github.com/knowshan))
- Allow custom library paths and module identifier names [#97](https://github.com/puppetlabs/puppetlabs-apache/pull/97) ([knowshan](https://github.com/knowshan))

### Fixed

- ssl_path is not set for vhost-proxy [#106](https://github.com/puppetlabs/puppetlabs-apache/pull/106) ([carlossg](https://github.com/carlossg))
- `$servername` is ignored by `apache::vhost::proxy` [#95](https://github.com/puppetlabs/puppetlabs-apache/pull/95) ([hunner](https://github.com/hunner))
- servername is ignored by apache::vhost::proxy [#94](https://github.com/puppetlabs/puppetlabs-apache/pull/94) ([cyberwolf](https://github.com/cyberwolf))

## [0.4.0](https://github.com/puppetlabs/puppetlabs-apache/tree/0.4.0) - 2012-08-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.3.0...0.4.0)

### Fixed

- Fix vhost template [#88](https://github.com/puppetlabs/puppetlabs-apache/pull/88) ([hunner](https://github.com/hunner))
- Fixed syntax of validate_re function. [#87](https://github.com/puppetlabs/puppetlabs-apache/pull/87) ([martasd](https://github.com/martasd))
- Fixed formatting in vhost template. [#86](https://github.com/puppetlabs/puppetlabs-apache/pull/86) ([martasd](https://github.com/martasd))
- Fix failing spec tests [#83](https://github.com/puppetlabs/puppetlabs-apache/pull/83) ([hunner](https://github.com/hunner))

## [0.3.0](https://github.com/puppetlabs/puppetlabs-apache/tree/0.3.0) - 2012-08-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.2.2...0.3.0)

### Added

- Update reference to deprecated apache::php [#85](https://github.com/puppetlabs/puppetlabs-apache/pull/85) ([philsturgeon](https://github.com/philsturgeon))
- (#16064) Make config files RedHat-compatible [#84](https://github.com/puppetlabs/puppetlabs-apache/pull/84) ([hakamadare](https://github.com/hakamadare))
- Add dependency for package httpd before creating mod.d [#80](https://github.com/puppetlabs/puppetlabs-apache/pull/80) ([hunner](https://github.com/hunner))
- Docroot owner [#79](https://github.com/puppetlabs/puppetlabs-apache/pull/79) ([hunner](https://github.com/hunner))
- Add ssl mod [#78](https://github.com/puppetlabs/puppetlabs-apache/pull/78) ([hunner](https://github.com/hunner))

## [0.2.2](https://github.com/puppetlabs/puppetlabs-apache/tree/0.2.2) - 2012-08-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.2.1...0.2.2)

### Added

- Remove apache::mod::mem_cache from apache::mod::default [#76](https://github.com/puppetlabs/puppetlabs-apache/pull/76) ([hunner](https://github.com/hunner))

## [0.2.1](https://github.com/puppetlabs/puppetlabs-apache/tree/0.2.1) - 2012-08-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.2.0...0.2.1)

### Added

- Remove apache::mod::file_cache from apache::mod::default [#75](https://github.com/puppetlabs/puppetlabs-apache/pull/75) ([hunner](https://github.com/hunner))
- mod.pp: we should make sure the package is present before enabling the module [#73](https://github.com/puppetlabs/puppetlabs-apache/pull/73) ([wulff](https://github.com/wulff))

### Fixed

- mod.pp: we should make sure the package is present before enabling the module [#74](https://github.com/puppetlabs/puppetlabs-apache/pull/74) ([hunner](https://github.com/hunner))

## [0.2.0](https://github.com/puppetlabs/puppetlabs-apache/tree/0.2.0) - 2012-08-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.1.2...0.2.0)

### Added

- Add server_admin parameter to the apache base class [#71](https://github.com/puppetlabs/puppetlabs-apache/pull/71) ([hunner](https://github.com/hunner))
- Add apache::mod::proxy_html [#70](https://github.com/puppetlabs/puppetlabs-apache/pull/70) ([hunner](https://github.com/hunner))
- Add mod templates [#69](https://github.com/puppetlabs/puppetlabs-apache/pull/69) ([hunner](https://github.com/hunner))
- Add mod lib parameter [#68](https://github.com/puppetlabs/puppetlabs-apache/pull/68) ([hunner](https://github.com/hunner))
- Split the userdir module out of the default list and template UserDir [#66](https://github.com/puppetlabs/puppetlabs-apache/pull/66) ([hunner](https://github.com/hunner))

### Fixed

- Bugfix: apache::mod::auth_basic is a class [#67](https://github.com/puppetlabs/puppetlabs-apache/pull/67) ([hunner](https://github.com/hunner))

## [0.1.2](https://github.com/puppetlabs/puppetlabs-apache/tree/0.1.2) - 2012-08-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.1.1...0.1.2)

### Added

- Adding template for httpd.conf and default mods [#62](https://github.com/puppetlabs/puppetlabs-apache/pull/62) ([hunner](https://github.com/hunner))

## [0.1.1](https://github.com/puppetlabs/puppetlabs-apache/tree/0.1.1) - 2012-08-07

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.1.0...0.1.1)

### Added

- Ensure proxy mods are loaded by vhost::proxy [#61](https://github.com/puppetlabs/puppetlabs-apache/pull/61) ([hunner](https://github.com/hunner))
- Use $osfamily instead of $operatingsystem [#59](https://github.com/puppetlabs/puppetlabs-apache/pull/59) ([hunner](https://github.com/hunner))

## [0.1.0](https://github.com/puppetlabs/puppetlabs-apache/tree/0.1.0) - 2012-08-07

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/0.0.4...0.1.0)

### Added

- Make the serveradmin vhost parameter optional [#55](https://github.com/puppetlabs/puppetlabs-apache/pull/55) ([inkblot](https://github.com/inkblot))
- Modified vhost type to use ensure_resource [#54](https://github.com/puppetlabs/puppetlabs-apache/pull/54) ([jtopjian](https://github.com/jtopjian))
- Addition of mod_auth_kerb mod, params & tests [#49](https://github.com/puppetlabs/puppetlabs-apache/pull/49) ([bendylan](https://github.com/bendylan))
- Amazon Linux support [#48](https://github.com/puppetlabs/puppetlabs-apache/pull/48) ([EricKnecht](https://github.com/EricKnecht))
- Added  to enable the user to specify the status of the vhost. [#47](https://github.com/puppetlabs/puppetlabs-apache/pull/47) ([martasd](https://github.com/martasd))
- Add no_proxy_uris param to apache::vhost::proxy [#46](https://github.com/puppetlabs/puppetlabs-apache/pull/46) ([sorenisanerd](https://github.com/sorenisanerd))
- Changed to match parameter name 'mod_python_package' [#44](https://github.com/puppetlabs/puppetlabs-apache/pull/44) ([argybarg](https://github.com/argybarg))
- Add Listen statement to vhost template [#41](https://github.com/puppetlabs/puppetlabs-apache/pull/41) ([glarizza](https://github.com/glarizza))
- virtualhost logroot location [#32](https://github.com/puppetlabs/puppetlabs-apache/pull/32) ([akumria](https://github.com/akumria))
- (#15008) enable AllowOverride setting in vhost [#30](https://github.com/puppetlabs/puppetlabs-apache/pull/30) ([hakamadare](https://github.com/hakamadare))
- (#11816) Added gentoo a2mod provider. [#8](https://github.com/puppetlabs/puppetlabs-apache/pull/8) ([adrienthebo](https://github.com/adrienthebo))

### Fixed

- Remove single quoted variable declaration [#42](https://github.com/puppetlabs/puppetlabs-apache/pull/42) ([glarizza](https://github.com/glarizza))
- Syntax fixes [#35](https://github.com/puppetlabs/puppetlabs-apache/pull/35) ([akumria](https://github.com/akumria))
- Fix Modulefile & CHANGELOG [#28](https://github.com/puppetlabs/puppetlabs-apache/pull/28) ([ryanycoleman](https://github.com/ryanycoleman))

## [0.0.4](https://github.com/puppetlabs/puppetlabs-apache/tree/0.0.4) - 2012-05-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-apache/compare/35721a3f352531f53264fb08f2d4a7f7bab11712...0.0.4)
