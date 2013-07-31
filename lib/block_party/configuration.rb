require 'block_party/configuration/conversion'
require 'block_party/configuration/identity'
require 'block_party/configuration/comparison'
require 'block_party/configuration/enumeration'

module BlockParty
  class Configuration

  ####
  # INTERFACE
  ##
    def configure
      yield(self) if block_given?
      self
    end

    def method_missing(setting, *args, &block)
      setter, getter = derive_setting_names(setting)
      create_accessors setter, getter
      if setter? setting
        set setter, *args, &block
      else
        set_nested_configuration setter, *args, &block
      end
    end


    def instance_variables
      super.reject do |var|
        [:"@__hash_representation__", :"@__hash_representation__="].include? var
      end
    end

    def settings
      instance_variables.map do |var|
        var.to_s.gsub('@', '').to_sym
      end
    end

    def unset(setting)
      setting = setting.to_sym
      setting = :"@#{setting}" unless setting.to_s =~ /^@/
      remove_instance_variable setting
    end

  protected

  ####
  # IMPLEMENTATION
  ##
    def derive_setting_names(setting_name)
      if setter? setting_name
        [ setting_name, setter_to_getter(setting_name) ]
      else
        [ getter_to_setter(setting_name), setting_name ]
      end
    end

    def setter?(setting)
      setting =~ /=$/
    end

    def create_accessors(setter, getter)
      create_setter(setter)
      create_getter(getter)
    end

    def create_setter(setter)
      define_singleton_method setter do |value|
        instance_variable_set :"@#{setter_to_getter(setter)}", value
      end
    end

    def create_getter(getter)
      define_singleton_method getter do
        instance_variable_get :"@#{getter}"
      end
    end

    def setter_to_getter(setter)
      :"#{setter.to_s.gsub('=','')}"
    end

    def getter_to_setter(getter)
      :"#{getter}="
    end

    def set(setter, *args, &block)
      if block_given?
        send setter, *args, &block
      else
        send setter, *args
      end
    end

    def set_nested_configuration(setter, *args, &block)
      configuration = send setter, Configuration.new
      yield(configuration) if block_given?
      configuration
    end

  ####
  # COMPONENTS
  ##
    include Identity
    include Conversion
    include Comparison
    include Enumeration

  end
end
