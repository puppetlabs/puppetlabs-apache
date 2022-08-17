# @summary Supported protocols / schemes by mod_proxy
# @see https://httpd.apache.org/docs/2.4/mod/mod_proxy.html
type Apache::ModProxyProtocol = Pattern[/(\A(ajp|fcgi|ftp|h2c?|https?|scgi|uwsgi|wss?):\/\/.*\z)/, /(\Aunix:\/([^\n\/\0]+\/*)*\z)/]
