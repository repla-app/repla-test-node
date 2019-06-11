#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby --disable-gems

require_relative '../../../../../../repla'
require_relative 'lib/controller'

controller = Repla::Print::Controller.new

ARGF.each do |line|
  controller.parse_line(line)
end
