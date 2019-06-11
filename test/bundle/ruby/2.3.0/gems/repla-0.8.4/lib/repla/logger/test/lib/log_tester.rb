module Repla
  # Test
  module Test
    ERROR_MESSAGES = [
      'Testing log error',
      'ERROR'
    ].freeze
    MESSAGES = [
      'Testing log message',
      'MESSAGE',
      'Done'
    ].freeze
    MESSAGE_COUNT = ERROR_MESSAGES.count + MESSAGES.count
    def self.test_log(window)
      test_log_helper = Repla::Test::LogHelper.new(window.window_id)
      result = nil
      expected = MESSAGE_COUNT
      Repla::Test.block_until do
        result = test_log_helper.number_of_log_messages
        result == expected
      end
      error_messages = []
      messages = []
      (0...MESSAGE_COUNT).each do |i|
        message = test_log_helper.log_message_at(i)
        type = test_log_helper.log_class_at(i)
        next if message.nil?

        if type == 'error'
          error_messages.push(message)
        else
          messages.push(message)
        end
      end
      if expected != result
        STDERR.puts "Expected #{expected} total messages instead of #{result}"
        STDERR.puts "Messages #{messages}"
        STDERR.puts "Error messages #{error_messages}"
        return false
      end
      # Buffering issues are causing the output of `TestLog.replaplugin` to be
      # unreliable, so for now we're running it through `/usr/bin/script`.
      # Which is reliable, but standard out and standard error get combined.
      combined_expected = ERROR_MESSAGES + MESSAGES
      combined_result = error_messages + messages
      expected = combined_expected.count
      result = combined_result.count
      if expected != result
        STDERR.puts "Expected #{expected} messages instead of #{result}"
        return false
      end
      (0..combined_expected.count).each do |i|
        expected = combined_expected[i]
        result = messages[i]
        next unless expected != result

        STDERR.puts "At index #{i}, expected message #{expected} instead of "\
          "#{result}"
        return false
      end
      # expected = MESSAGES.count
      # result = messages.count
      # if expected != result
      #   STDERR.puts "Expected #{expected} messages instead of #{result}"
      #   return false
      # end
      # expected = ERROR_MESSAGES.count
      # result = error_messages.count
      # if ERROR_MESSAGES.count != error_messages.count
      #   STDERR.puts "Expected #{expected} error messages instead of #{result}"
      #   return false
      # end
      # (0..MESSAGES.count).each do |i|
      #   expected = MESSAGES[i]
      #   result = messages[i]
      #   if expected != result
      #     STDERR.puts "At index #{i}, expected message #{expected} instead "\
      #       "of #{result}"
      #     return false
      #   end
      # end
      # (0..ERROR_MESSAGES.count).each do |i|
      #   expected = ERROR_MESSAGES[i]
      #   result = error_messages[i]
      #   if expected != result
      #     STDERR.puts "At index #{i}, expected error message #{expected} "\
      #       "instead of #{result}"
      #     return false
      #   end
      # end
      true
    end
  end
end
