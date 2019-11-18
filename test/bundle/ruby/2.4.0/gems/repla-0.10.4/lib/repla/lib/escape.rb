require 'shellwords'

# Escaping parameters
module Escape
  # Escaping floats
  module FloatEscape
    def javascript_argument
      to_s
    end
  end
  # Escaping integers
  module IntegerEscape
    def javascript_argument
      to_s
    end
  end

  # Escaping strings
  module StringEscape
    def javascript_argument
      "'#{StringEscape.javascript_escape(self)}'"
    end

    def javascript_escape
      StringEscape.javascript_escape(self)
    end

    def javascript_escape!
      replace(StringEscape.javascript_escape(self))
    end

    def float?
      true if Float(self)
    rescue StandardError
      false
    end

    def integer?
      to_i.to_s == self
    end

    def shell_escape
      StringEscape.shell_escape(self)
    end

    def shell_escape!
      replace(StringEscape.shell_escape(self))
    end

    # TODO: `self.javascript_escape` and `self.shell_escape` should be private,
    # but instance methods can't call private class methods in Ruby? Or can
    # they this only fails when the code imported into the `gem`?

    def self.javascript_escape(string)
      # string.gsub('\\', '\\\\\\\\').gsub("\n", '\\\\n').gsub("'", "\\\\'")
      # Combined as one command, comparable in speed:
      string.gsub(/\\\\|\n|'/,
                  '\\\\' => '\\\\\\\\',
                  "\n" => '\\n',
                  "'" => '\\\'')
    end

    def self.shell_escape(string)
      Shellwords.escape(string)
    end
  end

  refine String do
    include StringEscape
  end

  refine Integer do
    include IntegerEscape
  end

  refine Float do
    include FloatEscape
  end
end
