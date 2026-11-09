# frozen_string_literal: true

require "harness"

rows = [
  [["map", "--heap", "16"], "frob a 1\n", 1, "", "heapmap: line 1: unknown command frob\n"],
  [["map", "--heap", "16"], "alloc a\n", 1, "", "heapmap: line 1: bad arguments for alloc\n"],
  [["map", "--heap", "16"], "compact now\n", 1, "", "heapmap: line 1: bad arguments for compact\n"],
  [["map", "--heap", "16"], "alloc A 1\n", 1, "", "heapmap: line 1: bad name A\n"],
  [["map", "--heap", "16"], "alloc 1a 1\n", 1, "", "heapmap: line 1: bad name 1a\n"],
  [["map", "--heap", "16"], "alloc a b\n", 1, "", "heapmap: line 1: bad size b\n"],
  [["map", "--heap", "16"], "alloc a 0\n", 1, "", "heapmap: line 1: bad size 0\n"],
  [["map", "--heap", "16"], "alloc a 007\n", 1, "", "heapmap: line 1: bad size 007\n"],
  [["map", "--heap", "16"], "alloc a 17\n", 1, "", "heapmap: line 1: size 17 exceeds the heap\n"],
  [["map", "--heap", "16"], "alloc a 1\nalloc a 2\n", 1, "", "heapmap: line 2: a is already allocated\n"],
  [["map", "--heap", "16"], "free a\n", 1, "", "heapmap: line 1: unknown name a\n"],
  [["map", "--heap", "16"], "alloc a 1\npin a\nfree a\n", 1, "", "heapmap: line 3: a is pinned\n"],
  [["map", "--heap", "16"], "alloc a 2\ngrow a 2\n", 1, "", "heapmap: line 2: grow must enlarge a\n"],
  [["map", "--heap", "16"], "alloc a 2\npin a\npin a\n", 1, "", "heapmap: line 3: a is already pinned\n"],
  [["map", "--heap", "16"], "alloc a 2\nunpin a\n", 1, "", "heapmap: line 2: a is not pinned\n"],
  [["map", "--heap", "16"], "# note\n\n  \nalloc a 1\npin b\n", 1, "", "heapmap: line 5: unknown name b\n"],
  [["map", "--heap", "16"], "alloc a 1\r\nalloc b 2\r\nfree c\r\n", 1, "", "heapmap: line 3: unknown name c\n"],
  [["map", "--heap", "16"], "alloc a 1\ngrow b 2\nalloc a 0\n", 1, "", "heapmap: line 2: unknown name b\n"],
  [["map", "--heap", "16"], "alloc a 1 # x\n", 1, "", "heapmap: line 1: bad arguments for alloc\n"],
  [["map", "--heap", "16"], "\talloc\ta\t3\t\n", 0, "heap 16 used 3 free 13\na 0 3\ngaps 3+13\n", ""]
].freeze

Harness.check_rows(rows)
