# @summary A string that conforms to the Apache `ServerTokens` syntax.
#
# @see https://httpd.apache.org/docs/2.4/mod/core.html#servertokens
type Apache::ServerTokens = Enum['Major', 'Minor', 'Min', 'Minimal', 'Prod', 'ProductOnly', 'OS', 'Full']
