# coding: utf-8
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
      signin(user.id)
      user.id.to_json
    end
  end

  get '/users/tokens' do
    json(UserSession.all)
  end

  get '/users/isSignin' do
    json(signin?)
  end

  # ==== Session ==== #
  def signin?
    token = session[:token]
    if token.nil?
      false
    elsif authenticate_by_token(token)
      true
    else
      false
    end
  end

  def signin(user_id)
    user_session = UserSession.first(user_id: user_id)
    if user_session
      update_token(user_session)
      true
    elsif User.get(user_id)
      create_token(user_id)
      true
    else
      false
    end
  end

  def create_token(user_id)
    token = new_token
    session[:token] = token
    UserSession.create(
      token_hash: to_hash(token), create_time: Time.now, user_id: user_id)
  end

  def update_token(user_session)
    token = new_token
    session[:token] = token
    user_session.update(token_hash: to_hash(token), create_time: Time.now)
  end

  # def signout
  # session[:remember_token] = nil
  # end
end
