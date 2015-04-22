# myapp.rb
require 'sinatra'
require 'cms'
require "./controller"


configure do
  require 'dotenv'
  Dotenv.load
  #enable :sessions
  #set :json_encoder, :to_json
  #set :erb, :layout => :layout

  # logging is enabled by default in classic style applications,
  # so `enable :logging` is not needed
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end