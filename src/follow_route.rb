# coding: utf-8
require 'sinatra'
require 'sinatra/json'
require 'json'
require_relative 'user'
require_relative 'auth_helper'
require_relative 'http_helper'

# FollowRoute
class FollowRoute < Sinatra::Base
  include AuthHelper
  include HttpHelper
  get '/follows' do
    json(Follow.all)
  end

  post '/follows', provides: :json do
    hash = JSON.parse(request.body.read)
    user = find_user_by_token(hash['token'])
    follow_id = hash['follow_id']

    if user.nil?
      status 401 # Unauthorized
      json(error: 'This user is not exist.')
    else
      return bad_response('Message is empty.') if follow_id.nil?
      follow =
        Follow.create(user_id: user.id, follow_id: follow_id,
                      create_time: Time.now)
      follow.id.to_json
    end
  end

  get '/follows/:id' do
    follow = Follow.get(params[:id].to_i)
    return bad_response('This follow is not exist.') if follow.nil?
    json(follow)
  end

  get '/follows/user/:user_id/count' do
    json(Tweet.all(user_id: params[:user_id].to_i).count)
  end
end
