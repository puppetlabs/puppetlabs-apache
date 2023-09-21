# @summary A string that conforms to the Apache `LogLevel` syntax.
#
# A string that conforms to the Apache `LogLevel` syntax.
# Different levels can be specified for individual apache modules.
#
# ie. `[module:]level [module:level] ...`
#
# The levels are (in order of decreasing significance):
# * `emerg`
# * `alert`
# * `crit`
# * `error`
# * `warn`
# * `notice`
# * `info`
# * `debug`
# * `trace1`
# * `trace2`
# * `trace3`
# * `trace4`
# * `trace5`
# * `trace6`
# * `trace7`
# * `trace8`
#
# @see https://httpd.apache.org/docs/current/mod/core.html#loglevel
type Apache::LogLevel = Pattern[/\A([a-z_\.]+:)?(emerg|alert|crit|error|warn|notice|info|debug|trace[1-8])(\s+([a-z_\.]+:)?(emerg|alert|crit|error|warn|notice|info|debug|trace[1-8]))*\Z/]
