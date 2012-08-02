require 'puppet/util/filetype'
Puppet::Type.type(:a2mod).provide(:redhat, :parent => Puppet::Provider) do
  desc "Manage Apache 2 modules on RedHat family OSs"

  confine :osfamily => :redhat
  defaultfor :osfamily => :redhat

  def create
    @property_hash[:ensure] = :present
  end

  def exists?
    @property_hash[:ensure] and @property_hash[:ensure] == :present
  end

  def destroy
    @property_hash[:ensure] = :absent
  end

  def flush
    self.class.flush
  end

  class << self
    attr_reader :conf_file
    attr_accessor :needs_flush
  end

  def self.clear
    @modules       = Array.new
    @mod_resources = Array.new
  end

  def self.initvars
    @conf_file     = "/etc/httpd/conf/httpd.conf"
    @filetype      = Puppet::Util::FileType.filetype(:flat).new(conf_file)
    @modules       = Array.new
    @mod_resources = Array.new
  end

  self.initvars

  # Retrieve an array of all existing modules
  def self.modules
    if @modules.length <= 0
      # Isolate the LoadModule statements
      conf_lines = @filetype.read.split("\n")
      apache2_mod_lines = conf_lines.grep(/^LoadModule /)

      # Extract all defines
      @modules = apache2_mod_lines.collect do |mod_line|
        m = mod_line.match(/^LoadModule (\w+)_module /)
        m[1].downcase if m
      end.compact.sort.uniq
    end

    @modules
  end

  def self.instances
    modules.map  do |mod|
      new(
        :name     => mod,
        :ensure   => :present,
        :provider => :redhat
      )
    end
  end

  def self.prefetch(resources=Hash.new)
    # Match resources with existing providers
    instances.each do |provider|
      if resource = resources[provider.name]
        resource.provider = provider
      end
    end

    # Store all resources using this provider for flushing
    resources.each do |name, resource|
      @mod_resources << resource
    end
  end

  def self.flush
    mod_list       = modules
    mods_to_remove = @mod_resources.select {|mod| mod.should(:ensure) == :absent}.map {|mod| mod[:name]}
    mods_to_add    = @mod_resources.select {|mod| mod.should(:ensure) == :present}.map {|mod| mod[:name]}

    mod_list -= mods_to_remove
    mod_list += mods_to_add
    mod_list.sort!.uniq!

    if modules != mod_list
      # Create LoadModule lines to add
      enabled_mods = mod_list.collect { |mod| "LoadModule #{mod}_module modules/mod_#{mod}.so"}.join("\n")
      Puppet.debug("Writing back \"#{enabled_mods}\" to #{conf_file}")


      # Filter out stale LoadModule lines and add our own
      conf_lines = @filetype.read.split("\n")
      mods_index = conf_lines.find_index { |i| i.match(/^LoadModule /) }
      conf_lines = conf_lines.reject { |line| line.match(/^LoadModule /) }
      conf_lines[mods_index] = enabled_mods

      # Backup and flush our file
      @filetype.backup
      @filetype.write(conf_lines.join("\n"))
      @modules = mod_list
    end
  end
end
