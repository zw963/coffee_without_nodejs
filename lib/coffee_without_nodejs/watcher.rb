#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rb-inotify'
require 'singleton'

module CoffeeWithoutNodejs
  class CoffeeWatcher
    include Singleton

    def initialize
      @notifier = INotify::Notifier.new
      @path = File.expand_path('.')

      Signal.trap(2) {|sig| Process.exit }

      start_watch_files

      @notifier.watch(@path, :moved_from, :moved_to, :create, :delete, :onlydir, :recursive) do |event|
        # skip temp file.
        next if event.name =~ /^\.#|^#.*\#$/

          start_watch_files
      end

      coffee_files.each do |file|
        CoffeeCompiler.compile_file(file, true, true)
      end

      # start loop.
      @notifier.run
      puts 'CoffeeWatcher start successful.'
    end

    # watch all exist files modify event.
    def start_watch_files
      coffee_files.each do |file|
        @notifier.watch(file, :modify) do
          CoffeeCompiler.compile_file(file, true, true)
        end
      end
    end

    def coffee_files
      all_files = Dir["#@path/**/*.coffee"]
      if ENV['COFFEE_NOT_WATCH_PATTERN']
        all_files.reject! {|e| e =~ Regexp.union(ENV['COFFEE_NOT_WATCH_PATTERN']) }
      end
      all_files
    end
  end
end
