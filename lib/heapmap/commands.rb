# frozen_string_literal: true

require "heapmap/runner"
require "heapmap/report"

module Heapmap
  module Commands
    def self.map_command(options, input)
      result = Runner.run(options, input)
      { status: 0, out: Report.map(result), err: "" }
    end

    def self.trace_command(options, input)
      result = Runner.run(options, input)
      { status: 0, out: Report.trace(result), err: "" }
    end

    def self.stats_command(options, input)
      result = Runner.run(options, input)
      { status: 0, out: Report.stats(result), err: "" }
    end

    def self.check_command(options, input)
      result = Runner.run(options, input)
      { status: 0, out: Report.check(result), err: "" }
    end
  end
end
