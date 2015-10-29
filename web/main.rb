require 'sinatra'

get '/' do
  erb :index
end

get '/search' do
  puts 'a search how crazy'
end
