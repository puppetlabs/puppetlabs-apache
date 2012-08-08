Puppet::Type.type(:a2mod).provide(:redhat) do
  desc "Manage Apache 2 modules on RedHat family OSs"

  confine :osfamily => :redhat
  defaultfor :osfamily => :redhat

  class << self
    attr_accessor :modfile
  end

  def create
    File.open(modfile,'w') do |f|
      f.puts "LoadModule #{resource[:name]}_module modules/mod_#{resource[:name]}.so"
    end
  end

  def destroy
    File.delete(modfile)
  end

  def exists?
    File.exists?(modfile)
  end

  def modfile
    @modfile ||= "/etc/httpd/conf.d/mod_" + resource[:name] + ".load"
  end

  def self.instances
    modules = []
    Dir.glob("/etc/httpd/conf.d/mod_*.load").each do |file|
      m = file.match(/mod_(\w+)\.load$/)
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
end
