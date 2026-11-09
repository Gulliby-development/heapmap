# frozen_string_literal: true

require "harness"

rows = [
  [["map", "x"], "", 2, "", "heapmap: unexpected argument x\n"],
  [["map", ""], "", 2, "", "heapmap: unexpected argument \n"],
  [["trace", "-"], "", 2, "", "heapmap: unexpected argument -\n"],
  [["check", "--nope"], "", 2, "", "heapmap: unknown option --nope\n"],
  [["map", "--heap"], "", 2, "", "heapmap: missing value for --heap\n"],
  [["map", "--heap", "0"], "", 2, "", "heapmap: bad value for --heap\n"],
  [["map", "--heap", "007"], "", 2, "", "heapmap: bad value for --heap\n"],
  [["map", "--heap", "256"], "", 0, "heap 256 used 0 free 256\ngaps 0+256\n", ""],
  [["map", "--heap", "257"], "", 2, "", "heapmap: bad value for --heap\n"],
  [["map", "--heap", "abc"], "", 2, "", "heapmap: bad value for --heap\n"],
  [["map", "--heap", ""], "", 2, "", "heapmap: bad value for --heap\n"],
  [["map", "--fit", "FIRST"], "", 2, "", "heapmap: bad value for --fit\n"],
  [["map", "--fit"], "", 2, "", "heapmap: missing value for --fit\n"],
  [["map", "--heap", "8", "--heap", "9"], "", 2, "", "heapmap: given twice: --heap\n"],
  [["stats", "--fit", "best", "--fit", "worst"], "", 2, "", "heapmap: given twice: --fit\n"],
  [["map", "--heap", "--fit"], "", 2, "", "heapmap: bad value for --heap\n"],
  [["map", "--fit", "--heap", "8"], "", 2, "", "heapmap: bad value for --fit\n"],
  [["map", "--heap", "8", "x"], "", 2, "", "heapmap: unexpected argument x\n"],
  [["trace", "--fit", "worst", "--heap", "8"], "alloc a 3\n", 0, "alloc a 3 -> at 0\n", ""]
].freeze

Harness.check_rows(rows)
