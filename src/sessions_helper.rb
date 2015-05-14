# coding: utf-8

module SessionsHelper
  def sign_in(user)

  end

end

class MainApp < Sinatra::Base
  # Sinatra Auto Reload
  configure :development do
    register Sinatra::Reloader
  end
  # Session enable
  use Rack::Session::Pool, expire_after: 2_592_000

  get '/session' do
    session.id
  end

  get '/session/value' do
    'value = ' << session[:value].inspect
  end
  post '/session/value' do
    body = request.body.gets
    session[:value] = body
    body
  end
end
