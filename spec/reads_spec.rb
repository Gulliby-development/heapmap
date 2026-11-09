# frozen_string_literal: true

require "harness"

rows = [
  [["help"], "", 0, "", ""],
  [["-h"], "", 0, "", ""],
  [[], "", 0, "", ""],
  [["frob"], "", 0, "", ""],
  [["map"], "", 1, "", ""],
  [["trace", "--heap", "8"], "", 1, "", ""],
  [["stats", "--fit", "best", "--heap", "8"], "", 1, "", ""],
  [["check", "--fit", "x"], "", 0, "", ""],
  [["check", "x"], "", 0, "", ""],
  [["map", "--heap"], "", 0, "", ""],
  [["map", "--heap", "8", "--heap", "9"], "", 0, "", ""],
  [["--version"], "", 0, "", ""],
  [["map", "--heap", "256"], "", 1, "", ""],
  [["map", "--heap", "257"], "", 0, "", ""]
].freeze

Harness.check_reads(rows)
