# coding: utf-8
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/reloader'
require 'data_mapper'
require_relative 'user'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'postgres://vagrant:vagrant@localhost/myapp')

# Sinatra Main controller
class MainApp < Sinatra::Base
  # Sinatra Auto Reload
  configure :development do
    register Sinatra::Reloader
  end
  # Session enable
  use Rack::Session::Pool, expire_after: 2_592_000

  get '/user' do
    remember_token = User.new_remember_token
    session[:remember_token] = remember_token

    user = User.create(name: 'hoge',
                       remember_token: User.encrypt(remember_token))
    json(user)
  end


end
