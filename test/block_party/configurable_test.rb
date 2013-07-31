require 'test_helper'

class ConfigurableTest < MiniTest::Test
  def setup
    @configurable = Class.new{ include Configurable }
  end

####
# Configure Method
##
  def test_nonconfigured_classes_have_no_configuration
    assert_nil @configurable.configuration
  end
  def test_configured_classes_have_a_configuration
    @configurable.configure
    assert @configurable.configuration
  end
  def test_configured_classes_instanciate_configurations
    @configurable.configure
    assert_instance_of Configuration, @configurable.configuration
  end
  def test_configuration_blocks_are_consumed
    @configurable.configure do |config|
      config.is_set = true
    end
    assert @configurable.configuration.is_set
  end
  def test_inherited_classes_dont_preserve_configurations
    @configurable.configure
    inherited = Class.new(@configurable)
    refute_equal @configurable.configuration, inherited.configuration
  end

####
# Configuration Class
##
  def test_config_class_defaults_to_Configuration
    assert_equal Configuration, @configurable.__configuration_class__
  end
  def test_configure_with_sets_custom_configuration_classes
    @configurable.configure_with BasicObject
    assert_equal BasicObject, @configurable.__configuration_class__
  end
  def test_inherited_classes_preserve_configuration_class
    @configurable.configure_with BasicObject
    inherited = Class.new(@configurable)
    assert_equal BasicObject, inherited.__configuration_class__
  end


####
# Configuration Callbacks
##
  def test_callbacks_run_more_than_once_per_configuring
    class << @configurable
      attr_accessor :times_ran
    end
    @configurable.after_configuration do
      self.times_ran ||= 0
      self.times_ran +=  1
    end
    @configurable.configure
    @configurable.configure
    assert_equal 2, @configurable.times_ran
  end
# Then run the normal callback gauntlet
  def test_callbacks_default_to_none
    assert_empty @configurable.__configuration_callbacks__
  end
  def test_after_configuration_sets_a_callback
    @configurable.after_configuration {}
    refute_empty @configurable.__configuration_callbacks__
  end
  def test_after_configuration_only_adds_blocks_to_callbacks
    @configurable.after_configuration
    assert_empty @configurable.__configuration_callbacks__
  end
  def test_after_configuration_sets_a_callback_proc
    @configurable.after_configuration {}
    assert_instance_of Proc, @configurable.__configuration_callbacks__.first
  end
  def test_callbacks_get_run
    @configurable.after_configuration do
      self.configuration.ran = true
    end
    @configurable.configure
    assert @configurable.configuration.ran
  end
  def test_multiple_callbacks_get_run_in_context_of_their_class
    @configurable.after_configuration do
      self.configuration.ran_in_class = name
    end
    @configurable.configure
    assert_equal @configurable.name, @configurable.configuration.ran_in_class
  end
  def test_multiple_callbacks_get_set
    @configurable.after_configuration {}
    @configurable.after_configuration {}
    assert_equal 2, @configurable.__configuration_callbacks__.length
  end
  def test_multiple_callbacks_get_run
    @configurable.after_configuration do
      self.configuration.first_ran = true
    end
    @configurable.after_configuration do
      self.configuration.second_ran = true
    end
    @configurable.configure
    assert @configurable.configuration.first_ran
    assert @configurable.configuration.second_ran
  end
  def test_multiple_callbacks_get_run_in_order
    @configurable.after_configuration do
      self.configuration.run = 1
    end
    @configurable.after_configuration do
      self.configuration.run = 2
    end
    @configurable.configure
    assert_equal 2, @configurable.configuration.run
  end
  def test_inherited_classes_preserve_callbacks
    @configurable.after_configuration do
      define_singleton_method(:callback) { true }
    end
    inherited = Class.new(@configurable)
    inherited.configure
    assert inherited.callback
  end
  def test_inherited_classes_dont_add_to_parent_callbacks
    inherited = Class.new(@configurable)
    inherited.after_configuration {}
    assert_empty @configurable.__configuration_callbacks__
  end

####
# Initial Configuration Callbacks
##
  def test_inital_callbacks_only_run_once_per_configuring
    class << @configurable
      attr_accessor :times_ran
    end
    @configurable.once_configured do
      self.times_ran ||= 0
      self.times_ran +=  1
    end
    @configurable.configure
    @configurable.configure
    assert_equal 1, @configurable.times_ran
  end
# Then run the normal callback gauntlet
  def test_initial_callbacks_default_to_none
    assert_empty @configurable.__initial_configuration_callbacks__
  end
  def test_after_configuration_sets_a_initial_callback
    @configurable.once_configured {}
    refute_empty @configurable.__initial_configuration_callbacks__
  end
  def test_once_configured_only_adds_blocks_to_initial_callbacks
    @configurable.once_configured
    assert_empty @configurable.__initial_configuration_callbacks__
  end
  def test_once_configured_sets_a_initial_callback_proc
    @configurable.once_configured {}
    assert_instance_of Proc, @configurable.__initial_configuration_callbacks__.first
  end
  def test_initial_callbacks_get_run
    @configurable.once_configured do
      self.configuration.ran = true
    end
    @configurable.configure
    assert @configurable.configuration.ran
  end
  def test_initial_callbacks_get_run_in_context_of_their_class
    @configurable.once_configured do
      self.configuration.ran_in_class = name
    end
    @configurable.configure
    assert_equal @configurable.name, @configurable.configuration.ran_in_class
  end
  def test_multiple_initial_callbacks_get_set
    @configurable.once_configured {}
    @configurable.once_configured {}
    assert_equal 2, @configurable.__initial_configuration_callbacks__.length
  end
  def test_multiple_initial_callbacks_get_run
    @configurable.once_configured do
      self.configuration.first_ran = true
    end
    @configurable.once_configured do
      self.configuration.second_ran = true
    end
    @configurable.configure
    assert @configurable.configuration.first_ran
    assert @configurable.configuration.second_ran
  end
  def test_multiple_initial_callbacks_get_run_in_order
    @configurable.once_configured do
      self.configuration.run = 1
    end
    @configurable.once_configured do
      self.configuration.run = 2
    end
    @configurable.configure
    assert_equal 2, @configurable.configuration.run
  end
  def test_inherited_classes_preserve_initial_callbacks
    @configurable.once_configured do
      define_singleton_method(:initial_callback) { true }
    end
    inherited = Class.new(@configurable)
    inherited.configure
    assert inherited.initial_callback
  end
  def test_inherited_classes_dont_add_to_parent_initial_callbacks
    inherited = Class.new(@configurable)
    inherited.once_configured {}
    assert_empty @configurable.__initial_configuration_callbacks__
  end

end
