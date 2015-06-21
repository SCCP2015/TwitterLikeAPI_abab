# coding: utf-8
require 'sinatra'
require 'sinatra/json'
require 'json'
require 'sinatra/reloader'
require 'data_mapper'
require_relative 'user'
require_relative 'user_route'
require_relative 'tweet_route'
require_relative 'auth_helper'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'postgres://vagrant:vagrant@localhost/myapp')

# Sinatra Main controller
class MainApp < Sinatra::Base
  include AuthHelper
  # Sinatra Auto Reload
  configure :development do
    register Sinatra::Reloader
  end
  # Session enable
  use Rack::Session::Pool, expire_after: 2_592_000
  use UserRoute
  use TweetRoute
end
