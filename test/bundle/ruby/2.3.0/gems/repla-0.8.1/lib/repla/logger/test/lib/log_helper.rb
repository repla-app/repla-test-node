require_relative 'test_setup'

module Repla
  module Test
    # Log helper
    class LogHelper
      TEST_CLASS_JAVASCRIPT = 'document.body.lastChild.classList[0]'.freeze
      TEST_MESSAGE_JAVASCRIPT = 'document.body.lastChild.innerText'.freeze
      TEST_MESSAGE_COUNT_JAVASCRIPT = 'document.body.children.length'.freeze

      TEST_JAVASCRIPT_DIRECTORY = File.join(__dir__, '..', 'js')
      TEST_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY,
                                       'test_view_helper.js')
      def initialize(window_id, view_id = nil)
        view_id ||= Repla.split_id_in_window_last(window_id)
        @view = Repla::View.new(window_id, view_id)
        javascript = File.read(TEST_JAVASCRIPT_FILE)
        @view.do_javascript(javascript)
      end

      def log_message_at(index)
        @view.do_javascript_function('innerTextOfBodyChildAtIndex', [index])
      end

      def log_class_at(index)
        @view.do_javascript_function('classOfBodyChildAtIndex', [index])
      end

      def number_of_log_messages
        @view.do_javascript(TEST_MESSAGE_COUNT_JAVASCRIPT)
      end

      def last_log_message
        @view.do_javascript(TEST_MESSAGE_JAVASCRIPT)
      end

      def last_log_class
        @view.do_javascript(TEST_CLASS_JAVASCRIPT)
      end
    end
  end
end
