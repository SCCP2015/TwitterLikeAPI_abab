require 'sinatra/base'
require 'sinatra/reloader'

# Sinatra Main controller
class MainApp < Sinatra::Base
  # Sinatra Auto Reload
  configure :development do
    register Sinatra::Reloader
  end
  get '/' do
    'Hello, World!'
  end
  get '/echo/:word' do
    "#{params['word']}"
  end
  get '/date' do
    Time.now.to_s
  end
  get '/sum/:n1/:n2/:n3' do
    (params['n1'].to_i + params['n2'].to_i + params['n3'].to_i).to_s
  end
  get '/reverse/:word' do
    params['word'].reverse
  end
end
