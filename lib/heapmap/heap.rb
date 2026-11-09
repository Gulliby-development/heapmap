# frozen_string_literal: true

module Heapmap
  class Heap
    attr_reader :size, :fit, :blocks

    def initialize(size, fit)
      @size = size
      @fit = fit
      @blocks = {}
    end

    def lookup(name)
      @blocks[name]
    end

    def ordered_blocks
      @blocks.values.sort_by { |block| block[:start] }
    end

    def gaps
      free_gaps = []
      cursor = 0

      ordered_blocks.each do |block|
        free_gaps << [cursor, block[:start] - cursor] if block[:start] > cursor
        cursor = block[:start] + block[:size]
      end
      free_gaps << [cursor, @size - cursor] if cursor < @size
      free_gaps
    end

    def alloc(name, block_size)
      return nil if @blocks.key?(name)

      gap = selected_gap(block_size, @fit)
      return nil unless gap

      @blocks[name] = {
        name: name,
        start: gap[0],
        size: block_size,
        pinned: false
      }
      gap[0]
    end

    def free(name)
      block = @blocks.delete(name)
      block && block[:size]
    end

    def grow(name, new_size)
      block = lookup(name)
      return false unless block

      additional = new_size - block[:size]
      return false if additional <= 0

      free_after = gaps.find { |start, _length| start == block[:start] + block[:size] }
      return false unless free_after && free_after[1] >= additional

      block[:size] = new_size
    end

    def pin(name)
      block = lookup(name)
      return false unless block

      block[:pinned] = true
      block
    end

    def unpin(name)
      block = lookup(name)
      return false unless block

      block[:pinned] = false
      block
    end

    def compact
      moving = ordered_blocks.reject { |block| block[:pinned] }
      original_starts = moving.to_h { |block| [block[:name], block[:start]] }

      moving.each do |block|
        @blocks.delete(block[:name])
        destination = selected_gap(block[:size], "first")
        block[:start] = destination[0]
        @blocks[block[:name]] = block
      end

      moving.count { |block| block[:start] != original_starts[block[:name]] }
    end

    private

    def selected_gap(block_size, policy)
      candidates = gaps.select { |_start, length| length >= block_size }
      case policy
      when "best"
        candidates.min_by { |start, length| [length, start] }
      when "worst"
        candidates.min_by { |start, length| [-length, start] }
      else
        candidates.min_by(&:first)
      end
    end
  end
end
