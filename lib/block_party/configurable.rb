require "block_party/configuration"

module BlockParty
  module Configurable

    def self.inheritable_settings
      [
        :__configuration_class__,
        :__configuration_callbacks__,
        :__initial_configuration_callbacks__
      ]
    end

    def self.included(base)
      class << base
        accessor = Configurable.configuration.default_configuration_accessor
        unless method_defined? accessor
          attr_accessor accessor
        end
        attr_accessor *Configurable.inheritable_settings
      end
      base.instance_variable_set :@__configuration_class__,
        Configurable.configuration.default_configuration_class
      base.instance_variable_set :@__configuration_callbacks__,
        Configurable.configuration.default_configuration_callbacks
      base.instance_variable_set :@__initial_configuration_callbacks__,
        Configurable.configuration.default_initial_configuration_callbacks
      base.extend ConfigurationMethods
    end

    def self.extended(base)
      included(base)
    end

    module ConfigurationMethods
      def configure
        accessor = Configurable.configuration.default_configuration_accessor
        configuration = send(accessor)
        initial_configuration = !configuration

        if initial_configuration
          configuration = send(:"#{accessor}=", self.__configuration_class__.new)
        end

        yield(configuration) if block_given?

        if initial_configuration
          self.__initial_configuration_callbacks__.each do |callback|
            self.class_eval &callback
          end
        end

        self.__configuration_callbacks__.each do |callback|
          self.class_eval &callback
        end

        configuration
      end

      def configure_with(klass)
        self.__configuration_class__ = klass
      end

      def after_configuration(&block)
        self.__configuration_callbacks__ += [block] if block_given?
      end

      def once_configured(&block)
        self.__initial_configuration_callbacks__ += [block] if block_given?
      end

      def inherited(base)
        Configurable.inheritable_settings.each do |setting|
          base.instance_variable_set :"@#{setting}", send(setting)
        end
        super
      end
    end

  ####
  # An example of what using configurations would be like without `Configurable`
  #  since `Configurable` is configurable.
  ##
    class << self
      attr_accessor :configuration
      attr_accessor *Configurable.inheritable_settings
    end
    self.instance_variable_set :@__configuration_class__,
      BlockParty::Configuration
    self.instance_variable_set :@__configuration_callbacks__, []
    self.instance_variable_set :@__initial_configuration_callbacks__, []

    self.instance_variable_set :@configuration,
      Class.new(BlockParty::Configuration).new
    self.configuration.default_configuration_accessor = :configuration
    self.configuration.default_configuration_class = BlockParty::Configuration
    self.configuration.default_configuration_callbacks = []
    self.configuration.default_initial_configuration_callbacks = []
    extend ConfigurationMethods
  end
end
