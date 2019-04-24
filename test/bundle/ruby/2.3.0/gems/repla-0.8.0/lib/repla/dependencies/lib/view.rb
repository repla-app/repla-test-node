module Repla
  module Dependencies
    # Dependency view
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

      ADD_MISSING_DEPENDENCY_FUNCTION = 'addMissingDependency'.freeze
      def add_missing_dependency(name, type, installation_instructions = nil)
        do_javascript_function(ADD_MISSING_DEPENDENCY_FUNCTION,
                               [name, type, installation_instructions])
      end
    end
  end
end
