# frozen_string_literal: true

module Heapmap
  module Report
    def self.check(result)
      count = result[:command_count]
      noun = count == 1 ? "command" : "commands"
      "ok #{count} #{noun}\n"
    end

    def self.trace(result)
      result[:events].map { |event| trace_event(event) }.join
    end

    def self.map(result)
      heap = result[:heap]
      blocks = heap.ordered_blocks
      used = blocks.sum { |block| block[:size] }
      free = heap.size - used
      lines = ["heap #{heap.size} used #{used} free #{free}"]

      blocks.each do |block|
        line = "#{block[:name]} #{block[:start]} #{block[:size]}"
        line += " pinned" if block[:pinned]
        lines << line
      end

      gaps = heap.gaps.map { |start, length| "#{start}+#{length}" }
      lines << (gaps.empty? ? "gaps none" : "gaps #{gaps.join(" ")}")
      "#{lines.join("\n")}\n"
    end

    def self.stats(result)
      heap = result[:heap]
      used = heap.blocks.values.sum { |block| block[:size] }
      free = heap.size - used
      largest = heap.gaps.map(&:last).max || 0
      fragmentation = free.zero? ? 0 : ((free - largest) * 100) / free
      lines = [
        "blocks #{heap.blocks.length}",
        "used #{used}",
        "free #{free}",
        "largest #{largest}",
        "frag #{fragmentation}",
        "allocs #{result[:allocs]} ok #{result[:ok]} fail #{result[:fail]}"
      ]
      "#{lines.join("\n")}\n"
    end

    def self.trace_event(event)
      command = event[:command]
      name = event[:name]
      case command
      when "alloc"
        size = event[:requested_size] || event[:size]
        outcome = event[:success] ? "at #{event[:start]}" : "fail"
        "alloc #{name} #{size} -> #{outcome}\n"
      when "free"
        "free #{name} -> freed #{event[:freed_size]} at #{event[:start]}\n"
      when "grow"
        size = event[:requested_size] || event[:size]
        outcome = event[:success] ? "ok at #{event[:start]}" : "fail"
        "grow #{name} #{size} -> #{outcome}\n"
      when "pin", "unpin"
        "#{command} #{name} -> ok\n"
      when "compact"
        "compact -> moved #{event[:moved]}\n"
      end
    end
    private_class_method :trace_event
  end
end
