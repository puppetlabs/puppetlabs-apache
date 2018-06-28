# a2mod.rb
class Puppet::Provider::A2mod < Puppet::Provider
  def self.prefetch(mods)
    instances.each do |prov|
      mod = mods[prov.name]
      if mod
        mod.provider = prov
      end
    end
  end

  def flush
    @property_hash.clear
  end

  def properties
    if @property_hash.empty?
      @property_hash = query || { ensure: :absent }
      @property_hash[:ensure] = :absent if @property_hash.empty?
    end
    @property_hash.dup
  end

  def query
    self.class.instances.each do |mod|
      if mod.name == name || mod.name.downcase == name
        return mod.properties
      end
    end
    nil
  end

  def exists?
    properties[:ensure] != :absent
  end
end
