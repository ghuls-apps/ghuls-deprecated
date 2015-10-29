require 'octokit'

module Utilities
  # Gets the Octokit and colors for the program.
  # @param opts [Hash] The options to use. The ones that are used by this method
  #   are: :token, :pass, and :user.
  # @return [Hash] A hash containing objects formatted as
  #   { git: Octokit::Client, colors: JSON }
  def self.configure_stuff(opts = {})
    token = opts[:token]
    pass = opts[:pass]
    user = opts[:user]
    gh = Octokit::Client.new(login: user, password: pass) if token.nil?
    gh = Octokit::Client.new(access_token: token) unless token.nil?
    encoded = gh.contents('ozh/github-colors', path: 'colors.json')[:content]
    colors = JSON.parse(Base64.decode64(encoded))
    { git: gh, colors: colors }
  end

  # Gets the next value in an array.
  # @param single [Any] The current value.
  # @param full [Array] The main array to parse.
  # @return [Any] The next value in the array.
  def self.get_next(single, full)
    full.at(full.index(single) + 1)
  end

  def self.user_exists?(username, github)
    begin
      github.user(username).is_a?(Octokit::NotFound)
    rescue Octokit::NotFound
      return false
    end
    true
  end

  # Gets the langauges and their bytes for the :user.
  # @param username [String] The username to get info for.
  # @param github [OctoKit::Client] The instance of Octokit::Client.
  # @return [Hash] The languages and their bytes, as formatted as
  #   { :Ruby => 129890, :CoffeeScript => 5970 }
  def self.get_langs(username, github)
    repos = github.repositories(username)
    langs = {}
    repos.each do |r|
      next if r[:fork]
      repo_langs = github.languages(r[:full_name])
      repo_langs.each do |l, b|
        if langs[l].nil?
          langs[l] = b
        else
          existing = langs[l]
          langs[l] = existing + b
        end
      end
    end
    langs
  end

  # Gets the percentage for the given numbers.
  # @param part [Fixnum] The partial value.
  # @param whole [Fixnum] The whole value.
  # @return [Fixnum] The percentage that part is of whole.
  def self.calculate_percent(part, whole)
    (part / whole) * 100
  end

  # Gets the defined color for the language.
  # @param lang [String] The language name.
  # @param colors [Hash] The hash of colors and languages.
  # @return [String] The 6 digit hexidecimal color.
  # @return [Nil] If there is no defined color for the language.
  def self.get_color_for_language(lang, colors)
    return colors[lang]['color'] unless colors[lang]['color'].nil?
  end

  def self.analyze(username, github)
    if user_exists?(username, github)
      languages = get_langs(username, github)
      total = 0
      languages.each { |_, b| total += b }
      language_percentages = {}
      languages.each do |l, b|
        percent = Utilities.calculate_percent(b, total.to_f)
        language_percentages[l] = percent.round(2)
      end
      language_percentages
    else
      false
    end
  end
end
