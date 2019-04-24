module Repla
  module Dependencies
    # Tester
    module Tester
      def self.check(name, type)
        case type
        when :shell_command
          check_shell_command(name)
        end
      end

      require 'shellwords'

      # TODO: `self.check_shell_command` should be private but now all of a
      # sudden instances method can't call private class methods?
      def self.check_shell_command(name)
        command = "type -a #{Shellwords.escape(name)} > /dev/null 2>&1"
        system(command)
      end
    end
  end
end
