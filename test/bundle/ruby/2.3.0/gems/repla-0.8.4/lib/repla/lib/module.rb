require 'Shellwords'
require_relative 'escape'

# Repla
module Repla
  using Escape

  @debug = false
  class << self
    attr_accessor :debug
  end

  LOAD_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'load_plugin.scpt')
  def self.load_plugin(path)
    run_applescript(LOAD_PLUGIN_SCRIPT, [path])
  end

  EXISTS_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'exists.scpt')
  def self.application_exists
    result = run_applescript(EXISTS_SCRIPT)
    result == 'true'
  end

  RUN_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'run_plugin.scpt')
  def self.run_plugin(name, directory = nil, arguments = nil)
    parameters = [name]
    parameters.push(directory) unless directory.nil?
    parameters += arguments unless arguments.nil?
    run_applescript(RUN_PLUGIN_SCRIPT, parameters)
  end

  RUN_PLUGIN_WITH_ENVIRONMENT_SCRIPT = File.join(
    APPLESCRIPT_DIRECTORY, 'run_plugin_with_environment.scpt'
  )
  def self.run_plugin_with_environment(name, environment)
    parameters = [name, environment]
    run_applescript(RUN_PLUGIN_WITH_ENVIRONMENT_SCRIPT, parameters)
  end

  RUN_PLUGIN_IN_SPLIT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY,
                                         'run_plugin_in_split.scpt')
  def self.run_plugin_in_split(name, window_id, split_id)
    parameters = [name, window_id, split_id]
    run_applescript(RUN_PLUGIN_IN_SPLIT_SCRIPT, parameters)
  end

  WINDOW_ID_FOR_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY,
                                          'window_id_for_plugin.scpt')
  def self.window_id_for_plugin(name)
    run_applescript(WINDOW_ID_FOR_PLUGIN_SCRIPT, [name])
  end

  SPLIT_ID_IN_WINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY,
                                        'split_id_in_window.scpt')
  def self.split_id_in_window(window_id, plugin_name = nil)
    arguments = [window_id]
    arguments.push(plugin_name) unless plugin_name.nil?
    run_applescript(SPLIT_ID_IN_WINDOW_SCRIPT, arguments)
  end

  SPLIT_ID_IN_WINDOW_LAST_SCRIPT = File.join(APPLESCRIPT_DIRECTORY,
                                             'split_id_in_window_last.scpt')
  def self.split_id_in_window_last(window_id)
    arguments = [window_id]
    run_applescript(SPLIT_ID_IN_WINDOW_LAST_SCRIPT, arguments)
  end

  CREATE_WINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'create_window.scpt')
  def self.create_window
    run_applescript(CREATE_WINDOW_SCRIPT)
  end

  # Resources

  RESOURCE_PATH_FOR_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY,
                                              'resource_path_for_plugin.scpt')
  def self.resource_path_for_plugin(name)
    run_applescript(RESOURCE_PATH_FOR_PLUGIN_SCRIPT, [name])
  end

  RESOURCE_URL_FOR_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY,
                                             'resource_url_for_plugin.scpt')
  def self.resource_url_for_plugin(name)
    run_applescript(RESOURCE_URL_FOR_PLUGIN_SCRIPT, [name])
  end

  # TODO: `self.run_applescript` should be private but now all of a sudden
  # instances method can't call private class methods?
  def self.run_applescript(script, arguments = nil)
    # command = "/usr/bin/osascript #{script.shell_escape}"
    command = "/usr/bin/osascript #{script}"

    if arguments
      command += ' ' + arguments.compact.map(&:to_s).map do |x|
        x.shell_escape
      end.join(' ')
    end

    puts command if @debug
    result = `#{command}`

    result.chomp!

    return nil if result.empty?
    return result.to_i if result.integer?
    return result.to_f if result.float?

    result
  end
end
