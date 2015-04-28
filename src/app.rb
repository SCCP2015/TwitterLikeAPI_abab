# coding: utf-8
require 'sinatra/base'
require 'sinatra/reloader'

# Sinatra Main controller
class MainApp < Sinatra::Base
  # Sinatra Auto Reload
  configure :development do
    register Sinatra::Reloader
  end
  get '/' do
    if File.exist?('data')
      File.read('data')
    else
      ''
    end
  end
  post '/' do
    body = request.body.gets + "\n"
    if File.exist?('data')
      data = File.read('data')
      File.write('data', data + body)
      data + body
    else
      File.write('data', body)
      body
    end
  end
  put '/' do
    body = request.body.gets + "\n"
    File.write('data', body)
    body
  end
  delete '/' do
    File.write('data', '')
    ''
  end
end
