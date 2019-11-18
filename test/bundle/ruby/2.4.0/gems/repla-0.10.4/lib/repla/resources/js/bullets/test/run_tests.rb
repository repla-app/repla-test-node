#!/usr/bin/env ruby --disable-gems

require 'shellwords'

HTML_FILE = File.join(__dir__, 'lib/index.html')

exec("mocha-phantomjs #{Shellwords.escape(HTML_FILE)}")
