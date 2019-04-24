require_relative '../repla'

module Repla
  # Logger
  class Logger
    MESSAGE_PREFIX = 'MESSAGE '.freeze
    ERROR_PREFIX = 'ERROR '.freeze
    LOG_PLUGIN_NAME = 'Log'.freeze

    def initialize
      @mutex = Mutex.new
    end
    # Toggle

    SHOW_LOG_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'show_log.scpt')
    def show
      Repla.run_applescript(SHOW_LOG_SCRIPT, [window_id])
    end

    HIDE_LOG_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'hide_log.scpt')
    def hide
      Repla.run_applescript(HIDE_LOG_SCRIPT, [window_id])
    end

    TOGGLE_LOG_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'toggle_log.scpt')
    def toggle
      Repla.run_applescript(TOGGLE_LOG_SCRIPT, [window_id])
    end

    # Messages

    def info(message)
      message = message.dup
      message.gsub!(/^/, MESSAGE_PREFIX) # Prefix all lines
      # Strip trailing white space
      # Add a line break
      log_message(message)
    end

    def error(message)
      message = message.dup
      message.gsub!(/^/, ERROR_PREFIX)
      log_message(message)
    end

    # Properties

    def window_id
      key = WINDOW_ID_KEY
      @window_id ||= ENV.key?(key) ? ENV[key] : Repla.create_window
    end

    def view_id
      view_id = nil
      @mutex.synchronize do
        @view_id ||= Repla.split_id_in_window(window_id, LOG_PLUGIN_NAME)
        return @view_id unless @view_id.nil?

        @view_id = Repla.split_id_in_window_last(window_id)
        Repla.run_plugin_in_split(LOG_PLUGIN_NAME, window_id, @view_id)
        view_id = @view_id
      end
      view_id
    end

    private

    READ_FROM_STANDARD_INPUT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY,
                                                'read_from_standard_input.scpt')
    def log_message(message)
      message.rstrip!
      message += "\n"
      Repla.run_applescript(READ_FROM_STANDARD_INPUT_SCRIPT,
                            [message, window_id, view_id])
    end
  end
end
