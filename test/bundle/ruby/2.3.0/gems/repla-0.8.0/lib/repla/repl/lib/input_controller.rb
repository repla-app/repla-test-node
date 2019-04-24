module Repla
  module REPL
    # Input controller
    class InputController < Repla::Controller
      attr_accessor :view
      def initialize(view)
        @view = view
      end

      def parse_input(input)
        input = input.dup
        input.chomp!
        @view.add_input(input) unless input.strip.empty? # Ignore empty lines
      end
    end
  end
end
