# frozen_string_literal: true

module Heapmap
  VERSION = "0.1.0"
  DEFAULT_HEAP = 64
  MAX_HEAP = 256
  MAX_LINES = 40
  FITS = %w[first best worst].freeze

  USAGE = <<~TEXT
    usage: heapmap map [--heap N] [--fit POLICY]
           heapmap trace [--heap N] [--fit POLICY]
           heapmap stats [--heap N] [--fit POLICY]
           heapmap check [--heap N] [--fit POLICY]
  TEXT

  # One entry per command: its word and the function of Heapmap::Commands that runs it.
  COMMANDS = [
    { name: "map", handler: :map_command },
    { name: "trace", handler: :trace_command },
    { name: "stats", handler: :stats_command },
    { name: "check", handler: :check_command }
  ].freeze

  # A failure that ends the command: status 1 for the script, 2 for the command line.
  class Failure < StandardError
    attr_reader :status

    def initialize(status, message)
      super(message)
      @status = status
    end
  end
end
