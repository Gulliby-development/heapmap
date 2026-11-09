# frozen_string_literal: true

require "heapmap/registry"
require "heapmap/commands"

module Heapmap
  module Cli
    def self.run(args, input)
      first = args.first
      return { status: 2, out: "", err: USAGE } if args.empty?
      return { status: 0, out: USAGE, err: "" } if ["help", "-h", "--help"].include?(first)
      return { status: 0, out: "heapmap #{VERSION}\n", err: "" } if first == "--version"

      entry = COMMANDS.find { |command| command[:name] == first }
      return { status: 2, out: "", err: "heapmap: unknown command #{first}\n" } unless entry

      parsed = parse_options(args.drop(1))
      return command_error(parsed) if parsed.is_a?(String)

      options = parsed
      begin
        Commands.public_send(entry[:handler], options, input)
      rescue Failure => e
        { status: e.status, out: "", err: "heapmap: #{e.message}\n" }
      end
    end

    def self.reads_stdin?(args)
      return false if args.empty?
      return false if ["help", "-h", "--help", "--version"].include?(args.first)

      entry = COMMANDS.find { |command| command[:name] == args.first }
      return false unless entry

      !parse_options(args.drop(1)).is_a?(String)
    end

    def self.parse_options(words)
      options = { heap: DEFAULT_HEAP, fit: "first" }
      seen = {}
      index = 0

      while index < words.length
        word = words[index]
        unless ["--heap", "--fit"].include?(word)
          message = if word.empty? || word == "-" || !word.start_with?("-")
                      "unexpected argument #{word}"
                    else
                      "unknown option #{word}"
                    end
          return message
        end

        return "given twice: #{word}" if seen[word]
        return "missing value for #{word}" if index + 1 >= words.length

        value = words[index + 1]
        if word == "--heap"
          return "bad value for #{word}" unless value.match?(/\A[1-9][0-9]*\z/) && value.to_i <= MAX_HEAP

          options[:heap] = value.to_i
        else
          return "bad value for #{word}" unless FITS.include?(value)

          options[:fit] = value
        end
        seen[word] = true
        index += 2
      end

      options
    end

    def self.command_error(message)
      { status: 2, out: "", err: "heapmap: #{message}\n" }
    end
  end
end
