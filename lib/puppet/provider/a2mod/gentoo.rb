require 'puppet/util/filetype'
Puppet::Type.type(:a2mod).provide(:gentoo, parent: Puppet::Provider) do
  desc 'Manage Apache 2 modules on Gentoo'

  confine operatingsystem: :gentoo
  defaultfor operatingsystem: :gentoo

  attr_accessor :property_hash

  def create
    @property_hash[:ensure] = :present
  end

  def exists?
    (!@property_hash[:ensure].nil? && @property_hash[:ensure] == :present)
  end

  def destroy
    @property_hash[:ensure] = :absent
  end

  def flush
    self.class.flush
  end

  class << self
    attr_reader :conf_file
  end

  def self.clear
    @mod_resources = []
    @modules       = []
    @other_args    = ''
  end

  def self.initvars
    @conf_file     = '/etc/conf.d/apache2'
    @filetype      = Puppet::Util::FileType.filetype(:flat).new(conf_file)
    @mod_resources = []
    @modules       = []
    @other_args    = ''
  end

  initvars

  # Retrieve an array of all existing modules
  def self.modules
    if @modules.length <= 0
      # Locate the APACHE_OPTS variable
      records = filetype.read.split(%r{\n})
      apache2_opts = records.grep(%r{^\s*APACHE2_OPTS=}).first

      # Extract all defines
      while apache2_opts.sub!(%r{-D\s+(\w+)}, '')
        @modules << Regexp.last_match(1).downcase
      end

      # Hang on to any remaining options.
      if apache2_opts =~ %r{APACHE2_OPTS="(.+)"}
        @other_args = Regexp.last_match(1).strip
      end

      @modules.sort!.uniq!
    end

    @modules
  end

  def self.prefetch(resources = {})
    # Match resources with existing providers
    instances.each do |provider|
      resource = resources[provider.name]
      if resource
        resource.provider = provider
      end
    end

    # Store all resources using this provider for flushing
    resources.each do |_name, resource|
      @mod_resources << resource
    end
  end

  def self.instances
    modules.map { |mod| new(name: mod, provider: :gentoo, ensure: :present) }
  end

  def self.flush
    mod_list       = modules
    mods_to_remove = @mod_resources.select { |mod| mod.should(:ensure) == :absent }.map { |mod| mod[:name] }
    mods_to_add    = @mod_resources.select { |mod| mod.should(:ensure) == :present }.map { |mod| mod[:name] }

    mod_list -= mods_to_remove
    mod_list += mods_to_add
    mod_list.sort!.uniq!

    return unless modules != mod_list

    opts = @other_args + ' '
    opts << mod_list.map { |mod| "-D #{mod.upcase}" }.join(' ')
    opts.strip!
    opts.gsub!(%r{\s+}, ' ')

    apache2_opts = %(APACHE2_OPTS="#{opts}")
    Puppet.debug("Writing back \"#{apache2_opts}\" to #{conf_file}")

    records = filetype.read.split(%r{\n})

    opts_index = records.find_index { |i| i.match(%r{^\s*APACHE2_OPTS}) }
    records[opts_index] = apache2_opts

    filetype.backup
    filetype.write(records.join("\n"))
    @modules = mod_list
  end
end
