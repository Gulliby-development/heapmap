# frozen_string_literal: true

require "harness"

rows = [
  [["map", "--heap", "20"], "alloc a 4\nalloc b 3\nalloc c 5\n", 0, "heap 20 used 12 free 8\na 0 4\nb 4 3\nc 7 5\ngaps 12+8\n", ""],
  [["map", "--heap", "20", "--fit", "first"], "alloc a 4\nalloc b 3\nalloc c 5\nfree a\nfree c\nalloc d 3\n", 0, "heap 20 used 6 free 14\nd 0 3\nb 4 3\ngaps 3+1 7+13\n", ""],
  [["map", "--heap", "20", "--fit", "best"], "alloc a 4\nalloc b 3\nalloc c 5\nfree a\nfree c\nalloc d 3\n", 0, "heap 20 used 6 free 14\nd 0 3\nb 4 3\ngaps 3+1 7+13\n", ""],
  [["map", "--heap", "20", "--fit", "worst"], "alloc a 4\nalloc b 3\nalloc c 5\nfree a\nfree c\nalloc d 3\n", 0, "heap 20 used 6 free 14\nb 4 3\nd 7 3\ngaps 0+4 10+10\n", ""],
  [["map", "--heap", "20", "--fit", "best"], "alloc a 4\nalloc b 3\nalloc c 5\nfree a\nfree c\nalloc d 4\n", 0, "heap 20 used 7 free 13\nd 0 4\nb 4 3\ngaps 7+13\n", ""],
  [["map", "--heap", "20", "--fit", "worst"], "alloc a 4\nalloc b 3\nalloc c 5\nfree a\nfree c\nalloc d 4\nalloc e 4\n", 0, "heap 20 used 11 free 9\nb 4 3\nd 7 4\ne 11 4\ngaps 0+4 15+5\n", ""],
  [["map", "--heap", "16", "--fit", "best"], "alloc a 2\nalloc b 2\nalloc c 2\nalloc d 2\nfree a\nfree c\nalloc e 2\n", 0, "heap 16 used 6 free 10\ne 0 2\nb 2 2\nd 6 2\ngaps 4+2 8+8\n", ""],
  [["map", "--heap", "16", "--fit", "worst"], "alloc a 2\nalloc b 2\nalloc c 2\nalloc d 2\nfree a\nfree c\nalloc e 2\n", 0, "heap 16 used 6 free 10\nb 2 2\nd 6 2\ne 8 2\ngaps 0+2 4+2 10+6\n", ""],
  [["map", "--heap", "16", "--fit", "worst"], "alloc a 3\nalloc b 3\nfree a\nalloc c 2\n", 0, "heap 16 used 5 free 11\nb 3 3\nc 6 2\ngaps 0+3 8+8\n", ""],
  [["map", "--heap", "8"], "alloc a 8\n", 0, "heap 8 used 8 free 0\na 0 8\ngaps none\n", ""],
  [["map", "--heap", "8"], "alloc a 5\nalloc b 4\n", 0, "heap 8 used 5 free 3\na 0 5\ngaps 5+3\n", ""],
  [["map", "--heap", "12", "--fit", "best"], "alloc a 5\nalloc b 2\nalloc c 3\nfree a\nfree c\nalloc d 3\nalloc e 5\n", 0, "heap 12 used 10 free 2\nd 0 3\nb 5 2\ne 7 5\ngaps 3+2\n", ""],
  [["map", "--heap", "16"], "alloc a 4\nalloc b 5\nfree a\npin b\n", 0, "heap 16 used 5 free 11\nb 4 5 pinned\ngaps 0+4 9+7\n", ""],
  [["map", "--heap", "16"], "", 0, "heap 16 used 0 free 16\ngaps 0+16\n", ""]
].freeze

Harness.check_rows(rows)
