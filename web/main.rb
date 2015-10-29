require 'sinatra'
require 'chartkick'
require 'yaml'
require 'string-utility'
require_relative '../utils/utilities'

gh = Utilities.configure_stuff(token: ENV['GHULS_TOKEN'])
demonyms = YAML.load_file("#{Dir.pwd}/web/public/demonyms.yml")

get '/' do
  erb :index
end

get '/analyze' do
  adjective = StringUtility.random_line("#{Dir.pwd}/web/public/adjectives.txt")
  user = params[:user]
  data = Utilities.analyze(user, gh[:git])
  colors = []
  demonym = nil
  data.each do |l, p|
    if p == data.values.max
      if demonyms.key?(l.to_s)
        demonym = demonyms.fetch(l.to_s)
      else
        demonym = "#{l} coder"
      end
    end
    colors.push(Utilities.get_color_for_language(l.to_s, gh[:colors]))
  end
  erb :result, locals: { data: data, user: user, colors: colors,
                         adjective: adjective, demonym: demonym }
end
