# -*- coding: utf-8 -*-
$: << File.dirname(__FILE__) + "/../lib"
require 'notify'
require 'trend_tweet'
require 'log4r'

class TestNotifier
  def text
    "test"
  end
end

logger = Log4r::Logger.new("rumble-notify")
logger.level = 1 # INFO
logger.outputters = []
logger.outputters << Log4r::StdoutOutputter.new('console', {
  :formatter => Log4r::PatternFormatter.new(
    :pattern => "[%l] %d: %M",
    :date_format => "%Y/%m/%d %H:%M:%Sm"
  )
})

notify = Notify.new(nil, logger)
notify.send(TestNotifier.new)
