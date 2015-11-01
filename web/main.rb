require 'sinatra'
require 'chartkick'
require 'yaml'
require 'string-utility'
require_relative '../utils/utilities'

$gh = Utilities.configure_stuff(token: ENV['GHULS_TOKEN'])
$demonyms = YAML.load_file("#{Dir.pwd}/web/public/demonyms.yml")
$adjective_path = "#{Dir.pwd}/web/public/adjectives.txt"

get '/' do
  erb :index
end

get '/analyze' do
  analyze(params[:user])
end

get '/analyze-random' do
  analyze(Utilities.get_random_username($gh[:git]))
end

def analyze(user)
  user_data = Utilities.analyze_user(user, $gh[:git])
  org_data = Utilities.analyze_orgs(user, $gh[:git])
  if user_data != false
    user_adjective = StringUtility.random_line($adjective_path)
    user_colors = []
    user_demonym = nil
    user_data.each do |l, p|
      if p == user_data.values.max
        if $demonyms.key?(l.to_s)
          user_demonym = $demonyms.fetch(l.to_s)
        else
          user_demonym = "#{l} coder"
        end
      end
      user_colors.push(Utilities.get_color_for_language(l.to_s, $gh[:colors]))
    end

    variables = {
      user_data: user_data,
      user: user,
      user_adjective: user_adjective,
      user_demonym: user_demonym,
      user_colors: user_colors
    }

    if org_data != false
      org_adjective = StringUtility.random_line($adjective_path)
      org_colors = []
      org_demonym = nil
      org_data.each do |l, p|
        if p == org_data.values.max
          if $demonyms.key?(l.to_s)
            org_demonym = $demonyms.fetch(l.to_s)
          else
            org_demonym = "#{l} coder"
          end
        end
        org_colors.push(Utilities.get_color_for_language(l.to_s, $gh[:colors]))
      end

      variables[:org_data] = org_data
      variables[:org_adjective] = org_adjective
      variables[:org_demonym] = org_demonym
      variables[:org_colors] = org_colors
      variables[:org_exists] = true
    else
      variables[:org_exists] = false
    end
    erb :result, locals: variables
  else
    erb :fail, locals: { user: user }
  end
end
