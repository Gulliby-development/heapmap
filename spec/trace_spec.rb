# frozen_string_literal: true

require "harness"

rows = [
  [["trace", "--heap", "16"], "", 0, "", ""],
  [["trace", "--heap", "16"], "alloc a 4\nalloc b 20\nalloc b 5\n", 1, "", "heapmap: line 2: size 20 exceeds the heap\n"],
  [["trace", "--heap", "16"], "alloc a 4\nalloc b 5\nfree a\nfree b\n", 0, "alloc a 4 -> at 0\nalloc b 5 -> at 4\nfree a -> freed 4 at 0\nfree b -> freed 5 at 4\n", ""],
  [["trace", "--heap", "16"], "alloc a 4\nalloc b 5\ngrow a 5\n", 0, "alloc a 4 -> at 0\nalloc b 5 -> at 4\ngrow a 5 -> fail\n", ""],
  [["trace", "--heap", "16"], "alloc a 4\ngrow a 16\ngrow a 15\n", 1, "", "heapmap: line 3: grow must enlarge a\n"],
  [["trace", "--heap", "16"], "alloc a 2\npin a\nunpin a\n", 0, "alloc a 2 -> at 0\npin a -> ok\nunpin a -> ok\n", ""],
  [["trace", "--heap", "16"], "alloc a 4\nalloc b 4\nfree a\ncompact\n", 0, "alloc a 4 -> at 0\nalloc b 4 -> at 4\nfree a -> freed 4 at 0\ncompact -> moved 1\n", ""],
  [["trace", "--heap", "16"], "# comment\n\nalloc a 1\n  \ncompact\n", 0, "alloc a 1 -> at 0\ncompact -> moved 0\n", ""],
  [["trace", "--heap", "16"], "alloc a 16\nalloc b 1\nfree a\nalloc b 1\n", 0, "alloc a 16 -> at 0\nalloc b 1 -> fail\nfree a -> freed 16 at 0\nalloc b 1 -> at 0\n", ""],
  [["trace", "--heap", "16", "--fit", "best"], "alloc a 4\nalloc b 2\nalloc c 4\nfree a\nfree c\nalloc d 3\nalloc e 3\n", 0, "alloc a 4 -> at 0\nalloc b 2 -> at 4\nalloc c 4 -> at 6\nfree a -> freed 4 at 0\nfree c -> freed 4 at 6\nalloc d 3 -> at 0\nalloc e 3 -> at 6\n", ""]
].freeze

Harness.check_rows(rows)
