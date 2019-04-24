require_relative '../repla'

module Repla
  module Dependencies
    # Checks whether plugin dependencies are installed
    class Checker
      require_relative 'dependencies/lib/model'
      require_relative 'dependencies/lib/controller'

      def check_dependencies(dependencies)
        passed = true
        dependencies.each do |dependency|
          dependency_passed = check(dependency)
          passed = false unless dependency_passed
        end
        passed
      end

      def check(dependency)
        name = dependency.name
        type = dependency.type
        passed = Tester.check(name, type)
        controller.missing_dependency(dependency) unless passed
        passed
      end

      private

      def controller
        @controller ||= Controller.new
      end
    end
  end
end
