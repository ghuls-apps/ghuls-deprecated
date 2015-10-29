require 'sinatra'
require_relative '../utils/utilities'

gh = Utilities.configure_stuff(token: ENV['GHULS_TOKEN'])

get '/' do
  erb :index
end

get '/analyze' do
  # do something with this data that it gets.
  # Utilities.analyze(params[:user], gh[:git])
end
