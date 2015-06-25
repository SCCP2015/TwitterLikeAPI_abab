# coding: utf-8
require 'sinatra'
require 'sinatra/json'
require 'json'
require_relative 'user'
require_relative 'auth_helper'
require_relative 'http_helper'

# UserRoute
class UserRoute < Sinatra::Base
  include AuthHelper
  include HttpHelper
  get '/users' do
    json(User.all)
  end

  get '/users/:id' do
    user = User.get(params[:id].to_i)
    return bad_response('This user is not exist.') if user.nil?
    json(user)
  end

  post '/users', provides: :json do
    hash = JSON.parse(request.body.read)
    user = create_user(hash['name'], hash['password'])
    return bad_response('This user already exists.') if user.nil?
    signin(user.id)
  end

  get '/sessions' do
    json(UserSession.all)
  end

  post '/user/auth', provides: :json do
    hash = JSON.parse(request.body.read)
    signin_by_name_pass(hash['name'], hash['password'])
  end

  post '/user/auth/token', provides: :json do
    hash = JSON.parse(request.body.read)
    signin?(hash['token'])
  end

  # signout
  delete '/sessions/:id/user' do
    delete_session(params[:id])
    true
  end

  def signin?(token)
    return bad_response('token is empty') if token.nil?
    session = authenticate_by_token(token)
    return User.get(session.user_id).to_json if session
    status 401 # Unauthorized
    json(false)
  end

  def signin(user_id)
    user = User.get(user_id)
    if user
      json(user.to_hash.merge(token: create_token(user_id)))
    else
      status 401 # Unauthorized
      json(false)
    end
  end

  def signin_by_name_pass(name, password)
    user = find_user(name, password)
    return bad_response('This user is not exist, or wrong password.') if
      user.nil?
    signin(user.id)
  end

  def create_token(user_id)
    token = new_token
    delete_session(user_id)
    UserSession.create(
      token_hash: to_hash(token), create_time: Time.now, user_id: user_id)
    token
  end
end

# post /users
# {"name", "hoge", "password", "hoge"}
#
#+--------+  post   +-------------------+  return    +------+
# | Client | ------> | name and password | ---------> | User |
# +--------+         +-------------------+            +------+
#                       |
#                       | return
#                       v
#              +-------------------+
#              |       token       |
#              +-------------------+
#
# post /user/auth?content=name_pass
#
# +--------+   auth    +-------------------+  return    +------+
# | Client | --------> | name and password | ---------> | User |
# +--------+           +-------------------+            +------+
#                            |
#                            | return
#                            v
#                  +-------------------+
#                  |       token       |
#                  +-------------------+
#
# post /user/auth?content=token
#
# +--------+   auth    +-------+  return   +------+
# | Client | --------> | token | --------> | User |
# +--------+           +-------+           +------+
#
