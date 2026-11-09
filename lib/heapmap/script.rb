# frozen_string_literal: true

module Heapmap
  module Script
    def self.lines(input)
      bytes = input.dup.force_encoding(Encoding::BINARY)
      result = []
      start = 0
      index = 0

      while index < bytes.bytesize
        if bytes.getbyte(index) == 10
          line = bytes.byteslice(start, index - start)
          line = line.byteslice(0, line.bytesize - 1) if line.end_with?("\r")
          result << line
          start = index + 1
        end
        index += 1
      end
      result << bytes.byteslice(start, bytes.bytesize - start) if start < bytes.bytesize
      raise Failure.new(1, "script is too long (max #{MAX_LINES} lines)") if result.length > MAX_LINES

      result
    end

    def self.words(line)
      tokens = line.split(/[ \t]+/)
      return [] if tokens.empty? || tokens.first.start_with?("#")

      tokens
    end

    def self.validate_name(word)
      return word if word.match?(/\A[a-z][a-z0-9_]{0,7}\z/)

      raise Failure.new(1, "bad name #{word}")
    end

    def self.parse_size(word, heap)
      raise Failure.new(1, "bad size #{word}") unless word.match?(/\A[1-9][0-9]*\z/)
      raise Failure.new(1, "size #{word} exceeds the heap") if word.to_i > heap

      word.to_i
    end
  end
end
