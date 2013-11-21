require "block_party/configuration"
require "block_party/configurable"

module BlockParty
  include Configurable
  configure_with Class.new(BlockParty::Configuration)
  once_configured do
    if self.configuration.global
    end
    BlockParty::Configurable.configure do |config|
      defaults = [
        :default_configuration_accessor,
        :default_configuration_callbacks,
        :default_initial_configuration_callbacks,
        :default_configuration_class
      ]
      defaults.each do |default|
        config.send :"#{default}=", BlockParty.configuration.send(default)
      end
    end
  end
  def self.new
    self.configuration.default_configuration_class.new
  end
end

BlockParty.configure do |config|
  config.global = true
  config.default_configuration_accessor = :configuration
  config.default_configuration_callbacks = []
  config.default_initial_configuration_callbacks = []
  config.default_configuration_class = BlockParty::Configuration
end

require 'block_party/extensions/rails/railtie' if defined?(Rails)
if defined?(ActiveRecord)
  require 'block_party/extensions/rails/active_record'
  ::ActiveRecord::Base.extend BlockParty::Rails::ActiveRecord
end

require "block_party/version"
