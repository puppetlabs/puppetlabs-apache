# @summary Supported protocols / schemes by mod_proxy
# @see https://httpd.apache.org/docs/2.4/mod/mod_proxy.html
type Apache::ModProxyProtocol = Pattern[
  /(?i:\Aajp:\/\/.*\z)/,
  /(?i:\Afcgi:\/\/.*\z)/,
  /(?i:\Aftp:\/\/.*\z)/,
  /(?i:\Ah2c?:\/\/.*\z)/,
  /(?i:\Ahttps?:\/\/.*\z)/,
  /(?i:\Ascgi:\/\/.*\z)/,
  /(?i:\Aunix:\/([^\n\/\0]+\/*)*\z)/
  /(?i:\Auwsgi:\/\/.*\z)/,
  /(?i:\Awss?:\/\/.*\z)/,
]
