# frozen_string_literal: true

require "harness"

rows = [
  [["map", "--heap", "16"], "alloc a 4\ngrow a 8\n", 0, "heap 16 used 8 free 8\na 0 8\ngaps 8+8\n", ""],
  [["map", "--heap", "16"], "alloc a 4\nalloc b 2\ngrow a 5\n", 0, "heap 16 used 6 free 10\na 0 4\nb 4 2\ngaps 6+10\n", ""],
  [["map", "--heap", "16"], "alloc a 4\nalloc b 2\nfree b\ngrow a 12\n", 0, "heap 16 used 12 free 4\na 0 12\ngaps 12+4\n", ""],
  [["map", "--heap", "16"], "alloc a 4\nalloc b 2\nfree b\ngrow a 16\n", 0, "heap 16 used 16 free 0\na 0 16\ngaps none\n", ""],
  [["trace", "--heap", "16"], "alloc a 12\nalloc b 2\nalloc c 2\nfree b\ngrow a 14\ngrow a 15\n", 0, "alloc a 12 -> at 0\nalloc b 2 -> at 12\nalloc c 2 -> at 14\nfree b -> freed 2 at 12\ngrow a 14 -> ok at 0\ngrow a 15 -> fail\n", ""],
  [["map", "--heap", "16"], "alloc a 4\nalloc b 4\nfree a\nalloc c 2\ngrow c 6\n", 0, "heap 16 used 6 free 10\nc 0 2\nb 4 4\ngaps 2+2 8+8\n", ""],
  [["map", "--heap", "16"], "alloc a 4\ngrow a 3\n", 1, "", "heapmap: line 2: grow must enlarge a\n"],
  [["map", "--heap", "16"], "alloc a 4\ngrow a 17\n", 1, "", "heapmap: line 2: size 17 exceeds the heap\n"],
  [["map", "--heap", "16"], "alloc a 4\npin a\ngrow a 6\n", 1, "", "heapmap: line 3: a is pinned\n"],
  [["map", "--heap", "16"], "alloc a 4\ngrow b 6\n", 1, "", "heapmap: line 2: unknown name b\n"],
  [["map", "--heap", "16"], "alloc a 4\npin a\nalloc b 3\n", 0, "heap 16 used 7 free 9\na 0 4 pinned\nb 4 3\ngaps 7+9\n", ""],
  [["map", "--heap", "16"], "alloc a 4\npin a\nunpin a\nfree a\n", 0, "heap 16 used 0 free 16\ngaps 0+16\n", ""]
].freeze

Harness.check_rows(rows)
