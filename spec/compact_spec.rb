# frozen_string_literal: true

require "harness"

rows = [
  [["map", "--heap", "16"], "alloc a 3\nalloc b 3\nalloc c 3\nfree a\nfree b\ncompact\n", 0, "heap 16 used 3 free 13\nc 0 3\ngaps 3+13\n", ""],
  [["trace", "--heap", "16"], "alloc a 3\nalloc b 3\nalloc c 3\nfree a\ncompact\n", 0, "alloc a 3 -> at 0\nalloc b 3 -> at 3\nalloc c 3 -> at 6\nfree a -> freed 3 at 0\ncompact -> moved 2\n", ""],
  [["map", "--heap", "16"], "alloc a 3\nalloc b 3\nalloc c 3\nfree a\npin b\ncompact\n", 0, "heap 16 used 6 free 10\nc 0 3\nb 3 3 pinned\ngaps 6+10\n", ""],
  [["trace", "--heap", "16"], "alloc a 3\nalloc b 3\nalloc c 3\nfree a\npin b\ncompact\n", 0, "alloc a 3 -> at 0\nalloc b 3 -> at 3\nalloc c 3 -> at 6\nfree a -> freed 3 at 0\npin b -> ok\ncompact -> moved 1\n", ""],
  [["map", "--heap", "16"], "alloc a 4\nalloc b 2\nalloc c 4\nfree b\npin c\ncompact\n", 0, "heap 16 used 8 free 8\na 0 4\nc 6 4 pinned\ngaps 4+2 10+6\n", ""],
  [["map", "--heap", "16"], "alloc a 2\nalloc b 6\nalloc c 2\nfree a\npin b\nalloc d 1\ncompact\n", 0, "heap 16 used 9 free 7\nd 0 1\nb 2 6 pinned\nc 8 2\ngaps 1+1 10+6\n", ""],
  [["trace", "--heap", "16"], "alloc a 2\nalloc b 2\ncompact\n", 0, "alloc a 2 -> at 0\nalloc b 2 -> at 2\ncompact -> moved 0\n", ""],
  [["trace", "--heap", "16"], "compact\n", 0, "compact -> moved 0\n", ""],
  [["map", "--heap", "16"], "alloc a 3\nalloc b 3\nalloc c 3\nfree a\npin b\ncompact\nunpin b\ncompact\n", 0, "heap 16 used 6 free 10\nc 0 3\nb 3 3\ngaps 6+10\n", ""],
  [["stats", "--heap", "16"], "alloc a 3\nalloc b 3\nalloc c 3\nalloc d 3\nfree a\nfree c\ncompact\n", 0, "blocks 2\nused 6\nfree 10\nlargest 10\nfrag 0\nallocs 4 ok 4 fail 0\n", ""]
].freeze

Harness.check_rows(rows)
