require 'octokit'
require 'optparse'
require 'base64'
require 'rainbow'

module GHULS
  class CLI
    # Gets the next value in an array.
    # @param single [Any] The current value.
    # @param full [Array] The main array to parse.
    # @return [Any] The next value in the array.
    def get_next(single, full)
      full.at(full.index(single) + 1)
    end

    # Parses the arguments (typically ARGV) into a usable hash.
    # @param args [Array] The arguments to parse.
    def parse_options(args)
      args.each do |arg|
        case arg
        when '-h', '--help' then @opts[:help] = true
        when '-un', '--user' then @opts[:user] = get_next(arg, args)
        when '-pw', '--pass' then @opts[:pass] = get_next(arg, args)
        when '-t', '--token' then @opts[:token] = get_next(arg, args)
        when '-g', '--get' then @opts[:get] = get_next(arg, args)
        end
      end
    end

    # Creates a new instance of GHULS::CLI
    # @param args [Array] The arguments for the CLI.
    def initialize(args = ARGV)
      @opts = {
        help: false,
        user: nil,
        pass: nil,
        token: nil,
        get: nil
      }

      @usage = 'Usage: ghuls [-h] [-un] username [-pw] password [-t] token ' \
               '[-g] username'
      @help = "-h, --help     Show helpful information.\n" \
              "-un, --user    The username to log in as.\n" \
              "-pw, --pass    The password for that username.\n" \
              '-t, --token    The token to log in as. This will be preferred ' \
              "over username and password authentication.\n" \
              '-g, --get      The username/organization to analyze.'

      parse_options(args)
      token = @opts[:token]
      user = @opts[:user]
      pass = @opts[:pass]
      @gh = Octokit::Client.new(login: user, password: pass) if token.nil?
      @gh = Octokit::Client.new(access_token: token)
      encoded = @gh.contents('ozh/github-colors', path: 'colors.json')[:content]
      @colors = JSON.parse(Base64.decode64(encoded))
    end

    # Whether or not the script should fail.
    # @return [Boolean] False if it did not fail, true if it did.
    def failed?
      false if @opts[:help]

      true if @opts[:get].nil?
      true if @opts[:token].nil? && @opts[:user].nil?
      true if @opts[:token].nil? && @opts[:pass].nil?
    end

    # Gets the langauges and their bytes for the :get user.
    # @return [Hash] The languages and their bytes, as formatted as
    #   { :Ruby => 129890, :CoffeeScript => 5970 }
    def get_langs
      repos = @gh.repositories(@opts[:get])
      langs = {}
      repos.each do |r|
        next if r[:fork]
        repo_langs = @gh.languages(r[:full_name])
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
    def calculate_percent(part, whole)
      (part / whole) * 100
    end

    def get_color_for_language(lang)
      return @colors[lang]['color'] unless @colors[lang]['color'].nil?
    end

    # Simply runs the program.
    def run
      puts @usage if failed?
      puts @help if @opts[:help]
      exit if failed?
      languages = get_langs
      total = 0
      languages.each { |_, b| total += b }
      language_percentages = {}
      languages.each do |l, b|
        percent = calculate_percent(b, total.to_f)
        language_percentages[l] = percent.round(2)
      end
      puts "Outputting language data for #{@opts[:get]}..."
      language_percentages.each do |l, p|
        color = get_color_for_language(l.to_s)
        puts Rainbow("#{l}: #{p}%").color(color)
      end
    end
  end
end
