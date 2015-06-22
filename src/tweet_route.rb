# coding: utf-8
require 'sinatra'
require 'sinatra/json'
require 'json'
require_relative 'user'
require_relative 'auth_helper'
require_relative 'http_helper'

# TweetRoute
class TweetRoute < Sinatra::Base
  include AuthHelper
  include HttpHelper
  get '/tweets' do
    json(Tweet.all)
  end

  post '/tweets', provides: :json do
    hash = JSON.parse(request.body.read)
    user = find_user_by_token(hash['token'])
    message = hash['message']
    message ||= ''

    if user.nil?
      status 401 # Unauthorized
      json(error: 'This user is not exist.')
    else
      return bad_response('Message is empty.') if message.strip.empty?
      tweet =
        Tweet.create(message: message, user_id: user.id, create_time: Time.now)
      tweet.id.to_json
    end
  end

  get '/tweets/:id' do
    tweet = Tweet.get(params[:id].to_i)
    return bad_response('This tweet is not exist.') if tweet.nil?
    json(tweet)
  end
end
