# coding: utf-8
# require 'sinatra/base'
require 'sinatra'
require 'sinatra/json'
require 'json'
require 'sinatra/reloader'
require 'data_mapper'
require_relative 'user'
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

  # ==== User API ==== #
  get '/users' do
    json(User.all)
  end

  post '/users', provides: :json do
    hash = JSON.parse(request.body.read)
    user = create_user(hash['name'], hash['password'])
    if user.nil?
      json(error: 'This user already exists.')
    else
      user.id.to_json
    end
  end

  # post '/users/signin' do
  #
  # end

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
