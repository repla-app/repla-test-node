module Repla
  module REPL
    # REPL view
    class View < Repla::View
      ROOT_ACCESS_DIRECTORY = File.join(__dir__, '../../')
      HTML_DIRECTORY = File.join(__dir__, '../html/')
      VIEW_TEMPLATE = File.join(HTML_DIRECTORY, 'index.html')
      def initialize
        super
        self.root_access_directory_path = File.expand_path(
          ROOT_ACCESS_DIRECTORY
        )
        load_file(VIEW_TEMPLATE)
      end

      ADD_INPUT_JAVASCRIPT_FUNCTION = 'WcREPL.addInput'.freeze
      def add_input(input)
        do_javascript_function(ADD_INPUT_JAVASCRIPT_FUNCTION, [input])
      end

      ADD_OUTPUT_JAVASCRIPT_FUNCTION = 'WcREPL.addOutput'.freeze
      def add_output(output)
        do_javascript_function(ADD_OUTPUT_JAVASCRIPT_FUNCTION, [output])
      end
    end
  end
end
