Puppet::Type.type(:a2mod).provide(:redhat) do
  desc "Manage Apache 2 modules on RedHat family OSs"

  confine :osfamily => :redhat
  defaultfor :osfamily => :redhat

  attr_accessor :modfile
  class << self
    attr_accessor :modpath
    def preinit
      @modpath = "/etc/httpd/mod.d"
    end
  end

  self.preinit

  def create
    File.open(modfile,'w') do |f|
      f.puts "LoadModule #{resource[:name]}_module modules/#{resource[:lib]}"
    end
  end

  def destroy
    File.delete(modfile)
  end

  def exists?
    File.exists?(modfile) and File.read(modfile).match(resource[:lib])
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
end
