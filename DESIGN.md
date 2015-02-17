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

Full Support of `mod_macro`
---------------------------

I don't think I've written this much httpd configuration in four years, since I
started using this module, exclusively. Thanks to the current design, there is
no simple way (certainly none in hiera) to create a template with a few
variables that are exchanged.

`mod_macro` allows for these templates to be self-defined, and reused in any
context they fit. Our module should allow the declaration of custom macros,
and their use in `apache::vhost`. Nice to have: generate vhosts from macros.

Auto-tuning performance parameters
----------------------------------

Apache's various performance parameters could be auto-tuned using facts to use
the full capacity of the host, and no more.  Items such as MaxClients, or
Passenger pool sizes are candidates.

We could assume that Apache is the primary application, and perhaps provide a
parameter to scale the performance parameters up or down for shared hosts?

More Readable, Easier Debuggable Templates
------------------------------------------

There are a number of patterns that we use in Templates which make them quite
hard to read, and hard to debug. Wittness, in horror, this:

```erb
  ## Directories, there should at least be a declaration for <%= @docroot %>
  <%- [@_directories].flatten.compact.each do |directory| -%>
    <%- if directory['path'] and directory['path'] != '' -%>
      <%- if directory['provider'] and directory['provider'].match('(directory|location|files)') -%>
        <%- if /^(.*)match$/ =~ directory['provider'] -%>
          <%- provider = $1.capitalize + 'Match' -%>
        <%- else -%>
          <%- provider = directory['provider'].capitalize -%>
        <%- end -%>
      <%- else -%>
        <%- provider = 'Directory' -%>
      <%- end -%>
      <%- path = directory['path'] -%>

  <<%= provider %> "<%= path %>">
```

We should provide a couple of standard functions for doing this such as:

* compact, flatten an array, reject all (forms of) empty fields, and
* iterate over it, doing stuff

We should also evaluate in how far we are able to use epp templates for this.
