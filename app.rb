# myapp.rb
require 'sinatra'
require 'lib/cms'
require "./controller"


configure do
  require 'dotenv'
  Dotenv.load
  #enable :sessions
  #set :json_encoder, :to_json
  #set :erb, :layout => :layout
end