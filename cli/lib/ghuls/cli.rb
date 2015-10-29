require 'octokit'
require 'optparse'
require 'base64'
require 'rainbow'
require 'string-utility'
require_relative "#{Dir.pwd}/utils/utilities"

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
      config = Utilities.configure_stuff(@opts)
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

    # Simply runs the program.
    def run
      puts @usage if failed?
      puts @help if @opts[:help]
      exit if failed?
      puts "Outputting language data for #{@opts[:get]}..."
      percents = Utilities.analyze(@gh, @opts[:get])
      percents.each do |l, p|
        color = Utilities.get_color_for_language(l.to_s, @colors)
        color = StringUtility.random_color_six if color.nil?
        puts Rainbow("#{l}: #{p}%").color(color)
      end
    end
  end
end
