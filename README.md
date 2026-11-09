<p align="center"><img src="docs/logo.svg" width="96" alt="" /></p>

# heapmap

[![CI](https://github.com/Gulliby-development/heapmap/actions/workflows/ci.yml/badge.svg)](https://github.com/Gulliby-development/heapmap/actions/workflows/ci.yml) [![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

heapmap is a deterministic, offline command-line simulator for placing named allocations in a fixed heap. It is intended for allocator teaching, small-runtime experiments, and tuning or comparing fit policies. It uses only the Ruby standard library and runs with Ruby 3.4 on Windows, macOS, and Linux.

Run it from the repository directory:

```sh
ruby exe/heapmap COMMAND [OPTIONS] < script.txt
```

The program reads the script from standard input only for a valid `map`, `trace`, `stats`, or `check` invocation. Help, version, and invalid command lines do not read standard input. Successful commands write only their result to standard output. Errors write one line to standard error and no partial result to standard output.

## Commands and options

```text
usage: heapmap map [--heap N] [--fit POLICY]
       heapmap trace [--heap N] [--fit POLICY]
       heapmap stats [--heap N] [--fit POLICY]
       heapmap check [--heap N] [--fit POLICY]
```

The heap defaults to 64 cells. `--heap N` accepts a decimal integer from 1 through 256, with no leading zero. The fit policy defaults to `first`; `--fit POLICY` accepts exactly `first`, `best`, or `worst`. Each option may appear once. Options are checked from left to right; their next word is consumed as the value even if it looks like an option. For a recognized option, duplicate use is reported before a missing value, and a missing value before a bad value.

With no command, the usage text goes to standard error and the exit status is 2. `help`, `-h`, and `--help` print the four-line usage to standard output and exit 0, regardless of following words. `--version` prints `heapmap 0.1.0` and exits 0, regardless of following words. Any other first word produces `heapmap: unknown command WORD` and status 2.

Command-line errors also exit 2. A word that is empty, exactly `-`, or does not start with a hyphen produces `heapmap: unexpected argument WORD`; an unrecognized hyphenated word produces `heapmap: unknown option WORD`. Other exact option errors are `heapmap: given twice: OPTION`, `heapmap: missing value for OPTION`, and `heapmap: bad value for OPTION`.

## Script language

The heap contains HEAP cells numbered from 0. Each allocated block occupies a contiguous run of cells. Blocks do not overlap and remain at their addresses unless compacted. Free space is represented as maximal, contiguous gaps.

Input is split at each LF. A CR immediately before LF is removed, so LF and CRLF scripts work; a final line without LF is also processed. Other CR bytes are retained as line content. A script with more than 40 lines is rejected before any line is processed, even if the excess lines are comments. Exactly 40 lines are allowed. Each error identifies its one-based line number, including blank and comment lines.

Words are separated by spaces or tabs; those characters are ignored at the ends of a line. A line containing only spaces and tabs is skipped. A line is a comment only when its first word begins with `#`; inline comments are not supported. Names contain 1 to 8 ASCII characters: a lowercase letter followed by lowercase letters, digits, or underscores. Sizes are decimal integers from 1 through the heap size, without leading zeroes.

The six commands are:

- `alloc NAME SIZE` allocates a block using the selected fit policy. If no gap is large enough, the allocation fails without ending the script.
- `free NAME` releases an allocated block.
- `grow NAME SIZE` enlarges a block in place, only when the cells immediately after it are free and within the heap. It cannot shrink a block.
- `pin NAME` marks a block pinned. Pinned blocks cannot be freed or grown and are not moved by compaction.
- `unpin NAME` removes that protection.
- `compact` moves unpinned blocks in the address order they had when compaction began. Each is lifted and reinserted at the lowest-address gap that fits, using first-fit regardless of `--fit`. Pinned blocks stay in place. The operation reports how many blocks ended at a different start address.

Allocation policies apply among gaps large enough for the request. `first` chooses the lowest-address gap. `best` chooses the smallest fitting gap, breaking ties by lowest address. `worst` chooses the largest fitting gap, also breaking ties by lowest address.

Validation proceeds one command at a time. An unknown command reports `unknown command WORD`; a recognized command with the wrong number of words reports `bad arguments for COMMAND`. For `alloc`, checks then proceed through name, size, and duplicate allocation. For `free`, they proceed through name, existence, and pin state. For `grow`, they proceed through name, existence, size, pin state, and whether the requested size enlarges the block. For `pin` and `unpin`, they proceed through name, existence, and current pin state. `compact` has no further checks after its argument count. Invalid names produce `bad name WORD`; invalid sizes produce `bad size WORD`; valid sizes above the heap produce `size WORD exceeds the heap`.

State errors include `NAME is already allocated`, `unknown name NAME`, `NAME is pinned`, `grow must enlarge NAME`, `NAME is already pinned`, and `NAME is not pinned`. A failed allocation or in-place growth is not a script error and execution continues. Syntax or state errors stop processing and suppress any accumulated output.

Script errors exit 1 and are printed as `heapmap: line N: REASON`; an overlong script prints `heapmap: script is too long (max 40 lines)`. Every error is LF-terminated. Successful commands exit 0 and their output ends in LF when it contains lines.

## Reports

- `check` validates and executes the script, then prints `ok N command` for one executed command or `ok N commands` otherwise. Blank and comment lines are not counted. This is a stateful check, not syntax-only validation.
- `trace` prints one line per executed command: `alloc NAME SIZE -> at START` or `alloc NAME SIZE -> fail`; `free NAME -> freed SIZE at START`; `grow NAME SIZE -> ok at START` or `grow NAME SIZE -> fail`; `pin NAME -> ok`; `unpin NAME -> ok`; or `compact -> moved K`. An empty script produces no trace lines.
- `map` prints `heap HEAP used U free F`, then each block as `NAME START SIZE` in address order. Pinned blocks have ` pinned` appended. Its last line lists gaps in address order as `gaps START+LENGTH ...`, or `gaps none` if there is no free cell.
- `stats` prints six lines: `blocks B`, `used U`, `free F`, `largest L`, `frag P`, and `allocs A ok O fail X`. Fragmentation is the floored whole-number percentage `(F - L) * 100 / F`, or 0 when no cells are free. Allocation counters include only `alloc` commands: A is the number attempted, O the number that found space, and X the number that did not.

## Examples

The following transcripts are POSIX-shell examples run from the repository directory. In these examples, `heapmap` stands for this shell function:

```sh
heapmap() { ruby exe/heapmap "$@"; }
```

```text
$ printf 'alloc a 4\\nalloc b 5\\nfree a\\nalloc c 2\\n' | heapmap map --heap 16
heap 16 used 7 free 9
c 0 2
b 4 5
gaps 2+2 9+7
$ printf 'alloc a 4\\nalloc b 2\\nalloc c 4\\nfree a\\nfree c\\nalloc d 3\\n' | heapmap trace --heap 16 --fit best
alloc a 4 -> at 0
alloc b 2 -> at 4
alloc c 4 -> at 6
free a -> freed 4 at 0
free c -> freed 4 at 6
alloc d 3 -> at 0
$ printf 'alloc a 3\\nalloc b 3\\nalloc c 3\\nfree a\\npin b\\ncompact\\n' | heapmap map --heap 16; printf 'alloc a 3\\nalloc b 3\\nalloc c 3\\nfree a\\nfree c\\n' | heapmap stats --heap 16
heap 16 used 6 free 10
c 0 3
b 3 3 pinned
gaps 6+10
blocks 1
used 3
free 13
largest 10
frag 23
allocs 3 ok 3 fail 0
$ printf 'alloc a 1\\nfree b\\n' | heapmap check 2>&1; printf 'alloc a 1\\n' | heapmap check --heap 0 2>&1
heapmap: line 2: unknown name b
heapmap: bad value for --heap
```

## Development and implementation contracts

Run the project checks with:

```sh
bundle exec rubocop
bundle exec rspec
```

The command-line interface is `Heapmap::Cli.run(args, input)`: it returns a reply hash with integer `status` and string `out` and `err` values. `Heapmap::Cli.reads_stdin?(args)` returns whether a valid command invocation needs script input, without reading a stream or executing the script. The executable is the only component that reads or writes standard streams. Command-line failures return status 2; script failures return status 1 with an empty output string and a prefixed error line. The CLI converts `Heapmap::Failure` exceptions into that reply shape.

The registered handlers are `Heapmap::Commands.map_command(options, input)`, `trace_command(options, input)`, `stats_command(options, input)`, and `check_command(options, input)`. Each receives options containing `heap` and `fit`, plus the input string, and returns a reply hash or raises `Heapmap::Failure`. The library separates responsibilities among the CLI and registry, script parsing, heap operations, sequential execution and counters, reports, and command adapters. The project is distributed under the MIT License.

---

Built with [BAKED](https://github.com/Gulliby-development/baked), an open-source coding agent (bench round R93).
