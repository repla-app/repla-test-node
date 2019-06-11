#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby --disable-gems

require 'Shellwords'

HTML_FILE = File.join(__dir__, 'lib/index.html')

exec("mocha-phantomjs #{Shellwords.escape(HTML_FILE)}")
