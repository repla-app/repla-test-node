require_relative '../../test'
require 'minitest/autorun'

module Repla
  module Test
    # View helper
    module ViewHelper
      def self.make_windows(filename)
        file_view = make_file_view(filename, Window)
        url_view = make_url_view(filename, Window)
        raise unless file_view.class == Window

        raise unless url_view.class == Window

        [file_view, url_view]
      end

      def self.make_views(filename)
        file_view = make_file_view(filename)
        url_view = make_url_view(filename)
        raise if file_view.class != View

        raise if url_view.class != View

        [file_view, url_view]
      end

      def self.make_file_view(filename, view_class = View)
        file = Repla::Test.html_file(filename)
        view = view_class.new
        view.load_file(file)
        view
      end

      def self.make_url_view(filename, view_class = View.new)
        Repla.load_plugin(Repla::Test::TEST_SERVER_PLUGIN_FILE)
        window_id = Repla.run_plugin(Repla::Test::TEST_SERVER_PLUGIN_NAME,
                                     Repla::Test::TEST_HTML_DIRECTORY)
        raise if window_id.nil?

        url = Repla::Test.html_server_url(filename)
        view = view_class.new(window_id)
        view.load_url(url, should_clear_cache: true)
        view
      end
    end
  end
end
