# -*- coding: utf-8 -*-
require 'curb'

class Notify
  URL = 'https://notify-api.line.me/api/notify'

  def initialize(classes, logger)
    @classes = classes
    @logger = logger
  end

  def load
    @classes.each do |c|
      yield c[:clazz].new, c[:interval]
    end
  end

  def load_config(file, config_key = nil)
    obj = File.exist?(file) ? YAML.load_file(file) : ENV
    config_key.nil? ? obj : obj[config_key]
  end

  def get_access_token
    path = File.dirname(__FILE__) + "/../config/config.yml"
    load_config(path, 'LINE_NOTIFY_ACCESS_TOKEN')
  end

  def send(instance)
    text = instance.text
    response = Curl.post(URL, {message: text}) do |curl|
      curl.headers['Authorization'] = "Bearer #{get_access_token}"
    end
    @logger.info response.response_code
    @logger.info text
  end
end
