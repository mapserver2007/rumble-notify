# -*- coding: utf-8 -*-
require 'yaml'

config_files = [
  YAML.load_file(File.dirname(__FILE__) + "/config/config.yml"),
]

config = {}
config_files.each do |file|
  file.each {|key, value| config[key] = value}
end

task:default => [:github_push, :heroku_deploy]

task :github_push do
  sh 'git push origin master'
end

task :heroku_deploy => [:github_push] do
  sh 'git push heroku master'
end

task :heroku_env => [:heroku_env_clean, :timezone] do
  config.each do |key, value|
    sh "heroku config:add #{key}=#{value}"
  end
end

task :heroku_env_clean do
  config.each do |key, value|
    sh "heroku config:remove #{key}"
  end
end

task :heroku_create do
  sh "heroku create --stack cedar-14 rumble-notify"
end

task :heroku_server_upgrade do
  sh "heroku stack:set heroku-18 -a rumble-notify"
end

task :timezone do
  sh "heroku config:add TZ=Asia/Tokyo"
end

task :heroku_start do
  sh "heroku scale clock=1"
end

task :heroku_stop do
  sh "heroku scale clock=0"
end

task :heroku_bundler_update do
  sh "heroku buildpacks:set https://github.com/bundler/heroku-buildpack-bundler2.git"
end