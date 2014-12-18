What would we do, if we could do breaking changes?
==================================================

Get rid of all `<IfModule>` directives
--------------------------------------

Our module controls the configuration files, by definition, it knows which
modules to include. As such, it would vastly improve the readability of the
generated configuration files, as well an administrators ability to reason
about them, if we reduce the mental overhead by removing `<IfModule>`

Get rid of all `<IfVersion>` directives
---------------------------------------

In the same vein, we can get rid of `<IfVersion>`, and instead just
*consistently* make use of `scope.function_versioncmp()`.
