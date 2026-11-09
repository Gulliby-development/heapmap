# frozen_string_literal: true

require "harness"

rows = [
  [["stats", "--heap", "16"], "", 0, "blocks 0\nused 0\nfree 16\nlargest 16\nfrag 0\nallocs 0 ok 0 fail 0\n", ""],
  [["stats", "--heap", "16"], "alloc a 16\n", 0, "blocks 1\nused 16\nfree 0\nlargest 0\nfrag 0\nallocs 1 ok 1 fail 0\n", ""],
  [["stats", "--heap", "16"], "alloc a 4\nalloc b 4\nalloc c 4\nalloc d 4\nfree b\n", 0, "blocks 3\nused 12\nfree 4\nlargest 4\nfrag 0\nallocs 4 ok 4 fail 0\n", ""],
  [["stats", "--heap", "16"], "alloc a 3\nalloc b 3\nalloc c 3\nfree a\nfree c\n", 0, "blocks 1\nused 3\nfree 13\nlargest 10\nfrag 23\nallocs 3 ok 3 fail 0\n", ""],
  [["stats", "--heap", "16"], "alloc a 3\nalloc b 20\nalloc c 20\nalloc d 3\n", 1, "", "heapmap: line 2: size 20 exceeds the heap\n"],
  [["stats", "--heap", "16"], "alloc a 5\nalloc b 5\nalloc c 5\nfree b\nalloc d 6\nalloc e 5\n", 0, "blocks 3\nused 15\nfree 1\nlargest 1\nfrag 0\nallocs 5 ok 4 fail 1\n", ""],
  [["stats", "--heap", "7"], "alloc a 2\nalloc b 1\nfree a\nalloc c 1\n", 0, "blocks 2\nused 2\nfree 5\nlargest 4\nfrag 20\nallocs 3 ok 3 fail 0\n", ""],
  [["stats"], "alloc a 1\n", 0, "blocks 1\nused 1\nfree 63\nlargest 63\nfrag 0\nallocs 1 ok 1 fail 0\n", ""],
  [["check", "--heap", "16"], "", 0, "ok 0 commands\n", ""],
  [["check"], "alloc a 1\n", 0, "ok 1 command\n", ""],
  [["check", "--heap", "16"], "# only\n\nalloc a 1\nfree a\ncompact\n", 0, "ok 3 commands\n", ""],
  [["check", "--heap", "16"], "alloc a 1\nalloc b 1\n", 0, "ok 2 commands\n", ""],
  [["check", "--heap", "16"], "alloc a 1\nalloc a 1\n", 1, "", "heapmap: line 2: a is already allocated\n"]
].freeze

Harness.check_rows(rows)
