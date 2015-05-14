# coding: utf-8
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/reloader'
# require 'data_mapper'

# DataMapper::Logger.new($stdout, :debug)
# DataMapper.setup(:default, 'postgres://vagrant:vagrant@localhost/myapp')

# Sinatra Main controller
class MainApp < Sinatra::Base
  # Sinatra Auto Reload
  configure :development do
    register Sinatra::Reloader
  end
  # Session enable
  use Rack::Session::Pool, expire_after: 2_592_000

  get '/session' do
    session.id
  end

  get '/session/value' do
    'value = ' << session[:value].inspect
  end
  post '/session/value' do
    body = request.body.gets
    session[:value] = body
    body
  end
end
