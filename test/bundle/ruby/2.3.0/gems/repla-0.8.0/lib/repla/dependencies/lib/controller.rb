require_relative 'tester'
require_relative 'model'
require_relative 'view'

module Repla
  module Dependencies
    # Dependencies controller
    class Controller < Repla::Controller
      def initialize
        @view = View.new
      end

      def missing_dependency(dependency)
        name = dependency.name
        type = self.class.string_for_type(dependency.type)
        options = dependency.options
        if options.key?(:installation_instructions)
          installation_instructions = options[:installation_instructions]
        end
        @view.add_missing_dependency(name, type, installation_instructions)
      end

      # TODO: `self.string_for_type` should be private but now all of a sudden
      # instances method can't call private class methods?
      def self.string_for_type(type)
        case type
        when :shell_command
          return 'shell command'
        end
        nil
      end
    end
  end
end
