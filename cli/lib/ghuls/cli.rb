require 'octokit'
require 'base64'
require 'rainbow'
require 'progress_bar'
require_relative '../../../utils/utilities'

module GHULS
  class CLI
    # Parses the arguments (typically ARGV) into a usable hash.
    # @param args [Array] The arguments to parse.
    def parse_options(args)
      args.each do |arg|
        case arg
        when '-h', '--help' then @opts[:help] = true
        when '-un', '--user' then @opts[:user] = Utilities.get_next(arg, args)
        when '-pw', '--pass' then @opts[:pass] = Utilities.get_next(arg, args)
        when '-t', '--token' then @opts[:token] = Utilities.get_next(arg, args)
        when '-g', '--get' then @opts[:get] = Utilities.get_next(arg, args)
        when '-d', '--debug' then @opts[:debug] = true
        end
      end
    end

    def increment
      @bar.increment! if @opts[:debug]
    end

    # Creates a new instance of GHULS::CLI
    # @param args [Array] The arguments for the CLI.
    def initialize(args = ARGV)
      @opts = {
        help: false,
        user: nil,
        pass: nil,
        token: nil,
        get: nil,
        debug: nil
      }

      @usage = 'Usage: ghuls [-h] [-un] username [-pw] password [-t] token ' \
               '[-g] username [-d] debug'
      @help = "-h, --help     Show helpful information.\n" \
              "-d, --debug    Provide debug information.\n" \
              "-un, --user    The username to log in as.\n" \
              "-pw, --pass    The password for that username.\n" \
              '-t, --token    The token to log in as. This will be preferred ' \
              "over username and password authentication.\n" \
              "-g, --get      The username/organization to analyze.\n"

      parse_options(args)
      @bar = ProgressBar.new(5) if @opts[:debug]
      increment
      config = Utilities.configure_stuff(@opts)
      increment
      if config == false
        puts 'Error: authentication failed, check your username/password ' \
             ' or token'
        exit
      end
      @gh = config[:git]
      @colors = config[:colors]
    end

    # Whether or not the script should fail.
    # @return [Boolean] False if it did not fail, true if it did.
    def failed?
      false if @opts[:help]
      true if @opts[:get].nil?
      true if @opts[:token].nil? && @opts[:user].nil?
      true if @opts[:token].nil? && @opts[:pass].nil?
    end

    def output(percents)
      percents.each do |l, p|
        color = Utilities.get_color_for_language(l.to_s, @colors)
        puts Rainbow("#{l}: #{p}%").color(color)
      end
    end

    def fail_after_analyze
      puts 'Sorry, something went wrong.'
      puts "We either could not find anyone under the name #{@opts[:get]}, " \
           'or we could not find any data for them.'
      puts 'Please try again with a different user. If you believe this is ' \
           'an error, please report it to the developer.'
      exit
    end

    # Simply runs the program.
    def run
      puts @usage if failed?
      puts @help if @opts[:help]
      exit if failed?
      increment
      user_percents = Utilities.analyze_user(@opts[:get], @gh)
      increment
      org_percents = Utilities.analyze_orgs(@opts[:get], @gh)
      increment

      if user_percents != false
        puts "Getting language data for #{@opts[:get]}..."
        output(user_percents)
        if org_percents != false
          puts 'Getting language data for their organizations...'
          output(org_percents)
        else
          exit
        end
      else
        fail_after_analyze
      end
      exit
    end
  end
end
