# Repla
module Repla
  require_relative 'repla/lib/constants'
  require_relative 'repla/lib/window'
  require_relative 'repla/lib/controller'
  require_relative 'repla/lib/view'
  require_relative 'repla/lib/module'
end

# Exists: Removing for now because there is no safe way of determinining if
# the application is installed.
# 1. There's one method that uses the Finder, but that requires prompting the
# user after Mojave
# 2. There's another method that doesn't use the Finder, but it will hang if
# the process originates from the app
# The hang may only be in tests?
# Repla.application_exists || abort('The Repla application is not installed.')
