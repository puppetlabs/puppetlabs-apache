Puppet::Type.type(:a2mod).provide(:a2mod) do
    desc "Manage Apache 2 modules on Debian and Ubuntu"

    optional_commands :encmd => "a2enmod"
    optional_commands :discmd => "a2dismod"

    defaultfor :operatingsystem => [:debian, :ubuntu]

    def create
        encmd resource[:name]
    end

    def destroy
        discmd resource[:name]
    end

    def exists?
        mod= "/etc/apache2/mods-enabled/" + resource[:name] + ".load"
        File.exists?(mod)
    end
end
