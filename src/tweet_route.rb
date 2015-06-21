# coding: utf-8
require 'sinatra'
require 'sinatra/json'
require 'json'
require_relative 'user'
require_relative 'auth_helper'

# TweetRoute
class TweetRoute < Sinatra::Base
  include AuthHelper
  get '/tweets' do
    json(Tweet.all)
  end

  post '/tweets', provides: :json do
    hash = JSON.parse(request.body.read)
    user = find_user_by_token(session[:token])
    message = hash['message']
    return json(error: 'This user is not exist.') if user.nil?
    return json(error: 'Message is empty.') if message.strip.empty?
    tweet =
      Tweet.create(message: message, user_id: user.id, create_time: Time.now)
    tweet.id.to_json
  end

  get '/tweets/:id' do
    tweet = Tweet.get(params[:id].to_i)
    return json(error: 'This tweet is not exist.') if tweet.nil?
    json(tweet)
  end
end
