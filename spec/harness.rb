# frozen_string_literal: true

require "heapmap/cli"

# The helper of the row files: each row is [args, input, status, out, err] or, for check_reads, [args, "", reads, "", ""].
module Harness
  def self.check_rows(rows)
    RSpec.describe "rows" do
      rows.each_with_index do |(args, input, status, out, err), index|
        it "row #{index + 1}" do
          reply = Heapmap::Cli.run(args, input)
          expect([reply[:status], reply[:out], reply[:err]]).to eq([status, out, err])
        end
      end
    end
  end

  def self.check_reads(rows)
    RSpec.describe "reads_stdin?" do
      rows.each_with_index do |(args, _input, reads, _out, _err), index|
        it "row #{index + 1}" do
          expect(Heapmap::Cli.reads_stdin?(args)).to eq(reads == 1)
        end
      end
    end
  end
end
