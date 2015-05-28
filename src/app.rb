# coding: utf-8
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/reloader'
require 'data_mapper'
require_relative 'user'
require_relative 'sessions_helper'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'postgres://vagrant:vagrant@localhost/myapp')

# Sinatra Main controller
class MainApp < Sinatra::Base
  include SessionsHelper
  # Sinatra Auto Reload
  configure :development do
    register Sinatra::Reloader
  end
  # Session enable
  use Rack::Session::Pool, expire_after: 2_592_000

  # ==== User API ==== #
  post '/user' do
    name = request.body.gets
    remember_token = new_remember_token
    session[:remember_token] = remember_token
    user = User.create(name: name, create_time: Time.now)
    json(user)
    # remember_token: encrypt(remember_token))
  end

  # ==== Session ==== #
  # def signin
  # request.body.gets
  #  session[:remember_token] = User.new_rember_token
  #  User.
  # end

  # def signout
  # session[:remember_token] = nil
  # end
end
