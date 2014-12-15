#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rev'

module CoffeeWithoutNodejs
  class CoffeeWatcher < Rev::StatWatcher
    def initialize(path)
      super
      attach(Rev::Loop.default)
    end

    def on_change
      render_file(path)
    end

    def self.run
      Rev::Loop.default.run
    end
  end
end
