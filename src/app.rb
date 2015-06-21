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

  get '/users/:id' do
    user = User.get(params[:id].to_i)
    if user.nil?
      json(error: 'This user is not exist.')
    else
      json(user)
    end
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

  get '/sessions' do
    json(UserSession.all)
  end

  post '/sessions', provides: :json do
    hash = JSON.parse(request.body.read)
    puts "#{hash['name']}:#{hash['password']}"
    user = find_user(hash['name'], hash['password'])
    if user.nil?
      json(error: 'This user is not exist or Wrong name or password.')
    else
      signin(user.id)
      user.id.to_json
    end
  end

  get '/user/signin' do
    json(signin?)
  end

  get '/tweets' do
    json(Tweet.all)
  end

  post '/tweets', provides: :json do
    hash = JSON.parse(request.body.read)
    user = find_user_by_token(session[:token])
    message = hash['message']
    if user.nil?
      json(error: 'This user is not exist.')
    elsif message.strip.empty?
      json(error: 'Message is empty.')
    else
      tweet =
        Tweet.create(message: message, user_id: user.id, create_time: Time.now)
      tweet.id.to_json
    end
  end

  get '/tweets/:id' do
    tweet = Tweet.get(params[:id].to_i)
    if tweet.nil?
      json(error: 'This tweet is not exist.')
    else
      json(user)
    end
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
end
