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

      watch_files

      @notifier.watch(@path, :moved_from, :moved_to, :create, :delete, :onlydir, :recursive) do |event|
        # skip temp file.
        next if event.name =~ /^\.#|^#.*\#$/

        watch_files
      end

      puts @path
      # start loop.
      @notifier.run
    end

    # watch all exist files modify event.
    def watch_files
      Dir["#@path/**/*.coffee"].each do |file|
        @notifier.watch(file, :modify) do
          CoffeeWithoutNodejs.compile(file)
        end
      end
    end
  end
end
