# coding: utf-8
require 'sinatra'
require 'sinatra/json'
require 'json'
require_relative 'user'
require_relative 'auth_helper'
require_relative 'http_helper'

# FollowRoute
class FollowerRoute < Sinatra::Base
  include AuthHelper
  include HttpHelper
  get '/followers' do
    json(Follower.all)
  end

  post '/followers', provides: :json do
    hash = JSON.parse(request.body.read)
    user = find_user_by_token(hash['token'])
    follower_id = hash['follower_id']
    if user.nil?
      status 401 # Unauthorized
      json(error: 'This user is not exist.')
    else
      return bad_response('Follower_id is empty.') if follower_id.nil?
      follower =
        Follower.create(
          user_id: user.id, follower_id: follower_id, create_time: Time.now)
      follower.id.to_json
    end
  end

  get '/followers/:id' do
    follower = Follower.get(params[:id].to_i)
    return bad_response('This follower is not exist.') if follower.nil?
    json(follower)
  end

  get '/followers/user/:user_id' do
    followers_id_list = Follower.all(
      user_id: params[:user_id].to_i).map(&:follower_id)
    json(User.all(id: followers_id_list))
  end

  get '/followers/user/:user_id/unfollow' do
    user_id = params[:user_id].to_i
    followers_id_list = Follower.all(
      user_id: params[:user_id].to_i).map(&:follower_id)
    follow_users = User.all(id: followers_id_list)
    unfollow_users = User.all(:id.not => user_id) - follow_users
    json(unfollow_users)
  end
end
