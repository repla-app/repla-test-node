module Repla
  module Dependencies
    # Dependency
    class Dependency
      attr_reader :name, :type, :options
      def initialize(name, type, options = {})
        @name = name
        @type = type
        @options = options
      end
    end
  end
end
