require 'test_helper'

class BlockPartyTest < MiniTest::Test

  def test_that_libray_is_preconfigured
    assert BlockParty.configuration
  end

  def test_that_libray_is_preconfigured_to_load_globally
    assert BlockParty.configuration.global
  end
  def test_that_configuration_is_globally_preloaded
    assert defined?(::Configuration)
  end
  def test_that_configurable_is_globally_preloaded
    assert defined?(::Configurable)
  end

  def test_that_new_returns_a_new_configuration
    assert_instance_of BlockParty::Configuration, BlockParty.new
  end

end
