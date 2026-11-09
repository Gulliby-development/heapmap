# frozen_string_literal: true

require "heapmap/registry"
require "heapmap/script"
require "heapmap/heap"

module Heapmap
  module Runner
    def self.run(options, input)
      heap = Heap.new(options[:heap], options[:fit])
      events = []
      command_count = 0
      allocs = 0
      ok = 0
      fail = 0

      Script.lines(input).each_with_index do |line, index|
        words = Script.words(line.sub(/\A[ \t]+/, "").sub(/[ \t]+\z/, ""))
        next if words.empty?

        begin
          event = execute(words, heap)
        rescue Failure => e
          raise Failure.new(1, "line #{index + 1}: #{e.message}")
        end

        command_count += 1
        if event[:command] == "alloc"
          allocs += 1
          event[:success] ? ok += 1 : fail += 1
        end
        events << event
      end

      {
        heap: heap,
        events: events,
        command_count: command_count,
        allocs: allocs,
        ok: ok,
        fail: fail
      }
    end

    def self.execute(words, heap)
      command = words.first
      raise Failure.new(1, "unknown command #{command}") unless %w[alloc free grow pin unpin compact].include?(command)

      case command
      when "alloc"
        require_arity(words, 3, command)
        name = Script.validate_name(words[1])
        size = Script.parse_size(words[2], heap.size)
        raise Failure.new(1, "#{name} is already allocated") if heap.lookup(name)

        start = heap.alloc(name, size)
        { command: command, name: name, size: size, success: !start.nil?, start: start }
      when "free"
        require_arity(words, 2, command)
        name = Script.validate_name(words[1])
        block = heap.lookup(name)
        raise Failure.new(1, "unknown name #{name}") unless block
        raise Failure.new(1, "#{name} is pinned") if block[:pinned]

        size = block[:size]
        start = block[:start]
        heap.free(name)
        { command: command, name: name, freed_size: size, start: start }
      when "grow"
        require_arity(words, 3, command)
        name = Script.validate_name(words[1])
        block = heap.lookup(name)
        raise Failure.new(1, "unknown name #{name}") unless block

        size = Script.parse_size(words[2], heap.size)
        raise Failure.new(1, "#{name} is pinned") if block[:pinned]
        raise Failure.new(1, "grow must enlarge #{name}") unless size > block[:size]

        success = heap.grow(name, size)
        { command: command, name: name, size: size, success: success, start: success ? block[:start] : nil }
      when "pin"
        require_arity(words, 2, command)
        name = Script.validate_name(words[1])
        block = heap.lookup(name)
        raise Failure.new(1, "unknown name #{name}") unless block
        raise Failure.new(1, "#{name} is already pinned") if block[:pinned]

        heap.pin(name)
        { command: command, name: name, success: true }
      when "unpin"
        require_arity(words, 2, command)
        name = Script.validate_name(words[1])
        block = heap.lookup(name)
        raise Failure.new(1, "unknown name #{name}") unless block
        raise Failure.new(1, "#{name} is not pinned") unless block[:pinned]

        heap.unpin(name)
        { command: command, name: name, success: true }
      when "compact"
        require_arity(words, 1, command)
        { command: command, moved: heap.compact }
      end
    end

    def self.require_arity(words, expected, command)
      return if words.length == expected

      raise Failure.new(1, "bad arguments for #{command}")
    end
    private_class_method :execute, :require_arity
  end
end
