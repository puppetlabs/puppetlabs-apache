Puppet::Type.newtype(:a2mod) do
    @doc = "Manage Apache 2 modules on Debian and Ubuntu"

    ensurable

    newparam(:name) do
       desc "The name of the module to be managed"

       isnamevar

    end

    newparam(:lib) do
      desc "The name of the .so library to be loaded"

      defaultto { "mod_#{@resource[:name]}.so" }
    end

    autorequire(:package) { catalog.resource(:package, 'httpd')}

end
