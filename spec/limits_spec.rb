# frozen_string_literal: true

require "harness"

rows = [
  [["check"], "#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n", 0, "ok 0 commands\n", ""],
  [["check"], "#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n", 1, "", "heapmap: script is too long (max 40 lines)\n"],
  [["check"], "#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#", 1, "", "heapmap: script is too long (max 40 lines)\n"],
  [["check"], "#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\nalloc a 0\n", 1, "", "heapmap: script is too long (max 40 lines)\n"],
  [["check"], "alloc zz 0\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n", 1, "", "heapmap: script is too long (max 40 lines)\n"],
  [["check"], "alloc abcdefgh 1\n", 0, "ok 1 command\n", ""],
  [["check"], "alloc abcdefghi 1\n", 1, "", "heapmap: line 1: bad name abcdefghi\n"],
  [["check"], "alloc a 64\n", 0, "ok 1 command\n", ""],
  [["check"], "alloc a 65\n", 1, "", "heapmap: line 1: size 65 exceeds the heap\n"],
  [["map", "--heap", "256"], "alloc a 256\n", 0, "heap 256 used 256 free 0\na 0 256\ngaps none\n", ""],
  [["map", "--heap", "256"], "alloc a 257\n", 1, "", "heapmap: line 1: size 257 exceeds the heap\n"],
  [["check", "--heap", "1"], "alloc a 1\nalloc b 1\nfree a\n", 0, "ok 3 commands\n", ""],
  [["check", "--heap", "1"], "alloc a 2\n", 1, "", "heapmap: line 1: size 2 exceeds the heap\n"]
].freeze

Harness.check_rows(rows)
