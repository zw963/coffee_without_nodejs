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

      start_watch_files

      @notifier.watch(@path, :moved_from, :moved_to, :create, :delete, :onlydir, :recursive) do |event|
        # skip temp file.
        next if event.name =~ /^\.#|^#.*\#$/

          start_watch_files
      end

      coffee_files.each do |file|
        CoffeeWithoutNodejs.compile(file)
      end

      # start loop.
      @notifier.run
      puts 'CoffeeWatcher start successful.'
    end

    # watch all exist files modify event.
    def start_watch_files
      coffee_files.each do |file|
        @notifier.watch(file, :modify) do
          CoffeeWithoutNodejs.compile(file)
        end
      end
    end

    def coffee_files
      Dir["#@path/**/*.coffee"]
    end
  end
end
