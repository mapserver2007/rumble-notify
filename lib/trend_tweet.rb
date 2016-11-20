# -*- coding: utf-8 -*-
require 'uri'
require 'mechanize'
require 'curb'

class TrendTweet
  USERAGENT = "Mac Mozilla"
  REALTIME_BUZZ_URL = 'http://searchranking.yahoo.co.jp/realtime_buzz/'
  MIN_RETWEET_NUM = 1000

  def initialize
    @agent = create_agent
  end

  def text
    site = @agent.get(REALTIME_BUZZ_URL)
    result = nil
    rt = 0
    url = nil
    lines = (site/'//*[@id="main"]/div/ul/li/div[2]')
    lines.each do |line|
      tmp_rt = line.search('b').inner_text.tr('RT', '').to_i
      if tmp_rt > rt && MIN_RETWEET_NUM > rt
        rt = tmp_rt
        url = line.search('p[class="tweetName"]/a')[1].attribute("href").value
      end
    end

    if rt > 0
      url = expand(url)
      source_site = @agent.get(url)
      text_elem = (source_site/'//p[@class="TweetTextSize TweetTextSize--26px js-tweet-text tweet-text"]').last
      text = text_elem.inner_text + " RT:#{rt}" unless text_elem.nil?
      result = "#{text}\n#{url}"
    end

    result
  end

  def create_agent
    agent = Mechanize.new
    agent.user_agent_alias = USERAGENT
    agent.read_timeout = 10
    agent
  end

  private
  def expand(url, limit = 10)
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    curl = Curl.get(url)
    http_response, *http_headers = curl.header_str.split(/[\r\n]+/).map(&:strip)
    http_headers = Hash[http_headers.flat_map {|s| s.scan(/^(\S+): (.+)/)}]

    case http_response
    when 'HTTP/1.1 301 Moved Permanently', 'HTTP/1.1 302 Found'
      expand(http_headers['Location'], limit - 1)
    when 'HTTP/1.1 200 OK'
      url
    else
      raise StandardError, "failed to redirect url: #{url}"
    end
  end
end
