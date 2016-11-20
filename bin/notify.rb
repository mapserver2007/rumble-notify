# -*- coding: utf-8 -*-
$: << File.dirname(__FILE__) + "/../lib"
require 'notify'
require 'trend_tweet'
require 'optparse'
require 'log4r'
require 'clockwork'
include Clockwork

config = [
  { clazz: TrendTweet, interval: 1.hour }
]

logger = Log4r::Logger.new("rumble-notify")
logger.level = 1 # INFO
logger.outputters = []
logger.outputters << Log4r::StdoutOutputter.new('console', {
  :formatter => Log4r::PatternFormatter.new(
    :pattern => "[%l] %d: %M",
    :date_format => "%Y/%m/%d %H:%M:%Sm"
  )
})

notify = Notify.new(config, logger)
notify.load do |instance, interval|
  handler do |job|
    Thread.new { notify.send(job) }
  end

  every(interval, instance)
end
