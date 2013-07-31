require 'block_party/configuration'

class Hash

  def self.from_config(configuration, keep_classes=false)
    configuration.to_hash keep_classes
  end

  def to_config(keep_classes=true)
    BlockParty::Configuration.from_hash self, keep_classes
  end

end
