# frozen_string_literal: true

# a2mod.rb
class Puppet::Provider::A2mod < Puppet::Provider
  # Fetches the mod provider
  def self.prefetch(mods)
    instances.each do |prov|
      mod = mods[prov.name]
      if mod
        mod.provider = prov
      end
    end
  end

  # Clear's the property_hash
  def flush
    @property_hash.clear
  end

  # Returns a copy of the property_hash
  def properties
    if @property_hash.empty?
      @property_hash = query || { ensure: :absent }
      @property_hash[:ensure] = :absent if @property_hash.empty?
    end
    @property_hash.dup
  end

  # Returns the properties of the given mod if it exists.
  def query
    self.class.instances.each do |mod|
      if mod.name == name || mod.name.downcase == name
        return mod.properties
      end
    end
    nil
  end

  # Return's if the ensure property is absent or not
  def exists?
    properties[:ensure] != :absent
  end
end
