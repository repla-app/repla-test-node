require_relative '../repla'

module Repla
  # REPL
  module REPL
    require_relative 'repl/lib/input_controller'
    require_relative 'repl/lib/output_controller'
    require_relative 'repl/lib/view'

    # Wrapper
    class Wrapper
      require 'pty'

      def initialize(command)
        PTY.spawn(command) do |output, input, _pid|
          Thread.new do
            output.each do |line|
              output_controller.parse_output(line)
            end
          end
          @input = input
        end
      end

      def parse_input(input)
        input_controller.parse_input(input)
        write_input(input)
      end

      def write_input(input)
        @input.write(input)
      end

      private

      def input_controller
        @input_controller ||= InputController.new(view)
      end

      def output_controller
        @output_controller ||= OutputController.new(view)
      end

      def view
        @view ||= View.new
      end
    end
  end
end
