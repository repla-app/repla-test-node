#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby --disable-gems

require 'minitest/autorun'

require_relative 'lib/test_setup'
require_relative 'lib/log_tester'
require_relative '../../logger'

# Test constants
class TestConstants < Minitest::Test
  def test_constants
    message_prefix = Repla::Logger::MESSAGE_PREFIX
    refute_nil(message_prefix)
    error_prefix = Repla::Logger::ERROR_PREFIX
    refute_nil(error_prefix)
  end
end

# Test unitialized logger
class TestUnintializedLogger < Minitest::Test
  def setup
    @logger = Repla::Logger.new
  end

  def teardown
    window = Repla::Window.new(@logger.window_id)
    window.close
  end

  def test_uninitialized_logger
    # Test Message
    message = 'Testing log message'
    @logger.info(message)
    # Make sure the log messages appear before accessing the logger's `view_id`
    # and `window_id` because those run the logger. This test should test
    # logging a message and running the logger itself simultaneously. This is
    # why the `LogHelper` is intialized after logging the message.
    test_log_helper = Repla::Test::LogHelper.new(@logger.window_id,
                                                 @logger.view_id)
    test_message = nil
    Repla::Test.block_until do
      test_message = test_log_helper.last_log_message
      test_message == message
    end

    assert_equal(message, test_message, 'The messages should match')
    test_class = test_log_helper.last_log_class
    assert_equal('message', test_class, 'The classes should match')
  end
end

# Test logger
class TestLoggerObject < Minitest::Test
  def setup
    @logger = Repla::Logger.new
    @logger.show
    @test_log_helper = Repla::Test::LogHelper.new(@logger.window_id,
                                                  @logger.view_id)
    @window = Repla::Window.new(@logger.window_id)
  end

  def teardown
    @window.close
  end

  def test_logger_object
    # Test Error
    # This test doesn't call `@logger.error` because `TestLog.replaplugin` had
    # to be changed being run with `/usr/bin/script` which combines standard
    # output and standard error.
    message = 'Testing log error'
    @logger.info(message)
    # @logger.error(message)
    message = Repla::Logger::ERROR_PREFIX.rstrip
    @logger.info(message)
    # @logger.error(message)
    message = 'Testing log message'
    @logger.info(message)
    message = Repla::Logger::MESSAGE_PREFIX.rstrip
    @logger.info(message)
    @logger.info('')
    @logger.info("  \t")
    @logger.info('Done')
    result = Repla::Test.test_log(@window)
    assert(result)
    # TODO: Also add the following tests the `Log.replaplugin`

    # Test Whitespace
    # White space to the left should be preserved, whitespace to the right
    # should be removed This test fails because retrieving the `innerText`
    # doesn't preserve whitepace.

    # message = "\t Testing log message"
    # @logger.info(message + "\t ")
    # sleep Repla::Test::TEST_PAUSE_TIME # Pause for output to be processed
    # test_message = @test_log_helper.last_log_message
    # assert_equal(message, test_message, "The messages should match")
    # test_class = @test_log_helper.last_log_class
    # assert_equal("message", test_class, "The classes should match")
    # result_count = @test_log_helper.number_of_log_messages
    # test_count += 1
    # assert_equal(test_count, result_count)
  end

  def test_long_input
    message = '
Line 1

Line 2
Line 3
'
    lines = 3
    @logger.info(message)
    result_count = nil
    Repla::Test.block_until do
      result_count = @test_log_helper.number_of_log_messages
      result_count == lines
    end
    assert_equal(result_count, lines)

    (1..lines).each do |i|
      result = @test_log_helper.log_message_at(i - 1)
      test_result = "Line #{i}"
      assert_equal(result,
                   test_result,
                   'The number of log messages should match')
    end
  end
end

# Test logging via standard out
class TestSimpleLogging < Minitest::Test
  def setup
    Repla.load_plugin(Repla::Test::TEST_LOG_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Test::TEST_LOG_PLUGIN_NAME)
    @window = Repla::Window.new(window_id)
    assert(window_id == @window.window_id)
  end

  def test_simple_logging
    result = Repla::Test.test_log(@window)
    assert(result)
  end

  def teardown
    @window.close
  end
end

# Test logger threads
class TestLoggerThreads < Minitest::Test
  def setup
    @logger = Repla::Logger.new
    @logger.show
  end

  def teardown
    window = Repla::Window.new(@logger.window_id)
    window.close
  end

  def test_multiple_threads
    error_text = 'Error line'
    message_text = 'Info line'
    message_called = false
    message_thread = Thread.new do
      @logger.info(message_text)
      message_called = true
    end

    error_called = false
    error_thread = Thread.new do
      @logger.error(error_text)
      error_called = true
    end

    message_thread.join
    error_thread.join

    assert(error_called)
    assert(message_called)
    @test_log_helper = Repla::Test::LogHelper.new(@logger.window_id,
                                                  @logger.view_id)
    Repla::Test.block_until { @test_log_helper.number_of_log_messages >= 2 }
    result = @test_log_helper.last_log_message
    result_two = @test_log_helper.log_message_at(0)
    assert(result == message_text || result_two == message_text)
    assert(result == error_text || result_two == error_text)
  end
end
