Puppet::Type.type(:a2mod).provide(:redhat) do
  desc "Manage Apache 2 modules on RedHat family OSs"

  confine :osfamily => :redhat
  defaultfor :osfamily => :redhat

  require 'pathname'

  # modpath: Path to default apache modules directory /etc/httpd/mod.d
  # modfile: Path to module load configuration file; Default: resides under modpath directory
  # libfile: Path to actual apache module library. Added in modfile LoadModule

  attr_accessor :modfile, :libfile
  class << self
    attr_accessor :modpath
    def preinit
      @modpath = "/etc/httpd/mod.d"
    end
  end

  self.preinit

  def create
    File.open(modfile,'w') do |f|
      f.puts "LoadModule #{resource[:identifier]} #{libfile}"
    end
  end

  def destroy
    File.delete(modfile)
  end

  def exists?
    File.exists?(modfile) and File.read(modfile).match(libfile)
  end

  def self.instances
    modules = []
    Dir.glob("#{modpath}/*.load").each do |file|
      m = file.match(/(\w+)\.load$/)
      modules << m[1] if m
    end

    modules.map  do |mod|
      new(
        :name     => mod,
        :ensure   => :present,
        :provider => :redhat
      )
    end
  end

  def modfile
    modfile ||= "#{self.class.modpath}/#{resource[:name]}.load"
  end

  # Set libfile path: If absolute path is passed, then maintain it. Else, make it default from 'modules' dir.
  def libfile
    libfile = Pathname.new(resource[:lib]).absolute? ? resource[:lib] : "modules/#{resource[:lib]}"
  end
end
