# coding: utf-8
require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'database'

# Sinatra Main controller
class MainApp < Sinatra::Base
  # Sinatra Auto Reload
  configure :development do
    register Sinatra::Reloader
  end
  get '/' do
    Database.instance.read
  end
  post '/' do
    body = request.body.gets
    Database.instance.write(body)
  end
  put '/' do
    body = request.body.gets
    Database.instance.update(body)
  end
  delete '/' do
    Database.instance.delete
  end
end
