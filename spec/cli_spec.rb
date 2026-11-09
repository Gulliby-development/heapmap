# frozen_string_literal: true

require "harness"

rows = [
  [[], "", 2, "", "usage: heapmap map [--heap N] [--fit POLICY]\n       heapmap trace [--heap N] [--fit POLICY]\n       heapmap stats [--heap N] [--fit POLICY]\n       heapmap check [--heap N] [--fit POLICY]\n"],
  [["help"], "", 0, "usage: heapmap map [--heap N] [--fit POLICY]\n       heapmap trace [--heap N] [--fit POLICY]\n       heapmap stats [--heap N] [--fit POLICY]\n       heapmap check [--heap N] [--fit POLICY]\n", ""],
  [["-h", "extra"], "", 0, "usage: heapmap map [--heap N] [--fit POLICY]\n       heapmap trace [--heap N] [--fit POLICY]\n       heapmap stats [--heap N] [--fit POLICY]\n       heapmap check [--heap N] [--fit POLICY]\n", ""],
  [["--help", "--bogus"], "", 0, "usage: heapmap map [--heap N] [--fit POLICY]\n       heapmap trace [--heap N] [--fit POLICY]\n       heapmap stats [--heap N] [--fit POLICY]\n       heapmap check [--heap N] [--fit POLICY]\n", ""],
  [["--version"], "", 0, "heapmap 0.1.0\n", ""],
  [["--version", "x"], "", 0, "heapmap 0.1.0\n", ""],
  [["frob"], "", 2, "", "heapmap: unknown command frob\n"],
  [[""], "", 2, "", "heapmap: unknown command \n"],
  [["Map"], "", 2, "", "heapmap: unknown command Map\n"],
  [["--heap"], "", 2, "", "heapmap: unknown command --heap\n"],
  [["--fit", "first"], "", 2, "", "heapmap: unknown command --fit\n"],
  [["help", "map"], "", 0, "usage: heapmap map [--heap N] [--fit POLICY]\n       heapmap trace [--heap N] [--fit POLICY]\n       heapmap stats [--heap N] [--fit POLICY]\n       heapmap check [--heap N] [--fit POLICY]\n", ""]
].freeze

Harness.check_rows(rows)
