#!/usr/bin/env ruby

# This shebang doesn't use `--disable-gems` because otherwise it wouldn't be
# able to access `test/unit`.

require 'test/unit'

require_relative '../../../../../../repla'
require_relative 'constants'
require_relative '../../../../../lib/escape'

# Test environment
class TestEnviroment < Test::Unit::TestCase
  using Escape
  def test_plugin_name_key
    assert(ENV.key?(Repla::PLUGIN_NAME_KEY))
    plugin_name = ENV[Repla::PLUGIN_NAME_KEY]
    assert_equal(plugin_name, TEST_PLUGIN_NAME)
  end

  def test_split_id_key
    assert(ENV.key?(Repla::SPLIT_ID_KEY))
    window_id = ENV[Repla::SPLIT_ID_KEY]
    assert(!window_id.integer?)
  end

  def test_window_id_key
    assert(ENV.key?(Repla::WINDOW_ID_KEY))
    window_id = ENV[Repla::WINDOW_ID_KEY]
    assert(window_id.integer?)
    assert(window_id.to_i > 0)
  end

  def test_message_key
    assert(ENV.key?(TEST_MESSAGE_KEY))
    message = ENV[TEST_MESSAGE_KEY]
    assert_equal(message, TEST_MESSAGE_VALUE)
  end
end
