require_relative 'view'
require_relative '../../../../../../lib/escape'

module Repla
  # Print module
  module Print
    using Escape
    # Print controller
    class Controller < Repla::Controller
      def initialize
        @view = View.new
      end

      def parse_line(line)
        line.chomp!
        line.javascript_escape!
        javascript = %[addOutput('#{line}');]
        @view.do_javascript(javascript)
      end
    end
  end
end
