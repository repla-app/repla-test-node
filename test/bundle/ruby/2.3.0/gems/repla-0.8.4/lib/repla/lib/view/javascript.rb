require_relative '../escape'

# Repla
module Repla
  using Escape
  # View
  class View < Window
    def do_javascript_function(function, arguments = nil)
      javascript = self.class.javascript_function(function, arguments)
      do_javascript(javascript)
    end

    def self.javascript_function(function, arguments = nil)
      function = function.dup
      function << '('

      if arguments
        arguments.each do |argument|
          function << if argument
                        argument.javascript_argument
                      else
                        'null'
                      end
          function << ', '
        end
        function = function[0...-2]
      end

      function << ');'
    end
  end
end
